#!/usr/bin/env -S pixi run python
"""
Generate ground-truth rendering test data from conda-forge feedstocks.

This script:
1. Downloads feedstock-stats.toml to find feedstocks with recipe_v1 (recipe.yaml)
2. Clones each feedstock and extracts:
   - The recipe folder
   - Variant files from .ci_support
   - Expected rendering output from rattler-build --render-only
3. Extracts target_platform from variant files to pass to rattler-build

Usage:
  ./generate_rendering_tests.py                    # Generate tests for 200 feedstocks
  ./generate_rendering_tests.py --count 50         # Generate tests for 50 feedstocks
  ./generate_rendering_tests.py --feedstock numpy  # Generate test for specific feedstock
"""

import argparse
import json
import os
import random
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import urllib.request

try:
    import tomli
except ImportError:
    import tomllib as tomli

import yaml


# Output directory for test data
RENDERING_TESTS_DIR = Path(__file__).parent / "rendering-tests"


def download_feedstock_stats() -> Dict:
    """Download and parse the feedstock-stats.toml file."""
    url = "https://raw.githubusercontent.com/tdejager/are-we-recipe-v1-yet/refs/heads/main/feedstock-stats.toml"
    print(f"Downloading feedstock stats from {url}...")

    with urllib.request.urlopen(url) as response:
        content = response.read()

    return tomli.loads(content.decode('utf-8'))


def get_recipe_yaml_feedstocks(stats: Dict) -> List[str]:
    """Extract feedstock names that have recipe_v1 (recipe.yaml) files."""
    feedstocks = []

    feedstock_states = stats.get('feedstock_states', {})

    for feedstock_name, feedstock_data in feedstock_states.items():
        if isinstance(feedstock_data, dict) and feedstock_data.get('recipe_type') == 'recipe_v1':
            clean_name = feedstock_name.replace('-feedstock', '')
            feedstocks.append(clean_name)

    print(f"Found {len(feedstocks)} feedstocks with recipe_v1 (recipe.yaml) files")
    return feedstocks


def select_random_feedstocks(feedstocks: List[str], count: int = 200) -> List[str]:
    """Select random feedstocks from the list."""
    if len(feedstocks) <= count:
        return feedstocks
    return random.sample(feedstocks, count)


def clone_feedstock(feedstock_name: str, target_dir: Path) -> Path:
    """Clone a feedstock repository."""
    repo_url = f"https://github.com/conda-forge/{feedstock_name}-feedstock.git"
    clone_path = target_dir / f"{feedstock_name}-feedstock"

    print(f"  Cloning {repo_url}...")
    try:
        subprocess.run(
            ["git", "clone", "--depth", "1", repo_url, str(clone_path)],
            check=True,
            capture_output=True,
            text=True
        )
        return clone_path
    except subprocess.CalledProcessError as e:
        print(f"  Failed to clone {feedstock_name}: {e.stderr}")
        raise


def find_ci_support_files(feedstock_path: Path) -> List[Path]:
    """Find all YAML files in the .ci_support directory."""
    ci_support_dir = feedstock_path / ".ci_support"
    if not ci_support_dir.exists():
        return []

    yaml_files = list(ci_support_dir.glob("*.yaml"))
    return yaml_files


def extract_target_platform(variant_file: Path) -> Optional[str]:
    """Extract target_platform from a variant YAML file."""
    try:
        with open(variant_file, 'r') as f:
            content = yaml.safe_load(f)

        if content and isinstance(content, dict):
            target_platform = content.get('target_platform')
            if target_platform:
                # target_platform might be a list in some cases
                if isinstance(target_platform, list):
                    return target_platform[0] if target_platform else None
                return str(target_platform)
    except Exception as e:
        print(f"    Warning: Could not parse variant file {variant_file}: {e}")

    return None


def run_rattler_build(
    rattler_build_cmd: str,
    recipe_path: Path,
    variant_file: Optional[Path] = None,
    target_platform: Optional[str] = None
) -> Tuple[bool, str]:
    """Run rattler-build with --render-only and return success status and JSON output."""
    recipe_yaml = recipe_path / "recipe.yaml"
    if not recipe_yaml.exists():
        return False, f"recipe.yaml not found in {recipe_path}"

    cmd = [rattler_build_cmd, "build", "--no-build-id", "--recipe", str(recipe_yaml), "--render-only"]

    if variant_file:
        cmd.extend(["-m", str(variant_file)])

    if target_platform:
        cmd.extend(["--target-platform", target_platform])

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=120
        )

        if result.returncode == 0:
            return True, result.stdout
        else:
            return False, result.stderr
    except subprocess.TimeoutExpired:
        return False, "Command timed out"
    except Exception as e:
        return False, str(e)


def normalize_json_output(output: str) -> Dict:
    """Parse and normalize JSON output."""
    try:
        return json.loads(output)
    except json.JSONDecodeError:
        lines = output.strip().split('\n')
        for line in lines:
            try:
                return json.loads(line)
            except json.JSONDecodeError:
                continue
        raise ValueError("Could not parse JSON from output")


def sanitize_filename(name: str) -> str:
    """Sanitize a string to be safe for use as a filename."""
    return name.replace('/', '_').replace('\\', '_').replace('.yaml', '').replace('.', '_')


def process_feedstock(
    feedstock_name: str,
    temp_dir: Path,
    rattler_build_cmd: str,
    output_dir: Path
) -> Dict:
    """Process a single feedstock and generate test data."""
    print(f"\nProcessing feedstock: {feedstock_name}")
    print("-" * 60)

    result = {
        'feedstock': feedstock_name,
        'variants_processed': 0,
        'variants_success': 0,
        'variants_failed': [],
        'errors': []
    }

    try:
        # Clone the feedstock
        feedstock_path = clone_feedstock(feedstock_name, temp_dir)

        # Find recipe directory
        recipe_path = feedstock_path / "recipe"
        if not recipe_path.exists():
            result['errors'].append("No recipe directory found")
            return result

        # Create output directory for this feedstock
        feedstock_output_dir = output_dir / feedstock_name
        feedstock_output_dir.mkdir(parents=True, exist_ok=True)

        # Copy the entire recipe folder
        recipe_output_dir = feedstock_output_dir / "recipe"
        if recipe_output_dir.exists():
            shutil.rmtree(recipe_output_dir)
        shutil.copytree(recipe_path, recipe_output_dir)
        print(f"  Copied recipe folder")

        # Find variant files
        variant_files = find_ci_support_files(feedstock_path)

        if not variant_files:
            print("  No variant files found, testing without variants...")
            variant_files = [None]
        else:
            print(f"  Found {len(variant_files)} variant files")

            # Copy variant files
            variants_output_dir = feedstock_output_dir / "variants"
            variants_output_dir.mkdir(exist_ok=True)
            for vf in variant_files:
                if vf:
                    shutil.copy(vf, variants_output_dir / vf.name)
            print(f"  Copied variant files")

        # Create expected outputs directory
        expected_dir = feedstock_output_dir / "expected"
        expected_dir.mkdir(exist_ok=True)

        # Process each variant
        for variant_file in variant_files:
            variant_name = variant_file.name if variant_file else "no-variant"
            safe_variant_name = sanitize_filename(variant_name)

            print(f"  Processing variant: {variant_name}")
            result['variants_processed'] += 1

            # Extract target_platform from variant file
            target_platform = None
            if variant_file:
                target_platform = extract_target_platform(variant_file)
                if target_platform:
                    print(f"    Target platform: {target_platform}")

            # Run rattler-build
            variant_path = feedstock_output_dir / "variants" / variant_name if variant_file else None
            success, output = run_rattler_build(
                rattler_build_cmd,
                recipe_path,
                variant_file,
                target_platform
            )

            if success:
                try:
                    # Parse and save the JSON output
                    json_output = normalize_json_output(output)

                    # Save expected output
                    expected_file = expected_dir / f"{safe_variant_name}.json"
                    with open(expected_file, 'w') as f:
                        json.dump(json_output, f, indent=2, sort_keys=True)

                    # Save metadata about this variant
                    metadata = {
                        'variant_file': variant_name if variant_file else None,
                        'target_platform': target_platform
                    }
                    metadata_file = expected_dir / f"{safe_variant_name}.meta.json"
                    with open(metadata_file, 'w') as f:
                        json.dump(metadata, f, indent=2)

                    print(f"    ✓ Saved expected output")
                    result['variants_success'] += 1

                except Exception as e:
                    print(f"    ✗ Failed to parse/save output: {e}")
                    result['variants_failed'].append({
                        'variant': variant_name,
                        'reason': 'parse_error',
                        'error': str(e)
                    })
            else:
                print(f"    ✗ Rendering failed: {output[:200]}")
                result['variants_failed'].append({
                    'variant': variant_name,
                    'reason': 'render_failed',
                    'error': output[:500]
                })

        # If no variants succeeded, remove the feedstock directory
        if result['variants_success'] == 0:
            shutil.rmtree(feedstock_output_dir)
            print(f"  Removed feedstock directory (no successful variants)")

    except Exception as e:
        print(f"  Error: {e}")
        result['errors'].append(str(e))
    finally:
        # Clean up cloned feedstock
        feedstock_clone_path = temp_dir / f"{feedstock_name}-feedstock"
        if feedstock_clone_path.exists():
            try:
                shutil.rmtree(feedstock_clone_path)
            except:
                pass

    return result


def main():
    parser = argparse.ArgumentParser(
        description="Generate ground-truth rendering test data from conda-forge feedstocks"
    )
    parser.add_argument(
        "--count", "-c",
        type=int,
        default=200,
        help="Number of random feedstocks to process (default: 200)"
    )
    parser.add_argument(
        "--feedstock", "-f",
        type=str,
        help="Process a specific feedstock instead of random selection"
    )
    parser.add_argument(
        "--rattler-build", "-r",
        type=str,
        default="rattler-build",
        help="Path to rattler-build command (default: rattler-build)"
    )
    parser.add_argument(
        "--output", "-o",
        type=str,
        default=str(RENDERING_TESTS_DIR),
        help=f"Output directory for test data (default: {RENDERING_TESTS_DIR})"
    )
    parser.add_argument(
        "--seed", "-s",
        type=int,
        help="Random seed for reproducible selection"
    )

    args = parser.parse_args()

    if args.seed is not None:
        random.seed(args.seed)

    output_dir = Path(args.output)
    rattler_build_cmd = args.rattler_build

    print("=" * 80)
    print("Generating Ground-Truth Rendering Test Data")
    print("=" * 80)

    # Verify rattler-build command exists
    try:
        result = subprocess.run(
            [rattler_build_cmd, "--version"],
            capture_output=True,
            text=True,
            check=True
        )
        print(f"Using rattler-build: {rattler_build_cmd}")
        print(f"Version: {result.stdout.strip()}")
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"Error: Could not run rattler-build command: {rattler_build_cmd}")
        print(f"Details: {e}")
        sys.exit(1)

    print(f"Output directory: {output_dir}")

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Determine which feedstocks to process
    if args.feedstock:
        selected_feedstocks = [args.feedstock]
        print(f"Processing specific feedstock: {args.feedstock}")
    else:
        # Download and parse feedstock stats
        stats = download_feedstock_stats()
        feedstocks = get_recipe_yaml_feedstocks(stats)
        selected_feedstocks = select_random_feedstocks(feedstocks, args.count)
        print(f"Selected {len(selected_feedstocks)} random feedstocks")

    # Process feedstocks
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        all_results = []

        for i, feedstock in enumerate(selected_feedstocks, 1):
            print(f"\n[{i}/{len(selected_feedstocks)}]")
            result = process_feedstock(feedstock, temp_path, rattler_build_cmd, output_dir)
            all_results.append(result)

    # Print summary
    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)

    total_processed = sum(r['variants_processed'] for r in all_results)
    total_success = sum(r['variants_success'] for r in all_results)
    feedstocks_with_data = len([r for r in all_results if r['variants_success'] > 0])

    print(f"Feedstocks processed: {len(all_results)}")
    print(f"Feedstocks with test data: {feedstocks_with_data}")
    print(f"Total variants processed: {total_processed}")
    print(f"Total variants successful: {total_success}")
    print(f"Success rate: {100 * total_success / total_processed if total_processed > 0 else 0:.1f}%")
    print(f"\nTest data saved to: {output_dir}")

    # Save generation metadata
    metadata = {
        'generated_with': rattler_build_cmd,
        'feedstocks_processed': len(all_results),
        'feedstocks_with_data': feedstocks_with_data,
        'total_variants': total_processed,
        'successful_variants': total_success,
        'results': all_results
    }
    metadata_file = output_dir / "generation_metadata.json"
    with open(metadata_file, 'w') as f:
        json.dump(metadata, f, indent=2)
    print(f"Metadata saved to: {metadata_file}")

    # Exit with appropriate code
    sys.exit(0 if feedstocks_with_data > 0 else 1)


if __name__ == "__main__":
    main()

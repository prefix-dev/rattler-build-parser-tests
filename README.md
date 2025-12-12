# Rendering tests for rattler-build

The recipes in this repository are sourced from [conda-forge](https://github.com/conda-forge) and are used for testing the rattler-build recipe parser.

## Requirements

- Python 3 with `pyyaml`, `tomli` (or `tomllib` on Python 3.11+), and optionally `deepdiff`
- `rattler-build` source code at `../rattler-build` (or specify custom path)
- Rust/Cargo (for building rattler-build)
- Git (for cloning feedstocks)

## Quick Start

The test suite is configured to use a local debug build of rattler-build from `../rattler-build/target/debug/rattler-build`.

```bash
# Build rattler-build and run all tests
./test.sh

# Build and run quick smoke test (1 variant per feedstock, parallel)
./test.sh --fast

# Build and run tests in parallel (recommended)
./test.sh --jobs 50

# Build and test a specific feedstock
./test.sh --feedstock numpy
```

## Scripts

### test.sh

Build rattler-build and run the rendering tests in one command.

```bash
# Build rattler-build and run all tests
./test.sh

# Build and run quick smoke test (recommended for fast iteration)
./test.sh --fast

# Build and run tests in parallel
./test.sh --jobs 50

# Build and test a specific feedstock
./test.sh --feedstock numpy

# Build and stop on first failure
./test.sh --fail-fast
```

This script:
1. Builds rattler-build with `cargo b` in `../rattler-build`
2. Runs `run_rendering_tests.py` with the built binary
3. Passes any additional arguments through to the test runner

**Tip:** Use `--fast` for quick feedback during development. It tests only one variant per feedstock in parallel (typically completes in seconds instead of minutes).

### generate_rendering_tests.py

Generates ground-truth test data by cloning conda-forge feedstocks and rendering them with rattler-build.

**Default rattler-build path:** `../rattler-build/target/debug/rattler-build`

```bash
# Generate tests for 200 random feedstocks (default)
./generate_rendering_tests.py

# Generate tests in parallel (much faster)
./generate_rendering_tests.py --jobs 10

# Generate tests for a specific number of feedstocks
./generate_rendering_tests.py --count 50

# Generate test for a specific feedstock
./generate_rendering_tests.py --feedstock numpy

# Use a specific rattler-build binary
./generate_rendering_tests.py --rattler-build /path/to/rattler-build

# Set random seed for reproducible selection
./generate_rendering_tests.py --seed 42

# Specify output directory
./generate_rendering_tests.py --output ./my-tests

# Generate many feedstocks in parallel (recommended)
./generate_rendering_tests.py --count 100 --jobs 20
```

### run_rendering_tests.py

Runs the test suite, comparing rattler-build output against the ground-truth data.

**Default rattler-build path:** `../rattler-build/target/debug/rattler-build`

```bash
# Run all tests (sequential)
./run_rendering_tests.py

# Fast mode: test 1 variant per feedstock in parallel (quick smoke test)
./run_rendering_tests.py --fast

# Run tests in parallel (recommended for large test suites)
./run_rendering_tests.py --jobs 50

# Test a specific feedstock
./run_rendering_tests.py --feedstock numpy

# Stop on first failure
./run_rendering_tests.py --fail-fast

# Save diff files for failures
./run_rendering_tests.py --save-diffs ./diffs

# Save results to JSON
./run_rendering_tests.py --json-output results.json

# Re-run only previously failing tests
./run_rendering_tests.py --rerun-failures test_failures.json

# Use a specific rattler-build binary
./run_rendering_tests.py --rattler-build /path/to/rattler-build

# Verbose output
./run_rendering_tests.py --verbose
```

### render.sh

A convenience script for quickly rendering a single feedstock recipe.

**Default rattler-build path:** `../rattler-build/target/debug/rattler-build`

```bash
# Render a feedstock (picks first variant)
./render.sh nwchem

# Render with a specific variant pattern
./render.sh nwchem linux*
./render.sh hf-xet "linux_64*"

# Use a custom rattler-build binary
RATTLER_BUILD=/path/to/rattler-build ./render.sh nwchem

# Use cargo run instead of a binary
USE_CARGO=1 ./render.sh nwchem
```

## Directory Structure

```
rendering-tests/
├── <feedstock-name>/
│   ├── recipe/           # The recipe.yaml and supporting files
│   ├── variants/         # Variant YAML files from .ci_support
│   └── expected/         # Expected rattler-build --render-only output
│       ├── <variant>.json       # Expected JSON output
│       └── <variant>.meta.json  # Metadata (variant file, target platform)
└── generation_metadata.json     # Metadata about the generation run
```

## License

This project is licensed under the BSD-3-Clause License - see the [LICENSE](LICENSE) file for details.

The recipes contained in `rendering-tests/` are derived from conda-forge feedstocks, which are also licensed under BSD-3-Clause.
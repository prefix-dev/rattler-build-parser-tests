#!/bin/bash

# Render a recipe with a variant file
# Usage: ./render.sh <feedstock> [variant_glob]
# Examples:
#   ./render.sh nwchem                    # picks first variant
#   ./render.sh nwchem linux*             # picks first matching linux* variant
#   ./render.sh hf-xet "linux_64*"        # picks first matching linux_64* variant

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <feedstock> [variant_glob]"
    echo "Example: $0 nwchem linux*"
    exit 1
fi

FEEDSTOCK="$1"
VARIANT_GLOB="${2:-*}"

RECIPE_DIR="./rendering-tests/${FEEDSTOCK}/recipe"
VARIANTS_DIR="./rendering-tests/${FEEDSTOCK}/variants"

if [ ! -d "$RECIPE_DIR" ]; then
    echo "Error: Recipe directory not found: $RECIPE_DIR"
    exit 1
fi

if [ ! -d "$VARIANTS_DIR" ]; then
    echo "Error: Variants directory not found: $VARIANTS_DIR"
    exit 1
fi

# Find first matching variant file
VARIANT_FILE=$(ls "$VARIANTS_DIR"/${VARIANT_GLOB}.yaml 2>/dev/null | head -1)

if [ -z "$VARIANT_FILE" ]; then
    echo "Error: No variant file matching '$VARIANT_GLOB' found in $VARIANTS_DIR"
    echo "Available variants:"
    ls "$VARIANTS_DIR"/*.yaml 2>/dev/null | sed 's/.*\//  /'
    exit 1
fi

echo "Recipe: $RECIPE_DIR/recipe.yaml"
echo "Variant: $VARIANT_FILE"
echo ""

cargo r --release -- build --recipe "$RECIPE_DIR/recipe.yaml" -m "$VARIANT_FILE" --render-only --no-build-id --log-style plain

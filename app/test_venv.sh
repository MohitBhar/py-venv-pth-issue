#!/bin/bash

set -e

# Clean up and create venv
rm -rf ./.app+venv ./.venv
export BUILD_WORKING_DIRECTORY="$(pwd)"
export BUILD_WORKSPACE_DIRECTORY="$(pwd)"
./app/venv

# Find and activate venv
VENV_PATH=$(find . -name ".app+venv" | head -1)
if [ -z "$VENV_PATH" ]; then
    echo "❌ Could not find venv directory"
    exit 1
fi

source "$VENV_PATH/bin/activate"

echo "Testing import: from calculator import add"
if OUTPUT=$(python -c "from calculator import add; print('✅ Import successful')" 2>&1); then
    echo "$OUTPUT"
else
    echo "❌ REGRESSION DETECTED"
    echo "$OUTPUT"
    exit 1
fi

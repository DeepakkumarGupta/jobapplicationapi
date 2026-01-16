#!/bin/bash
set -e

echo "Building application..."
npm install
echo "✓ Dependencies installed"

npm run build
echo "✓ TypeScript compiled"

# Verify dist folder exists
if [ ! -d "dist" ]; then
  echo "✗ ERROR: dist/ folder not created after build"
  exit 1
fi

echo "✓ Build successful"

#!/bin/bash

# Test script for install.lua
# This script helps validate the installation process

echo "🧪 Testing install.lua script..."

# Test 1: Dry run
echo "Test 1: Dry run mode"
lua install.lua --dry-run
if [ $? -eq 0 ]; then
    echo "✅ Dry run completed successfully"
else
    echo "❌ Dry run failed"
    exit 1
fi

# Test 2: Syntax check
echo "Test 2: Lua syntax check"
lua -l install.lua
if [ $? -eq 0 ]; then
    echo "✅ Syntax is valid"
else
    echo "❌ Syntax error found"
    exit 1
fi

# Test 3: Check required files exist
echo "Test 3: Checking required files"
required_files=("config.fish" "paths.lua" "nvim/init.lua" "river/init.lua" "themes.toml")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

echo "🎉 All tests passed!"
echo "💡 To test on a real system:"
echo "   1. Use a VM or Docker container"
echo "   2. Run: ./install.lua"
echo "   3. Verify symlinks: ls -la ~/.config/"
#!/bin/bash

cd "$(dirname "$0")/.."

echo "========================================="
echo "Running VM tests..."
echo "========================================="
flutter test --exclude-tags chrome

echo ""
echo "========================================="
echo "Running Chrome tests..."
echo "========================================="
# Find all test files with @TestOn('chrome') and run them in one command
echo "Searching for files..."
CHROME_TESTS=$(grep -r "@TestOn('chrome')" test/ --include="*_test.dart" -l | tr '\n' ' ')
echo "Running tests..."
if [ -z "$CHROME_TESTS" ]; then
    echo "No Chrome tests found"
else
    flutter test --platform chrome $CHROME_TESTS
fi

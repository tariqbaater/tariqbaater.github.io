#!/usr/bin/env bash
# Tests for publish-blog.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Running publish-blog.sh tests..."

# Test 1: Script exists and is executable
echo "Test 1: Script exists and is executable"
if [ -f "$SCRIPT_DIR/publish-blog.sh" ] && [ -x "$SCRIPT_DIR/publish-blog.sh" ]; then
    echo "✓ Script exists and is executable"
else
    echo "✗ Script missing or not executable"
    exit 1
fi

# Test 2: Script handles missing arguments
echo "Test 2: Missing arguments shows usage"
output=$(bash "$SCRIPT_DIR/publish-blog.sh" 2>&1 || true)
if echo "$output" | grep -q "Usage"; then
    echo "✓ Shows usage on missing args"
else
    echo "✗ Should show usage message"
    exit 1
fi

# Test 3: Hugo config exists
echo "Test 3: Hugo config exists"
if [ -f "$PROJECT_ROOT/my-hugo-site/hugo.toml" ]; then
    echo "✓ hugo.toml exists"
else
    echo "✗ hugo.toml missing"
    exit 1
fi

# Test 4: Theme directory exists (or can be cloned)
echo "Test 4: Theme submodule initialized"
if [ -d "$PROJECT_ROOT/my-hugo-site/themes/PaperMod" ]; then
    echo "✓ PaperMod theme exists"
else
    echo "✗ PaperMod theme missing"
    exit 1
fi

# Test 5: Content directory structure
echo "Test 5: Content directory structure"
if [ -d "$PROJECT_ROOT/my-hugo-site/content/posts" ]; then
    POST_COUNT=$(find "$PROJECT_ROOT/my-hugo-site/content/posts" -name "*.md" | wc -l)
    echo "✓ Content posts directory exists with $POST_COUNT posts"
else
    echo "✗ Content posts directory missing"
    exit 1
fi

# Test 6: Check for required config options
echo "Test 6: Hugo config has required options"
if grep -q "baseURL" "$PROJECT_ROOT/my-hugo-site/hugo.toml" && \
   grep -q "theme" "$PROJECT_ROOT/my-hugo-site/hugo.toml" && \
   grep -q "title" "$PROJECT_ROOT/my-hugo-site/hugo.toml"; then
    echo "✓ Config has baseURL, theme, and title"
else
    echo "✗ Config missing required options"
    exit 1
fi

# Test 7: CI workflow exists
echo "Test 7: GitHub Actions workflow exists"
if [ -f "$PROJECT_ROOT/.github/workflows/build-test.yml" ]; then
    echo "✓ CI workflow exists"
else
    echo "✗ CI workflow missing"
    exit 1
fi

echo ""
echo "✅ All publish-blog.sh tests passed!"
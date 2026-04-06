#!/usr/bin/env bash
#
# Usage:
#   publish-blog.sh "Post Title" < post-content.md
#   publish-blog.sh "Post Title" --file /path/to/post.md
#
# Expects Hugo markdown with front matter on stdin or via --file.
# Writes to hugo-blog source, builds, and pushes to tariqbaater.github.io.

set -euo pipefail

BLOG_SRC="$HOME/.openclaw/workspace/tariq/Blog/my-hugo-site"
DEPLOY_REPO="$HOME/.openclaw/workspace/tariq/Blog/"
TITLE="${1:-}"

if [ -z "$TITLE" ]; then
  echo "Usage: $0 \"Post Title\" [--file path]" >&2
  exit 1
fi

# Generate slug from title
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
YEAR=$(date +%Y)
POST_DIR="$BLOG_SRC/content/posts/$YEAR"
POST_FILE="$POST_DIR/$SLUG.md"

mkdir -p "$POST_DIR"

# Read content from file or stdin
if [ "${2:-}" = "--file" ] && [ -n "${3:-}" ]; then
  cp "$3" "$POST_FILE"
else
  cat > "$POST_FILE"
fi

echo "[publish] Wrote post to $POST_FILE"

# Ensure deploy repo is cloned
if [ ! -d "$DEPLOY_REPO" ]; then
  echo "[publish] Cloning tariqbaater.github.io..."
  gh repo clone tariqbaater/tariqbaater.github.io "$DEPLOY_REPO"
fi

cd "$DEPLOY_REPO"

# Detect the default branch (main or master)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$DEFAULT_BRANCH" ]; then
  # Fallback for older git versions
  DEFAULT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
fi
echo "[publish] Using branch: $DEFAULT_BRANCH"

git pull origin $DEFAULT_BRANCH 2>/dev/null || true

# Build Hugo
cd "$BLOG_SRC"

# Respect configured theme (no forced theme override)
HUGO_CONFIG="hugo.toml"
[ -f "config.toml" ] && HUGO_CONFIG="config.toml"
THEME=$(grep -E "^theme\s*=\s*['\"]" "$HUGO_CONFIG" | head -n1 | sed -E "s/^theme\s*=\s*['\"]([^'\"]+)['\"].*/\1/")

if [ -z "$THEME" ]; then
  echo "[publish] WARNING: No theme configured in $HUGO_CONFIG"
else
  if [ ! -d "themes/$THEME" ]; then
    echo "[publish] ERROR: Theme '$THEME' not found at themes/$THEME"
    echo "[publish] Please install it first (or add as git submodule), then rerun."
    exit 1
  fi
  echo "[publish] Using theme: $THEME"
fi

echo "[publish] Building Hugo site..."
if ! hugo --destination "$DEPLOY_REPO/" --baseURL "https://tariqbaater.github.io/" 2>&1; then
  echo "[publish] ERROR: Hugo build failed. Aborting commit."
  exit 1
fi

# Verify build output exists
if [ ! -f "$DEPLOY_REPO/index.html" ]; then
  echo "[publish] ERROR: Build output missing (no index.html). Aborting commit."
  exit 1
fi

echo "[publish] Build successful. Verifying output..."
POST_COUNT=$(find "$DEPLOY_REPO/posts" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
echo "[publish] Found $POST_COUNT published posts in output"

# Commit and push
cd "$DEPLOY_REPO"

# Only stage relevant files (not .planning/, scripts/, etc.)
git add -A
git commit -m "blog: publish '$TITLE'" 2>/dev/null || { echo "[publish] No changes to commit"; exit 0; }
git push origin $DEFAULT_BRANCH 2>&1

echo "[publish] ✅ Published: $TITLE"
echo "[publish] Live at: https://tariqbaater.github.io/posts/$YEAR/$SLUG/"

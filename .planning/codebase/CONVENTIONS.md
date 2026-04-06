# Conventions

## Code Style

### Hugo Content (Markdown)
- **Frontmatter**: YAML-style between `---` delimiters
- **Standard frontmatter fields**: `title`, `date`, `draft`, `type`, `tags`
- **Content body**: Standard Markdown with emoji section headers (e.g., `## 🛒 Pillar 1`)
- **Bold emphasis**: `**text**` for key terms and conclusions
- **Lists**: Both bullet (`*`) and numbered formats used
- **Links**: Standard Markdown `[text](url)` format

### Shell Scripts (`scripts/*.sh`)
- **Shebang**: `#!/usr/bin/env bash`
- **Error handling**: `set -euo pipefail` (strict mode)
- **Variable naming**: UPPER_SNAKE_CASE for constants (`BLOG_SRC`, `DEPLOY_REPO`, `TITLE`)
- **String quoting**: Consistent double-quoting of variables (`"$TITLE"`, `"$SLUG"`)
- **Comments**: `#` inline comments with `[publish]` prefix for log messages
- **Logging format**: `echo "[publish] message"` pattern

### Python Script (`scripts/automation_script.py`)
- **Shebang**: `#!/usr/env python3`
- **Encoding**: `# -*- coding: utf-8 -*-`
- **Docstrings**: Triple-quoted module and function docstrings
- **Naming**: `snake_case` for functions and variables
- **Type hints**: Partial — `run_web_search(query: str) -> str`
- **Constants**: UPPER_SNAKE_CASE (`HUGO_SITE_PATH`, `OUTPUT_FILE`, `RESEARCH_QUERY`)
- **Template strings**: f-strings for dynamic content generation

## Naming Conventions

### Content
- **Post titles**: Title Case with possessive apostrophes (`KSA's Modern Retail Landscape`)
- **URL slugs**: kebab-case, fully lowercase (`saudi-arabias-retail-revolution-vision-2030-in-action`)
- **Tags**: lowercase, kebab-case, hyphenated multi-word (`inventory-optimization`, `ksa-retail`)
- **Categories**: lowercase, kebab-case (`retail-operations`, `cybersecurity`)

### Files
- **Scripts**: kebab-case with extension (`publish-blog.sh`, `automation_script.py`)
- **Content**: kebab-case with year suffix (`ksa-retail-2026.md`)
- **Assets**: descriptive names with extensions (`og-image.png`, `apple-touch-icon.png`)

## Patterns

### Frontmatter Pattern
```yaml
---
title: "Post Title"
date: YYYY-MM-DD
draft: false
type: article
tags: [tag1, tag2]
---
```

### Post Structure Pattern
1. H1 title matching frontmatter title
2. Introductory paragraph
3. H2 section headers (often with emoji prefix)
4. Bullet points under each section
5. H3 or bold conclusion

### Script Pattern (publish-blog.sh)
1. Parse arguments (title, optional --file flag)
2. Generate URL slug from title
3. Write content to Hugo source directory
4. Build with Hugo
5. Git add, commit, push

### Deployment Pattern
- Build output goes to root directory (not a subdirectory)
- `git add -A` captures all changes
- Commit message format: `blog: publish '<title>'`

## Error Handling

### Shell Scripts
- `set -euo pipefail` — exit on error, undefined vars, pipe failures
- `2>/dev/null || true` — suppress expected errors (e.g., git pull when no remote)
- `exit 1` — explicit failure exits with messages to stderr
- `|| { echo "message"; exit 0; }` — graceful handling of no-op scenarios

### Python Script
- No try/except blocks — errors will crash the script
- Placeholder functions with `print()` instead of actual API calls
- No input validation beyond type hints

## Content Conventions

### Author Attribution
- Author name: `Tariq Abubakar` (in frontmatter and HTML meta)
- Display name: `Tariq Baater` (site title)
- Consistent across all posts

### Date Format
- ISO 8601: `YYYY-MM-DD` in frontmatter
- Human-readable in HTML: `March 4, 2026`

### Reading Time
- Displayed on post listings (e.g., `12 min`, `5 min`, `2 min`, `1 min`)
- Auto-calculated by Hugo

## Deviations / Inconsistencies

1. **Content directory mismatch**: Source uses `content/blogs/` but publish script expects `content/posts/<year>/`
2. **Mixed content types**: Retail operations posts + cybersecurity CTF writeups in same blog
3. **Python script is a stub**: `automation_script.py` has hardcoded content, not actually automated
4. **Unrelated script**: `prayer-timings-autodeploy.sh` belongs to a different project

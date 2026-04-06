# Architecture

## Pattern

**Static Site Generation (SSG)** via Hugo. The site follows a classic Hugo build pattern:

- **Source**: `my-hugo-site/` — minimal Hugo project with content only
- **Output**: Root directory (`/`) — fully rendered static HTML, CSS, assets
- **Deploy**: GitHub Pages (`tariqbaater.github.io`)

The architecture is **build-then-deploy**, not server-rendered. All pages are pre-generated at build time.

## Layers

### 1. Content Layer (`my-hugo-site/content/`)
- Markdown source files with YAML/TOML frontmatter
- Currently only one source file exists: `my-hugo-site/content/blogs/ksa-retail-2026.md`
- All other 7 published posts have no source files in this repo (likely authored elsewhere or lost)

### 2. Theme Layer (PaperMod)
- Theme: **hugo-PaperMod** (adityatelange/hugo-PaperMod)
- Theme is NOT vendored in this repo — expected to be installed via git submodule or Hugo modules
- Configured via `hugo.toml` or `config.toml` (neither file exists in this repo — likely in a separate source repo)
- Theme provides: responsive layout, dark/light mode toggle, JSON-LD structured data, RSS feeds, sitemap generation

### 3. Build Layer (Hugo binary)
- Hugo version: **0.157.0** (from `<meta name=generator>` in `index.html:1`)
- Build command: `hugo --destination <deploy-dir> --baseURL https://tariqbaater.github.io/`
- Build is orchestrated by `scripts/publish-blog.sh`

### 4. Deployment Layer (GitHub Pages)
- Deploy target: `tariqbaater.github.io` GitHub repository
- Deployment method: Git push of built HTML to the repo's default branch
- No CI/CD pipeline — manual script execution

## Data Flow

```
Author writes .md → scripts/publish-blog.sh → Hugo builds → git add -A → git push → GitHub Pages serves
```

1. Content written as Markdown with frontmatter
2. `publish-blog.sh` places file in `my-hugo-site/content/posts/<year>/`
3. Hugo reads all content + theme templates + config
4. Hugo generates static HTML to the deploy directory (root `/`)
5. Script commits all changes and pushes to GitHub
6. GitHub Pages serves the static files

## Abstractions

- **PaperMod theme**: Provides all layout, styling, and component abstractions. The site owner does not maintain custom layouts or partials.
- **Hugo's content pipeline**: Markdown → HTML transformation with frontmatter metadata injection
- **JSON output**: `index.json` provides full-text search data (used by PaperMod's search feature)

## Entry Points

| Entry | Purpose |
|-------|---------|
| `index.html` (root) | Homepage — lists all posts, author info, social links |
| `posts/index.html` | Blog listing page |
| `about/index.html` | About page |
| `cv/index.html` | CV/Resume page |
| `404.html` | Custom 404 page |
| `index.xml` | RSS feed |
| `index.json` | JSON search index |
| `sitemap.xml` | Sitemap for search engines |

## External Dependencies

- **GitHub Pages** — hosting
- **Hugo binary** — must be installed on the machine running `publish-blog.sh`
- **PaperMod theme** — must be installed in `themes/` directory
- **GitHub CLI (`gh`)** — used in publish script for repo cloning

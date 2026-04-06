# Technology Stack

**Analysis Date:** 2026-04-06

## Languages

**Primary:**
- **Markdown** - Blog content authoring (frontmatter + body in `.md` files)
- **HTML/CSS** - Generated static site output (Hugo renders to static HTML)
- **JavaScript** - Minimal inline JS for theme interactivity (theme toggle, scroll-to-top, menu navigation)

**Secondary:**
- **Bash** - Automation scripts (`scripts/publish-blog.sh`, `scripts/prayer-timings-autodeploy.sh`)
- **Python 3** - Content generation automation (`scripts/automation_script.py`)

## Runtime

**Environment:**
- **Hugo 0.157.0** - Static site generator (confirmed via `<meta name=generator>` in `index.html`)
- Package manager: **Not applicable** — Hugo is installed system-level, not managed via npm/yarn/pip

**Lockfile:** Not present — no `package.json`, `requirements.txt`, `go.mod`, or similar dependency manifests exist in the repo.

## Frameworks

**Core:**
- **Hugo 0.157.0** — Static site generator. Builds Markdown content into static HTML/CSS/JS.
- **PaperMod** (hugo-PaperMod) — Hugo theme. Configured via `hugo.toml` or `config.toml` (config files not present in repo; theme expected at `themes/PaperMod/`). Referenced in footer: `https://github.com/adityatelange/hugo-PaperMod/`

**Build:**
- **Hugo CLI** — `hugo --destination <path> --baseURL <url>` for site generation

**Automation:**
- **GitHub CLI (`gh`)** — Used in `scripts/publish-blog.sh` for repo cloning (`gh repo clone`)
- **Python 3 stdlib** — `scripts/automation_script.py` uses only `json`, `subprocess`, `datetime` (no external packages)

## Key Dependencies

**Critical:**
- **Hugo** (system-level binary, v0.157.0) — Required to build the site. No version pinning in repo.
- **PaperMod theme** — Must be installed at `themes/PaperMod/` before building. The publish script checks for this and errors if missing.

**Infrastructure:**
- **Git** — Version control and deployment mechanism (push to GitHub Pages)
- **GitHub CLI (`gh`)** — Used by publish script for repo operations

## Configuration

**Environment:**
- Hugo config files (`hugo.toml` or `config.toml`) are **not present in the repo**. The publish script (`scripts/publish-blog.sh`, line 61-63) detects which config file to use:
  ```bash
  HUGO_CONFIG="hugo.toml"
  [ -f "config.toml" ] && HUGO_CONFIG="config.toml"
  ```
- The theme is read from this config via grep. No `.env` files detected.
- Base URL: `https://tariqbaater.github.io/` (hardcoded in publish script, line 77)

**Build:**
- No `Makefile`, `Dockerfile`, or CI config detected.
- Build command (from `scripts/publish-blog.sh`, line 77):
  ```bash
  hugo --destination "$DEPLOY_REPO/posts/../" --baseURL "https://tariqbaater.github.io/"
  ```

**Content structure:**
- Source content lives in `my-hugo-site/content/` (currently only `my-hugo-site/content/blogs/ksa-retail-2026.md`)
- Frontmatter format: TOML-style YAML with `title`, `date`, `draft`, `type`, `tags`

## Platform Requirements

**Development:**
- Hugo 0.157.0+ installed system-wide
- Git configured with GitHub credentials
- GitHub CLI (`gh`) authenticated
- PaperMod theme installed in `themes/` directory
- Bash (macOS/Linux compatible)

**Production:**
- **GitHub Pages** — Static site hosted at `tariqbaater.github.io`
- Deployed via `git push` to `origin/main` (or `origin/master`)
- Custom domain: `blog.tariqbaater.com` (referenced in publish script, line 86)

## Output Artifacts

The Hugo build generates:
- `index.html` — Homepage
- `posts/<slug>/index.html` — Individual post pages
- `index.xml` — RSS feed
- `index.json` — JSON search index
- `sitemap.xml` — Sitemap for search engines
- `robots.txt` — Crawler directives
- `assets/css/stylesheet.<hash>.css` — Compiled theme CSS with SRI integrity hash
- `404.html` — Custom 404 page
- `categories/`, `tags/` — Taxonomy index pages
- `about/`, `cv/` — Static content pages

---

*Stack analysis: 2026-04-06*

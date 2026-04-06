# Structure

## Directory Layout

```
Blog/                              # Repository root = Hugo deploy output
├── .git/                          # Git repository
├── .planning/                     # GSD planning documents (this project)
│   └── codebase/                  # Codebase mapping documents
├── my-hugo-site/                  # Hugo source project (incomplete)
│   └── content/
│       └── blogs/
│           └── ksa-retail-2026.md # Only source content file
├── scripts/                       # Automation scripts
│   ├── publish-blog.sh            # Main publish/deploy script
│   ├── automation_script.py       # Content generation stub (non-functional)
│   └── prayer-timings-autodeploy.sh # Unrelated project auto-deploy
├── assets/                        # Hugo-generated assets
│   └── css/
│       └── stylesheet.*.css       # Fingerprinted PaperMod CSS
├── posts/                         # Published blog posts (HTML)
│   ├── saudi-arabias-retail-revolution-vision-2030-in-action/
│   ├── dark-store-logistics-last-mile-fulfillment/
│   ├── retail-cybersecurity-imperative-2026/
│   ├── ksa-retail-weekly-ops-rhythm/
│   ├── bandit-writeup/
│   ├── leviathan-writeup/
│   ├── mr-robot-writeup/
│   ├── my-first-post/
│   └── page/1/                    # Pagination
├── categories/                    # Category listing pages
│   ├── retail-operations/
│   ├── blog/
│   └── cybersecurity/
├── tags/                          # Tag listing pages
│   ├── retail-logistics/
│   ├── operations/
│   ├── pos-systems/
│   ├── leadership/
│   ├── inventory-optimization/
│   ├── ksa-retail/
│   ├── hugo/
│   ├── cybersecurity/
│   └── ctf/
├── about/                         # About page
├── cv/                            # CV page
│   └── photo.jpg
├── index.html                     # Homepage
├── index.xml                      # RSS feed
├── index.json                     # JSON search index
├── sitemap.xml                    # Sitemap
├── robots.txt                     # Robots.txt
├── 404.html                       # 404 page
├── favicon.png                    # Favicon
├── apple-touch-icon.png           # Apple touch icon
└── og-image.png                   # Open Graph image
```

## Key Locations

| Path | Purpose |
|------|---------|
| `my-hugo-site/content/` | Hugo source content (minimal — only 1 file) |
| `scripts/publish-blog.sh` | Primary deployment automation |
| `scripts/automation_script.py` | Content generation prototype (not wired up) |
| `posts/` | Published post HTML (build output) |
| `assets/css/` | Fingerprinted theme CSS |
| `categories/` | Auto-generated category index pages |
| `tags/` | Auto-generated tag index pages |
| `cv/` | CV/resume page with photo |

## Naming Conventions

### Posts
- **URL slugs**: kebab-case, lowercase (`dark-store-logistics-last-mile-fulfillment`)
- **Source files**: `ksa-retail-2026.md` in `content/blogs/` (note: uses `blogs/` not `posts/`)
- **Published directories**: match the URL slug under `posts/`

### Content organization
- **Source content path**: `my-hugo-site/content/blogs/` (non-standard — Hugo convention is `content/posts/`)
- **Publish script expects**: `content/posts/<year>/` (mismatch with actual `content/blogs/`)

### Tags
- kebab-case, lowercase (`retail-logistics`, `inventory-optimization`, `ksa-retail`)

### Categories
- kebab-case, lowercase (`retail-operations`, `blog`, `cybersecurity`)

## What's Missing from Source

The `my-hugo-site/` directory is **incomplete**. A standard Hugo project would have:

```
my-hugo-site/
├── config.toml / hugo.toml    # MISSING — site configuration
├── themes/                     # MISSING — PaperMod theme
├── layouts/                    # MISSING — custom layouts (if any)
├── static/                     # MISSING — static assets
├── archetypes/                 # MISSING — content templates
└── content/                    # EXISTS — but only 1 file
```

The configuration, theme, and layouts likely live in a **separate repository** or were never committed. The publish script (`scripts/publish-blog.sh`) references `hugo.toml` or `config.toml` but neither exists in this repo.

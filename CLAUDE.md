# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

This repository is the **GitHub Pages deployment target** for `https://tariqbaater.github.io/`. It contains only the **pre-built HTML output** from Hugo — there are no source Markdown files, Hugo configuration, or theme files here.

The Hugo source project lives at `/Users/tariq/Projects/blog-source/`.

## Site Details

- **Generator**: Hugo with PaperMod theme
- **Hosting**: GitHub Pages, served from the `main` branch root
- **URL**: https://tariqbaater.github.io/

## Publishing Workflow

All content authoring happens in the source project. Never edit HTML files in this repo directly.

```bash
cd /Users/tariq/Projects/blog-source

# 1. Add/edit markdown files in content/posts/
# 2. Build and sync to this repo:
./publish.sh "Publish blog: Post Title"

# 3. Push to GitHub Pages:
cd /Users/tariq/Projects/tariqbaater.github.io
git push
```

## Adding a New Post

Create a markdown file in `blog-source/content/posts/<slug>.md` with this front matter:

```yaml
---
title: "Post Title"
date: 2026-02-24
description: "One-line summary"
tags: ["ksa retail", "operations"]
categories: ["retail-operations"]
---
```

Categories in use: `retail-operations`, `cybersecurity`, `blog`

## Content Structure

Posts live under `/posts/<slug>/index.html`. Static assets are under `/assets/css/`. The site also generates `/index.json`, `/index.xml` (RSS), and `/sitemap.xml` at build time.

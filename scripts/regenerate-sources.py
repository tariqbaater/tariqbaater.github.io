#!/usr/bin/env python3
import os
import re
from datetime import datetime
from html import unescape

POSTS_DIR = "posts"
OUTPUT_DIR = "my-hugo-site/content"


def extract_date_from_meta(html_content):
    match = re.search(
        r'property="article:published_time" content="([^"]+)"', html_content
    )
    if match:
        dt = datetime.fromisoformat(
            match.group(1).replace("+03:00", "+00:00").replace("+00:00", "")
        )
        return dt.strftime("%Y-%m-%d")
    match = re.search(r"<span title='([^']+)'", html_content)
    if match:
        try:
            dt = datetime.strptime(match.group(1), "%Y-%m-%d %H:%M:%S %z")
            return dt.strftime("%Y-%m-%d")
        except:
            pass
    return datetime.now().strftime("%Y-%m-%d")


def extract_title(html_content):
    match = re.search(r"<title>([^|]+)", html_content)
    if match:
        return match.group(1).strip()
    match = re.search(r'<h1 class="post-title[^"]*"[^>]*>([^<]+)', html_content)
    if match:
        return match.group(1).strip()
    return "Untitled"


def extract_tags(html_content):
    tags = re.findall(r'property="article:tag" content="([^"]+)"', html_content)
    if not tags:
        tags = re.findall(r"<li><a href=[^>]*>([^<]+)</a></li>", html_content)
        tags = [t for t in tags if t not in ["Home", "Posts", "Prev", "Next"]]
    return tags[:5]


def extract_content(html_content):
    match = re.search(
        r'<div class="post-content">(.*?)(<footer class="post-footer"|<div class="post-footer")',
        html_content,
        re.DOTALL,
    )
    if not match:
        match = re.search(
            r"<div class=post-content>(.*?)<footer class=post-footer>",
            html_content,
            re.DOTALL,
        )
    if not match:
        return ""

    content = match.group(1)

    content = re.sub(r"<script[^>]*>.*?</script>", "", content, flags=re.DOTALL)
    content = re.sub(r"<style[^>]*>.*?</style>", "", content, flags=re.DOTALL)

    def tag_replacer(m):
        tag = m.group(0)
        if (
            tag.startswith("<h")
            or tag.startswith("<p")
            or tag.startswith("<li")
            or tag.startswith("<ul")
            or tag.startswith("<ol")
            or tag.startswith("<tr")
            or tag.startswith("<td")
            or tag.startswith("<th")
            or tag.startswith("<blockquote")
            or tag.startswith("<br")
        ):
            return "\n"
        if tag.startswith("</"):
            return ""
        return ""

    content = re.sub(r"<[^>]+>", tag_replacer, content)
    content = re.sub(r"&nbsp;", " ", content)
    content = re.sub(r"&amp;", "&", content)
    content = re.sub(r"&lt;", "<", content)
    content = re.sub(r"&gt;", ">", content)
    content = re.sub(r"\n\s*\n\s*\n+", "\n\n", content)
    content = content.strip()

    return content


def main():
    for post_dir in sorted(os.listdir(POSTS_DIR)):
        post_path = os.path.join(POSTS_DIR, post_dir)
        if not os.path.isdir(post_path) or post_dir == "page":
            continue

        index_html = os.path.join(post_path, "index.html")
        if not os.path.exists(index_html):
            continue

        print(f"Processing: {post_dir}")

        with open(index_html, "r", encoding="utf-8") as f:
            html = f.read()

        title = extract_title(html)
        date = extract_date_from_meta(html)
        tags = extract_tags(html)
        content = extract_content(html)

        if not content or len(content) < 50:
            print(f"  ⚠️ No/short content, trying alternate extraction...")
            content = html
            content = re.sub(
                r'.*<div class="post-content">', "", content, flags=re.DOTALL
            )
            content = re.sub(
                r'<footer class="post-footer">.*', "", content, flags=re.DOTALL
            )
            content = re.sub(r"<[^>]+>", "\n", content)
            content = unescape(content)
            content = content.strip()

        if not content:
            print(f"  ⚠️ Could not extract content, skipping")
            continue

        year = date[:4]
        output_subdir = os.path.join(OUTPUT_DIR, "posts", year)
        os.makedirs(output_subdir, exist_ok=True)

        slug = post_dir
        output_file = os.path.join(output_subdir, f"{slug}.md")

        tags_str = ", ".join([f'"{t}"' for t in tags]) if tags else "[]"

        md_content = f"""---
title: "{title}"
date: {date}
draft: false
tags: [{tags_str}]
---

{content}
"""

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(md_content)

        print(f"  ✓ Created: {output_file}")


if __name__ == "__main__":
    main()

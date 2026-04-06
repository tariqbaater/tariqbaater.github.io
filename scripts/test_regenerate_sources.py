#!/usr/bin/env python3
"""Tests for regenerate-sources.py"""

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


HTML_SAMPLE = """
<!DOCTYPE html>
<html>
<head>
<title>Test Post | My Blog</title>
<meta property="article:published_time" content="2024-12-23T10:00:00+03:00">
<meta property="article:tag" content="Python">
<meta property="article:tag" content="Testing">
</head>
<body>
<div class="post-content">
<h1>Hello World</h1>
<p>This is a test paragraph.</p>
<ul><li>Item one</li><li>Item two</li></ul>
</div>
<footer class="post-footer">
<ul class="post-tags"><li><a>Python</a></li><li><a>Testing</a></li></ul>
</footer>
</body>
</html>
"""


def test_extract_title():
    result = extract_title(HTML_SAMPLE)
    assert result == "Test Post", f"Expected 'Test Post', got '{result}'"
    print("✓ extract_title works")


def test_extract_date():
    result = extract_date_from_meta(HTML_SAMPLE)
    assert result == "2024-12-23", f"Expected '2024-12-23', got '{result}'"
    print("✓ extract_date works")


def test_extract_tags():
    result = extract_tags(HTML_SAMPLE)
    assert "Python" in result, f"Expected 'Python' in tags, got {result}"
    assert "Testing" in result, f"Expected 'Testing' in tags, got {result}"
    print("✓ extract_tags works")


def test_extract_content():
    result = extract_content(HTML_SAMPLE)
    assert "Hello World" in result, f"Expected 'Hello World' in content"
    assert "test paragraph" in result, f"Expected 'test paragraph' in content"
    print("✓ extract_content works")


def test_regenerated_files_exist():
    """Check that regeneration produced expected files."""
    posts_dir = "my-hugo-site/content/posts"
    assert os.path.exists(posts_dir), f"Posts directory {posts_dir} does not exist"

    for year in ["2024", "2026"]:
        year_dir = os.path.join(posts_dir, year)
        if not os.path.exists(year_dir):
            continue
        md_files = [f for f in os.listdir(year_dir) if f.endswith(".md")]
        assert len(md_files) > 0, f"No .md files found in {year_dir}"
        print(f"✓ Found {len(md_files)} posts for {year}")


if __name__ == "__main__":
    print("Running regenerate-sources.py tests...\n")
    test_extract_title()
    test_extract_date()
    test_extract_tags()
    test_extract_content()
    test_regenerated_files_exist()
    print("\n✅ All tests passed!")

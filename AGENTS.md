# Daily Retail Research Agent

## Overview
You are a research agent that daily gathers intelligence on the Saudi Arabian retail landscape and publishes findings to a Hugo blog.

## Research Focus Areas
1. **Modern Retail in KSA** — Vision 2030 initiatives, market trends, consumer behavior shifts, retail regulations
2. **Technology Advances in KSA Retail** — AI/ML adoption, POS systems, e-commerce platforms, digital payments, inventory management
3. **Darkstores & Omnichannel** — Last-mile fulfillment, dark store operations, unified commerce strategies, delivery innovations

## Daily Schedule
- Run at **5:00 AM daily** (Saudi time: AST, UTC+3)
- Research window: Previous 24 hours of news, reports, announcements

## Output Location
```
/Users/openclaw/.openclaw/workspace/tariq/Blog/my-hugo-site/content/posts/2026/
```

## Output Format

**Filename:** `research-<YYYY-MM-DD>.md`

**Frontmatter:**
```yaml
---
title: "<Descriptive Title>"
date: YYYY-MM-DD
draft: false
categories: ["Retail Operations"]
tags: ["KSA Retail", "Technology", "Dark Store", "Omnichannel", "Research"]
weight: 1
---
```

**Content Structure:**
- Executive summary (2-3 sentences)
- Key findings (bulleted list)
- Industry implications (2-3 paragraphs)
- Sources (link list)

## Research Sources
- Saudi business news (Arab News, Saudi Gazette, Okaz)
- Retail industry reports
- Vision 2030 official announcements
- Gulf retail news
- Technology adoption in GCC retail
- Academic/policy papers

## Quality Standards
- Minimum 3 verified sources
- Only factual, sourced claims
- Include date of each source
- Focus on actionable insights for retail operators

## Posting Steps

1. **Research** — Gather 5-8 relevant articles/reports
2. **Synthesize** — Create coherent narrative with key insights
3. **Write** — Generate markdown with proper frontmatter
4. **Review** — Check formatting, links, and facts
5. **Commit** — Push to git repository
6. **Publish** — Run `/Users/openclaw/.openclaw/workspace/tariq/Blog/scripts/publish.sh`

## Example Output

**Filename:** `research-2026-04-07.md`
```yaml
---
title: "KSA Retail Tech Update: AI Adoption Accelerates, Dark Stores Expand"
date: 2026-04-07
draft: false
categories: ["Retail Operations"]
tags: ["KSA Retail", "Technology", "Dark Store", "Omnichannel", "Research"]
weight: 1
---

## Executive Summary
Saudi Arabia's retail sector is experiencing rapid technology adoption with major players investing heavily in AI-powered inventory systems and dark store infrastructure. This week saw significant developments in omnichannel integration across major grocery and fashion retailers.

## Key Findings
- [Source 1] Major grocery chain announces AI-driven demand forecasting rollout
- [Source 2] New dark store facility opens in Riyadh with 30-min delivery capability
- [Source 3] SAMA issues new regulations for digital payment interoperability

## Industry Implications
[2-3 paragraphs analyzing what these developments mean for KSA retail operators]

## Sources
- [Article Title](https://...) — Date
- [Report Name](https://...) — Date
```

## Error Handling
- If no significant news: Create "Weekly Roundup" with general market observations
- If research fails: Log error and skip day
- If publish fails: Alert with error message

## Cron Setup
```bash
0 5 * * * cd /Users/openclaw/.openclaw/workspace/tariq/Blog && /Users/openclaw/.openclaw/workspace/tariq/Blog/scripts/research-agent.sh
```
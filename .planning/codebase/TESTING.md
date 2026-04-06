# Testing

## Test Framework

**None.** This codebase has no testing framework, test runner, or test files.

This is common for static Hugo blogs, but it means:
- No automated validation of generated HTML
- No link checking
- No content linting
- No build verification tests

## Manual Testing Approach

The current testing strategy is entirely manual:

1. **Local preview**: `hugo server` (not scripted — must be run manually)
2. **Visual verification**: Open browser to check rendering
3. **Post-publish check**: Visit live URL to confirm deployment

The `automation_script.py` includes a comment acknowledging this gap:
> `>>> ACTION REQUIRED: Please manually run 'hugo server' or 'hugo build' in the site root to confirm successful inclusion.`

## Build Verification

The `publish-blog.sh` script performs a build step but does not validate the output:

```bash
hugo --destination "$DEPLOY_REPO/posts/../" --baseURL "https://tariqbaater.github.io/" 2>&1
```

- Build output is captured (`2>&1`) but not checked for errors
- Script continues to commit/push even if build has warnings
- No post-build smoke tests (e.g., checking that expected HTML files exist)

## What's Missing

| Test Type | Status | Impact |
|-----------|--------|--------|
| HTML validation | None | Broken HTML could deploy |
| Link checking | None | Dead links go unnoticed |
| Content linting | None | Frontmatter errors, broken markdown |
| Build verification | Partial | Build runs but output not validated |
| Visual regression | None | Layout changes undetected |
| Performance testing | None | No Lighthouse or similar checks |
| RSS/JSON validation | None | Feed correctness not verified |

## Recommended Additions

For a Hugo blog of this scope, minimal useful tests would be:

1. **Build exit code check**: Verify `hugo` returns 0 before committing
2. **Output file existence check**: Confirm `index.html` and expected post HTML files exist after build
3. **Link checker**: Run `htmltest` or similar on the built output
4. **Frontmatter validation**: Check that all `.md` files have required frontmatter fields

## CI/CD

**None.** There is no `.github/workflows/`, `.gitlab-ci.yml`, or any CI configuration.

All builds and deployments are triggered locally via `scripts/publish-blog.sh`. This means:
- No automated testing on push
- No branch protection
- No preview deployments
- No rollback capability

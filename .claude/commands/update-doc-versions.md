---
description: Update documentation to reference the latest Comet release version
---

# Update Documentation Versions Command

Update all version references in the documentation to match the latest published Comet (santa-lang-comet) release.

## Context

The documentation contains download links and version references for the Comet implementation. These need to be updated whenever a new version is released.

## Files to Update

| File                       | Content                                    |
| -------------------------- | ------------------------------------------ |
| `docs/index.md`            | Main release table with all runtime links  |
| `docs/cli.md`              | CLI download links                         |
| `docs/jupyter-kernel.md`   | Jupyter kernel download links              |
| `docs/lambda.md`           | Lambda runtime download link               |
| `docs/php-ext.md`          | PHP extension download link                |

## Task

### 1. Get Latest Published Release

Fetch the latest published (non-draft) release version for Comet:

```bash
gh release list --repo eddmann/santa-lang-comet --json tagName,isDraft --limit 5 | jq -r '.[] | select(.isDraft == false) | .tagName' | head -1
```

### 2. Find Current Version in Docs

Search for the current version pattern in the documentation:

```bash
grep -oE '0\.[0-9]+\.[0-9]+' docs/index.md | head -1
```

### 3. Show Summary

Present to the user:
- Current version in docs
- Latest published version
- List of files that will be updated
- Preview of what will change (show a sample line before/after)

### 4. Request Confirmation

Ask the user: "Update documentation from version X.Y.Z to A.B.C?"

**Do NOT proceed without explicit user confirmation.**

### 5. Update Version References

After user confirms, update all occurrences in each file. The version appears in two places per download link:

1. **Link text:** `santa-lang-comet-cli-0.0.10-linux-amd64`
2. **URL path:** `/releases/download/0.0.10/santa-lang-comet-`

Use find and replace to update from the old version to the new version in all target files.

### 6. Format Documentation

After updating, run Prettier to ensure consistent formatting:

```bash
npx prettier --write docs/
```

### 7. Show Changes

After formatting, show a git diff of the changes:

```bash
git diff docs/
```

### 8. Report Results

Summarize:
- Which files were updated
- How many version references were changed
- Remind user to review changes and commit when ready

## Important Notes

- Only update Comet (santa-lang-comet) version references
- Do NOT update `@eddmann/santa-lang-wasm` package version (this is managed separately)
- Do NOT commit changes automatically - let the user review first
- If current and latest versions are the same, report this and exit without changes
- The Docker image tag (`:latest`) should NOT be changed

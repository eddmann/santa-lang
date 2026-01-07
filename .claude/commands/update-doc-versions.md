---
description: Update documentation to reference the latest Comet release version
---

# Update Documentation Versions Command

Update all version references in the documentation to match the latest published release for each implementation.

## Context

The documentation contains download links and version references for multiple implementations. These need to be updated whenever new versions are released.

## Implementation Files

Each implementation has its own documentation page with version-specific download links:

| Implementation | Doc File                   | Repository                 |
| -------------- | -------------------------- | -------------------------- |
| Comet          | `docs/reindeer/comet.md`   | eddmann/santa-lang-comet   |
| Blitzen        | `docs/reindeer/blitzen.md` | eddmann/santa-lang-blitzen |
| Dasher         | `docs/reindeer/dasher.md`  | eddmann/santa-lang-dasher  |
| Donner         | `docs/reindeer/donner.md`  | eddmann/santa-lang-donner  |
| Prancer        | `docs/reindeer/prancer.md` | eddmann/santa-lang-prancer |

Additionally, Comet versions appear in:

- `docs/index.md` - Main release table
- `docs/cli.md` - CLI download links
- `docs/jupyter-kernel.md` - Jupyter kernel download links
- `docs/lambda.md` - Lambda runtime download link
- `docs/php-ext.md` - PHP extension download link

## Task

### 1. Get Latest Published Releases

Fetch the latest published (non-draft) release version for each implementation:

```bash
# Comet
gh release list --repo eddmann/santa-lang-comet --json tagName,isDraft --limit 5 | jq -r '.[] | select(.isDraft == false) | .tagName' | head -1

# Blitzen
gh release list --repo eddmann/santa-lang-blitzen --json tagName,isDraft --limit 5 | jq -r '.[] | select(.isDraft == false) | .tagName' | head -1

# Dasher
gh release list --repo eddmann/santa-lang-dasher --json tagName,isDraft --limit 5 | jq -r '.[] | select(.isDraft == false) | .tagName' | head -1

# Donner
gh release list --repo eddmann/santa-lang-donner --json tagName,isDraft --limit 5 | jq -r '.[] | select(.isDraft == false) | .tagName' | head -1

# Prancer
gh release list --repo eddmann/santa-lang-prancer --json tagName,isDraft --limit 5 | jq -r '.[] | select(.isDraft == false) | .tagName' | head -1
```

### 2. Find Current Versions in Docs

Search for the current version patterns in the documentation:

```bash
# Comet (in comet.md)
grep -oE 'comet-[a-z]+-[0-9]+\.[0-9]+\.[0-9]+' docs/reindeer/comet.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'

# Blitzen (in blitzen.md)
grep -oE 'blitzen-[a-z]+-[0-9]+\.[0-9]+\.[0-9]+' docs/reindeer/blitzen.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'

# Dasher (in dasher.md)
grep -oE 'dasher-[a-z]+-[0-9]+\.[0-9]+\.[0-9]+' docs/reindeer/dasher.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'

# Donner (in donner.md)
grep -oE 'donner-[a-z]+-[0-9]+\.[0-9]+\.[0-9]+' docs/reindeer/donner.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'

# Prancer (in prancer.md)
grep -oE 'prancer-[a-z]+-[0-9]+\.[0-9]+\.[0-9]+' docs/reindeer/prancer.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
```

### 3. Show Summary

Present to the user for each implementation:

- Current version in docs
- Latest published version
- List of files that will be updated
- Whether an update is needed

### 4. Request Confirmation

Ask the user which implementations to update. Options:

- Update all implementations with new versions
- Update specific implementations only
- Skip (no changes)

**Do NOT proceed without explicit user confirmation.**

### 5. Update Version References

After user confirms, update all occurrences in each file. The version appears in multiple places:

1. **Version line:** `**Version:** X.Y.Z`
2. **Link text:** `santa-lang-{impl}-cli-X.Y.Z-linux-amd64`
3. **URL path:** `/releases/download/X.Y.Z/santa-lang-{impl}-`

For Comet specifically, also update:

- `docs/index.md` - Main release table
- `docs/cli.md` - CLI download links
- `docs/jupyter-kernel.md` - Jupyter kernel download links
- `docs/lambda.md` - Lambda runtime download link
- `docs/php-ext.md` - PHP extension download link

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

- Which implementations were updated
- Which files were modified
- How many version references were changed per implementation
- Remind user to review changes and commit when ready

## Important Notes

- Do NOT update `@eddmann/santa-lang-wasm` package version (this is managed separately)
- Do NOT commit changes automatically - let the user review first
- If current and latest versions are the same for an implementation, skip that implementation
- The Docker image tags (`:latest`) should NOT be changed

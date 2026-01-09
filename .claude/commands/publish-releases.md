---
description: Publish releases for all santa-lang implementations and tools
---

# Publish Releases Command

Publish the draft releases for all santa-lang implementations and tools.

## Implementation Repositories

| Codename | GitHub Repo                |
| -------- | -------------------------- |
| Comet    | eddmann/santa-lang-comet   |
| Blitzen  | eddmann/santa-lang-blitzen |
| Dasher   | eddmann/santa-lang-dasher  |
| Donner   | eddmann/santa-lang-donner  |
| Vixen    | eddmann/santa-lang-vixen   |
| Prancer  | eddmann/santa-lang-prancer |

## Tool Repositories

| Name      | GitHub Repo                  |
| --------- | ---------------------------- |
| Tinsel    | eddmann/santa-lang-tinsel    |
| Workbench | eddmann/santa-lang-workbench |

## Task

### 1. Gather Release Information

For each implementation and tool repository, find the draft release:

```bash
gh release list --repo eddmann/<repo> --json tagName,isDraft,name --limit 5
```

### 2. Present Summary

Show the user what will be published for each repository:

- Repository name (codename)
- Release version/tag
- Brief preview of the release notes (first few lines)

Format as a clear summary table or list.

### 3. Request Confirmation

Ask the user: "Ready to publish these releases? (yes/no)"

**Do NOT proceed without explicit user confirmation.**

### 4. Publish Releases

After user confirms, for each repository with a draft release:

```bash
gh release edit <draft-tag> --repo eddmann/<repo> --draft=false
```

### 5. Report Results

After publishing, report:

- Which releases were published successfully
- Links to the published releases:
  - https://github.com/eddmann/santa-lang-comet/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-blitzen/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-dasher/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-donner/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-vixen/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-prancer/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-tinsel/releases/tag/<tag>
  - https://github.com/eddmann/santa-lang-workbench/releases/tag/<tag>

## Important Notes

- Always show what will be published BEFORE asking for confirmation
- If a repository has no draft release, report this and skip it
- If the user declines, do not publish anything
- Report any errors encountered during publishing

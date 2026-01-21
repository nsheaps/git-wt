# Repository Switching

## Status: Live

## Overview

Switch between different git repositories when not already in a repo.

## Requirements

### Functional Requirements

1. **Repo Discovery**
   - Scan configured directory for git repositories
   - Default scan directory: `~/src`
   - Configurable via `--scan-dir DIR`

2. **Repo Selection**
   - Use fzf for fuzzy-finding repos
   - Display repo paths for selection

3. **Post-Selection**
   - Continue to normal worktree selector for chosen repo

### Non-Functional Requirements

- Only available in interactive mode
- Requires TTY
- Only triggered when not already in a git repo

## CLI Interface

```bash
# Run from non-git directory, uses default scan dir
git-wt

# Specify custom scan directory
git-wt --scan-dir /path/to/projects
```

## User Flow

```
1. User runs `git-wt` from non-git directory
2. Script scans ~/src (or --scan-dir) for .git directories
3. fzf displays found repositories
4. User selects a repo
5. Script continues with normal worktree selection for that repo
```

## Error Handling

| Condition | Behavior |
|-----------|----------|
| Non-interactive + not in repo | Error: "Not in a git repository" |
| No repos found in scan dir | Empty fzf list |
| User cancels selection | Exit with "No repository selected" |

## Implementation Notes

- Uses `find` to locate `.git` directories up to 4 levels deep
- Resolves to parent directory of `.git` for display
- After repo selection, `cd` to repo and continue flow

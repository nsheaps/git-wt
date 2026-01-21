# Worktree Deletion

## Status: Live

## Overview

Delete git worktrees with appropriate safety confirmations.

## Requirements

### Functional Requirements

1. **Delete Command**
   - `git-wt d [branch]` to delete worktree for specified branch
   - Cannot delete root checkout

2. **Interactive Mode**
   - Show confirmation prompt via gum
   - If uncommitted changes, show force confirmation
   - Use gum spinner during deletion

3. **Non-Interactive Mode**
   - Require `--force` flag
   - Fail with helpful error if `--force` not provided

4. **Error Handling**
   - Error if branch has no worktree
   - Error if trying to delete root checkout
   - Handle uncommitted changes gracefully

### Non-Functional Requirements

- Deletion should be reversible (branch still exists)
- Clear feedback on success/failure

## CLI Interface

```bash
# Interactive deletion (shows confirmation)
git-wt d feature-branch

# Non-interactive deletion (requires --force)
git-wt d feature-branch --force
```

## User Flow

### Interactive
```
1. User runs `git-wt d feature-branch`
2. Script shows branch and path info
3. gum confirm prompt: "Are you sure?"
4. If yes: attempt deletion
5. If uncommitted changes: second confirmation for force delete
6. gum spinner shows during deletion
7. Success/failure message
```

### Non-Interactive
```
1. User runs `git-wt d feature-branch --force`
2. Script validates branch has worktree
3. Attempt deletion
4. If uncommitted changes: force delete automatically
5. Print success/failure message
```

## Error Messages

| Condition | Message |
|-----------|---------|
| No worktree for branch | `Error: No worktree found for branch 'X'` |
| Deleting root checkout | `Error: Cannot delete root checkout` |
| Non-interactive without --force | `Error: Non-interactive deletion requires --force flag` |

## Implementation Notes

- Uses `git worktree remove` command
- Falls back to `git worktree remove --force` if needed
- Branch itself is NOT deleted (only worktree)

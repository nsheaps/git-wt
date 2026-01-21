# Interactive Worktree Selector

## Status: Live

## Overview

The primary interactive TUI for selecting and managing git worktrees using fzf.

## Requirements

### Functional Requirements

1. **Worktree Listing**
   - Display all existing worktrees with their branch names and paths
   - Show root checkout labeled as `[root]`
   - Show worktrees labeled as `[worktree]`

2. **Branch Listing**
   - Display local branches without worktrees
   - Display remote branches (with `origin/` prefix stripped in display)

3. **Selection Interface**
   - Use fzf for fuzzy-finding selection
   - Support keyboard navigation
   - Show preview panel with PR information (if gh CLI available)

4. **Actions on Selection**
   - Switch to existing worktree
   - Create new worktree for branch without one
   - Create new branch and worktree

5. **Post-Selection Behavior**
   - Spawn new shell in selected worktree directory
   - Support `--no-exec` to print path instead

### Non-Functional Requirements

- Requires TTY (stdin and stdout)
- Requires `fzf` and `gum` installed
- Should complete selection within reasonable time (<2s for repos with <100 branches)

## Dependencies

- `git` - Required
- `fzf` - Required for selection UI
- `gum` - Required for styled output and confirmations
- `gh` - Optional, for PR preview in selection panel

## User Flow

```
1. User runs `git-wt` in terminal (with TTY)
2. Script fetches from origin
3. fzf displays worktrees and branches
4. User selects item
5. If worktree exists: cd to it and spawn shell
6. If no worktree: create worktree, then cd and spawn shell
7. If new branch: prompt for base branch, create branch+worktree
```

## Implementation Notes

- Worktrees created at `../${repo}.worktrees/${branch}`
- Remote tracking set up automatically for remote branches
- New branches default to basing off default branch (main/master)

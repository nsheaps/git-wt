# CLI / Non-Interactive Mode

## Status: Live

## Overview

Command-line interface for scripting and non-TTY environments.

## Requirements

### Functional Requirements

1. **TTY Detection**
   - Detect when stdin/stdout are not TTY
   - Automatically switch to non-interactive behavior

2. **Usage Display (no arguments)**
   - Print usage information
   - List existing worktrees with paths
   - List branches without worktrees

3. **Branch Switch (`git-wt [branch]`)**
   - Create worktree if doesn't exist
   - Print worktree path to stdout (for `cd "$(git-wt branch)"`)
   - Silent operation (no interactive prompts)

4. **Exec Flags**
   - `--exec` - Spawn shell in worktree (override default)
   - `--no-exec` - Print path only (default in CLI mode)

5. **Error Handling**
   - Exit with non-zero status on errors
   - Print errors to stderr

### Non-Functional Requirements

- No TTY required
- No `fzf` or `gum` required
- Suitable for scripting and automation

## CLI Interface

```bash
# Print usage and list worktrees/branches
git-wt

# Switch to branch (prints path)
git-wt feature-branch

# Switch and spawn shell
git-wt feature-branch --exec

# Use in scripts
cd "$(git-wt feature-branch)"
```

## Output Format

### Usage Output
```
Usage: git-wt [branch]       Switch to or create worktree
       git-wt d [branch]     Delete worktree (requires --force)

Options:
  --exec      Spawn shell in worktree (instead of printing path)
  --force     Force deletion without confirmation

Examples:
  cd "$(git-wt feature-branch)"    # Switch to worktree
  git-wt feature-branch --exec      # Switch and spawn shell
  git-wt d feature-branch --force   # Delete worktree

Worktrees:
  [root]     main → /path/to/repo
  [worktree] feature-1 → /path/to/repo.worktrees/feature-1

Branches (without worktrees):
  feature-2
  bugfix-3
```

### Switch Output (--no-exec, default)
```
/path/to/repo.worktrees/feature-branch
```

## Implementation Notes

- Fetch from origin happens silently
- New branches base off default branch without prompting
- Upgrade notice suppressed in non-interactive mode

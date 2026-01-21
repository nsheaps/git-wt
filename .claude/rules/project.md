# git-wt Project Rules

## Overview

git-wt is an interactive TUI for git worktree management written in Bash.

## Build & Test Commands

```bash
# Run CLI tests
mise run test

# Check bash syntax
mise run lint
bash -n bin/git-wt
```

## Architecture

- **bin/git-wt** - Main bash script (~580 lines)
  - Interactive mode: Uses fzf for selection, gum for spinners/confirmations
  - Non-interactive mode: CLI arguments for scripting (`git-wt branch`, `git-wt d branch`)

- **test/cli-test.sh** - CLI test suite for non-interactive mode

## Dependencies

- `git` - Required
- `fzf` - Required for interactive selection
- `gum` (optional) - Enhanced UI spinners and confirmations
- `gh` (optional) - GitHub CLI for PR preview

## Key Patterns

### TTY Detection
```bash
IS_INTERACTIVE="false"
if [[ -t 0 ]] && [[ -t 1 ]]; then
  IS_INTERACTIVE="true"
fi
```

### CLI Arguments
- `git-wt [branch]` - Switch to branch (creates worktree if needed)
- `git-wt d [branch]` - Delete worktree
- `--exec` - Spawn shell in worktree (default in interactive)
- `--no-exec` - Print path only (default in CLI mode)
- `--force` - Required for non-interactive deletion

## Release Process

Releases are automated via release-it when pushing to main. The homebrew formula is updated automatically via PR to nsheaps/homebrew-devsetup.

## Specifications

Feature specifications are stored in `docs/specs/` with the following structure:

- `docs/specs/draft/` - Initial drafts and brainstorming
- `docs/specs/reviewed/` - Reviewed and approved specifications
- `docs/specs/in-progress/` - Specifications being implemented
- `docs/specs/live/` - Finalized specs for active features
- `docs/specs/deprecated/` - Outdated specs still in use
- `docs/specs/archive/` - Archived specs no longer in use

**Rule:** When adding or modifying features:
1. Create/update the corresponding spec in `docs/specs/`
2. Move specs through the lifecycle as features progress
3. Keep specs concise and focused on requirements, not implementation details

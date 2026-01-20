# git-wt

Interactive TUI for git worktree management.

## Installation

### Homebrew (recommended)

```bash
brew tap nsheaps/devsetup
brew install worktree-switcher
```

### Manual

```bash
# Clone and add to PATH
git clone https://github.com/nsheaps/git-wt.git
export PATH="$PATH:$(pwd)/git-wt/bin"
```

## Usage

```bash
worktree-switcher [OPTIONS] [BRANCH]
```

### Arguments

| Argument | Description                                                    |
| -------- | -------------------------------------------------------------- |
| `BRANCH` | Branch name to create/switch to worktree for (skips selection) |

### Options

| Option           | Description                                      |
| ---------------- | ------------------------------------------------ |
| `--no-status`    | Skip fetching branch status (faster)             |
| `--scan-dir DIR` | Directory to scan for git repos (default: ~/src) |
| `--repo REPO`    | GitHub repo (owner/name) to clone if not in repo |
| `-h, --help`     | Show help message                                |

### Examples

```bash
# Interactive mode - select from branches
worktree-switcher

# Direct branch switch - find or create worktree for branch
worktree-switcher feature/my-branch

# Clone a repo and create worktree
worktree-switcher --repo nsheaps/git-wt feature/my-branch

# Faster mode without status checks
worktree-switcher --no-status
```

## Features

- **Direct branch argument**: Pass a branch name to skip interactive selection
- **Smart branch detection**: Finds local, remote, or creates new branches
- **Repo discovery**: When not in a git repo, offers to:
  - Scan `~/src` (or custom dir) for existing repos
  - Clone from GitHub by selecting from org/user repos
  - Enter a path manually
- **"Switch repository" option**: Step up to change repos during selection
- Shows banner if already in a worktree
- Create new worktrees with new branches
- Select from existing worktrees
- Branch priority (your PRs > your branches > other branches)
- Worktrees created at: `../${repo}.worktrees/${branch}`

## Dependencies

| Tool  | Purpose             | Installation          |
| ----- | ------------------- | --------------------- |
| `gum` | Interactive prompts | `brew install gum`    |
| `gh`  | GitHub CLI          | `brew install gh`     |
| `jq`  | JSON processing     | `brew install jq`     |
| `git` | Version control     | Usually pre-installed |

## License

MIT

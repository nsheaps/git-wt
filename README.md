# git-wt

Interactive TUI for git worktree management.

## Installation

### Homebrew (recommended)

```bash
brew tap nsheaps/devsetup
brew install git-wt
```

### Manual

```bash
# Clone and add to PATH
git clone https://github.com/nsheaps/git-wt.git
export PATH="$PATH:$(pwd)/git-wt/bin"
```

## Usage

```bash
git-wt [OPTIONS] [BRANCH]
```

### Arguments

| Argument | Description                                                    |
| -------- | -------------------------------------------------------------- |
| `BRANCH` | Branch name to create/switch to worktree for (skips selection) |

### Options

| Option           | Description                                      |
| ---------------- | ------------------------------------------------ |
| `--scan-dir DIR` | Directory to scan for git repos (default: ~/src) |
| `-h, --help`     | Show help message                                |
| `-v, --version`  | Show version                                     |

### Examples

```bash
# Interactive mode - select from branches
git-wt

# Direct branch switch - find or create worktree for branch
git-wt feature/my-branch

# Scan a different directory for repos
git-wt --scan-dir ~/projects
```

## Features

- **Direct branch argument**: Pass a branch name to skip interactive selection
- **Smart branch detection**: Finds local, remote, or creates new branches
- **Repo discovery**: When not in a git repo, scans `~/src` for existing repos
- **"Switch repository" option**: Step up to change repos during selection
- Shows banner if already in a worktree
- Create new worktrees with new branches
- Select from existing worktrees
- Worktrees created at: `../${repo}.worktrees/${branch}`

## Dependencies

| Tool  | Purpose             | Installation          |
| ----- | ------------------- | --------------------- |
| `gum` | Interactive prompts | `brew install gum`    |
| `git` | Version control     | Usually pre-installed |

## License

MIT

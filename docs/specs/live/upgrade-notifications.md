# Upgrade Notifications

## Status: Live

## Overview

Background check for new releases with non-intrusive notification.

## Requirements

### Functional Requirements

1. **Background Check**
   - Check GitHub releases API asynchronously
   - Do not block main script execution
   - Cache/throttle to avoid excessive API calls

2. **Version Comparison**
   - Compare current version against latest release
   - Only notify if newer version available

3. **Notification Display**
   - Show at script exit (after main operation completes)
   - Display current version and available version
   - Provide upgrade command

4. **Suppression**
   - Do NOT show in non-interactive mode
   - Only show when TTY available

### Non-Functional Requirements

- Should not slow down normal operations
- Gracefully handle network failures (silent fail)
- Output to stderr (not stdout)

## Notification Format

```
A new release of git-wt is available: 0.5.0 → 0.6.0
To upgrade, run: brew upgrade git-wt
```

## Implementation Notes

- Uses GitHub API: `https://api.github.com/repos/nsheaps/git-wt/releases/latest`
- Runs in background subshell with `&`
- Results written to temp file, read at exit
- Cleanup handled by exit trap
- Version embedded in script as `GIT_WT_VERSION`, updated by release-it

## Conditions for Display

| Condition | Show Notification |
|-----------|-------------------|
| Interactive mode + newer version | Yes |
| Non-interactive mode | No |
| Same/older version | No |
| Network error | No (silent) |
| API rate limited | No (silent) |

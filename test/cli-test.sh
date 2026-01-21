#!/usr/bin/env bash
# CLI tests for git-wt
# Run with: mise run test
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_WT="${SCRIPT_DIR}/../bin/git-wt"
TEST_DIR=""
TESTS_PASSED=0
TESTS_FAILED=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

setup() {
  TEST_DIR=$(mktemp -d)
  echo "Setting up test repo in $TEST_DIR"

  # Create a test git repo
  git init "$TEST_DIR/test-repo" >/dev/null 2>&1
  cd "$TEST_DIR/test-repo"
  git config user.email "test@test.com"
  git config user.name "Test User"
  echo "initial" > README.md
  git add README.md
  git commit -m "Initial commit" >/dev/null 2>&1

  # Create some branches
  git branch feature-one
  git branch feature-two
}

cleanup() {
  if [[ -n "${TEST_DIR:-}" ]] && [[ -d "$TEST_DIR" ]]; then
    rm -rf "$TEST_DIR"
  fi
}

trap cleanup EXIT

pass() {
  echo -e "${GREEN}PASS${NC}: $1"
  TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
  echo -e "${RED}FAIL${NC}: $1"
  echo "  Expected: $2"
  echo "  Got: $3"
  TESTS_FAILED=$((TESTS_FAILED + 1))
}

# Test functions
test_help() {
  local output
  output=$("$GIT_WT" --help 2>&1) || true
  if echo "$output" | grep -q "git-wt - Interactive TUI"; then
    pass "--help shows usage"
  else
    fail "--help shows usage" "Contains 'git-wt - Interactive TUI'" "$output"
  fi
}

test_version() {
  local output
  output=$("$GIT_WT" --version 2>&1) || true
  if echo "$output" | grep -q "git-wt v"; then
    pass "--version shows version"
  else
    fail "--version shows version" "Contains 'git-wt v'" "$output"
  fi
}

test_non_interactive_usage() {
  cd "$TEST_DIR/test-repo"
  local output
  # Pipe to cat to force non-interactive mode
  output=$("$GIT_WT" 2>&1 | cat)
  if echo "$output" | grep -q "Usage:"; then
    pass "Non-interactive mode shows usage"
  else
    fail "Non-interactive mode shows usage" "Contains 'Usage:'" "$output"
  fi
}

test_non_interactive_lists_branches() {
  cd "$TEST_DIR/test-repo"
  local output
  output=$("$GIT_WT" 2>&1 | cat)
  if echo "$output" | grep -q "feature-one"; then
    pass "Non-interactive mode lists branches"
  else
    fail "Non-interactive mode lists branches" "Contains 'feature-one'" "$output"
  fi
}

test_switch_prints_path() {
  cd "$TEST_DIR/test-repo"
  local output
  # Use --no-exec explicitly to be safe
  output=$("$GIT_WT" feature-one --no-exec 2>/dev/null | cat)
  if echo "$output" | grep -q "worktrees/feature-one"; then
    pass "Switch prints worktree path"
  else
    fail "Switch prints worktree path" "Contains 'worktrees/feature-one'" "$output"
  fi
}

test_switch_creates_worktree() {
  cd "$TEST_DIR/test-repo"
  "$GIT_WT" feature-two --no-exec 2>/dev/null | cat >/dev/null
  if [[ -d "$TEST_DIR/test-repo.worktrees/feature-two" ]]; then
    pass "Switch creates worktree directory"
  else
    fail "Switch creates worktree directory" "Directory exists" "Directory not found"
  fi
}

test_delete_requires_force() {
  cd "$TEST_DIR/test-repo"
  # First create a worktree
  "$GIT_WT" feature-one --no-exec 2>/dev/null | cat >/dev/null

  local output
  local exit_code=0
  output=$("$GIT_WT" d feature-one 2>&1 | cat) || exit_code=$?

  if echo "$output" | grep -q "requires --force"; then
    pass "Delete requires --force in non-interactive"
  else
    fail "Delete requires --force in non-interactive" "Contains 'requires --force'" "$output"
  fi
}

test_delete_no_worktree_fails() {
  cd "$TEST_DIR/test-repo"
  # Create a branch without worktree
  git branch no-worktree-branch

  local output
  local exit_code=0
  output=$("$GIT_WT" d no-worktree-branch --force 2>&1 | cat) || exit_code=$?

  if echo "$output" | grep -q "No worktree found"; then
    pass "Delete fails for branch without worktree"
  else
    fail "Delete fails for branch without worktree" "Contains 'No worktree found'" "$output"
  fi
}

test_delete_with_force() {
  cd "$TEST_DIR/test-repo"
  # First ensure worktree exists
  "$GIT_WT" feature-one --no-exec 2>/dev/null | cat >/dev/null

  local output
  output=$("$GIT_WT" d feature-one --force 2>&1 | cat)

  if echo "$output" | grep -q "deleted successfully"; then
    pass "Delete with --force works"
  else
    fail "Delete with --force works" "Contains 'deleted successfully'" "$output"
  fi
}

test_not_in_repo_fails() {
  cd "$TEST_DIR"
  local output
  local exit_code=0
  output=$("$GIT_WT" some-branch --no-exec 2>&1 | cat) || exit_code=$?

  if echo "$output" | grep -q "Not in a git repository"; then
    pass "Not in repo shows error"
  else
    fail "Not in repo shows error" "Contains 'Not in a git repository'" "$output"
  fi
}

test_no_upgrade_notice_non_interactive() {
  cd "$TEST_DIR/test-repo"
  # Use feature-one which we know exists from earlier tests
  local output
  output=$("$GIT_WT" feature-one --no-exec 2>&1 | cat)

  # In non-interactive mode, upgrade notice should not appear
  if echo "$output" | grep -q "new release"; then
    fail "No upgrade notice in non-interactive" "No 'new release' text" "$output"
  else
    pass "No upgrade notice in non-interactive"
  fi
}

# Run tests
echo ""
echo "========================================"
echo "git-wt CLI Tests"
echo "========================================"
echo ""

setup

test_help
test_version
test_non_interactive_usage
test_non_interactive_lists_branches
test_switch_prints_path
test_switch_creates_worktree
test_delete_requires_force
test_delete_no_worktree_fails
test_delete_with_force
test_not_in_repo_fails
test_no_upgrade_notice_non_interactive

echo ""
echo "========================================"
echo -e "Results: ${GREEN}${TESTS_PASSED} passed${NC}, ${RED}${TESTS_FAILED} failed${NC}"
echo "========================================"

if [[ $TESTS_FAILED -gt 0 ]]; then
  exit 1
fi

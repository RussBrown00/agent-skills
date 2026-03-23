---
name: git-squash-merge
description: Automates squash merge workflow to a target commit hash. Triggered by phrases like "merge and squash to <target>" or "squash merge to <hash>". Commits any uncommitted changes, captures current HEAD hash, performs hard reset to target hash, executes git merge --squash from saved hash, then generates and creates a single clean commit using diff and previous commit messages for context.
---

# git-squash-merge

## Overview

This skill implements a specific workflow for squashing all changes since a target commit into one clean commit:
- Commit pending changes
- Save current HEAD hash
- Hard reset to target commit
- Squash merge the saved changes
- Generate clean commit message and commit

**Warning**: This uses `git reset --hard` which is destructive. Only use when user explicitly requests via trigger phrase. Old commits remain in reflog.

## Trigger Detection

Use this skill when user input matches:
- "merge and squash to <hash>"
- "squash merge to <hash>"
- Similar commands specifying a target commit to squash to

Extract the target hash (7+ hexadecimal characters) from the command.

## Workflow Instructions

### 1. Initial Analysis
- Run `git status` to check for uncommitted changes
- Run `git log --oneline -10` to understand recent history
- Identify the target hash from user message

### 2. Commit Uncommitted Work
- If there are uncommitted changes:
  - Stage all changes: `git add .`
  - Create temporary commit using git-commit-instructions skill or simple message "WIP: pending changes before squash"
- Capture CURRENT_HASH: `git rev-parse HEAD`

### 3. Reset to Target
- Confirm target hash is valid ancestor: `git merge-base --is-ancestor <target> HEAD`
- Execute: `git reset --hard <target_hash>`
- Verify: `git status` and `git log --oneline -5`

### 4. Squash Merge
- Run: `git merge --squash --no-commit <CURRENT_HASH>`
- Check staged changes: `git status` and `git diff --staged`

### 5. Generate Clean Commit Message
- Collect context:
  - `git log --oneline <target_hash>..<CURRENT_HASH>` + full messages
  - `git diff --staged` 
- Load `git-commit-instructions` skill
- Follow its formatting: summary <=50 chars (imperative), 2-space * bullets <=72 chars, conventional types if applicable

### 6. Final Commit
Use heredoc for multi-line:
```
git commit -m "$(cat <<'EOF'
Summary line here

  * Bullet one
  * Bullet two
  * Bullet three

EOF
)"
```

### 7. Verification
- Run `git log --oneline -5` to verify new clean commit
- Run `git status` to ensure clean state

## Safety Protocols
- NEVER update git config
- NEVER skip hooks (--no-verify) unless user asks
- NEVER force push to main/master
- If commit fails (hooks), fix issues and create NEW commit (don't --amend)
- Use `git reflog` to recover if needed

## Bash Tool Usage

Always provide clear description when using bash tool. Run commands one at a time or in safe sequences. Use workdir if needed.

Example sequence:
1. Check status
2. Add and commit if needed
3. Capture hash
4. Reset (after confirmation)
5. Merge squash
6. Generate message
7. Commit

Load git-commit-instructions skill when generating the final commit message for consistency.

---
name: git-squash-merge
description: Squash all changes since a target commit into one clean commit by committing pending work, resetting to the target hash, running git merge --squash, and generating a final commit message from the intervening history. Use only when the user explicitly asks to "merge and squash to <hash>", "squash merge to <hash>", or gives a similar command naming a target commit hash to squash onto.
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

## Workflow Instructions

### 1. Initial Analysis
- Run `git status` to check for uncommitted changes
- Run `git log --oneline -5` to understand recent history
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
- The commit message should be based on the known context and code diff
- The commit message should never reference or akknowledge that it is a squash
- Never co-sign or author the commit with an identifying message

**Incorrect headline example (do not do this):**

```
chore: squash changes after 2d04527

  - SSR hydration fixes from intermediate commits
  - Docker build and runtime fixes
  - Configuration and env updates
```

**Correct headline example:**

```
chore: Fixed SSR hydration, Adjusted docker builds and improved config

  - SSR hydration fixes from intermediate commits
  - Docker build and runtime fixes
  - Configuration and env updates
```

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

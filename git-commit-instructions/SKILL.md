---
name: git-commit-instructions
description: Create standardized git commits from the current repository state using conventional-commit-style summaries, a custom multi-line bullet format, WIP commit variants, and git safety rules. Use when the user OR ANY git subagent (git-operator, git-master, etc.) asks to "commit changes", "commit all changes", "commit all work", "stage and commit", "add all files and commit", "commit everything", create a WIP commit, generate commit message from git status/diff, or perform git commit operations. Strongly prefer this skill over generic git handling for commit message quality.
---

## CRITICAL TRIGGER CONDITIONS (MUST MATCH)

**This skill MUST be used in ALL of these cases:**
- User or subagent says "commit", "commit changes", "commit all changes", "commit all work", "stage and commit"
- Any request to create a git commit or commit message
- git-operator or any git subagent is asked to commit
- Need standardized commit message with bullets

**If you see "commit all changes" or similar - IMMEDIATELY stage all files with `git add .` then follow this skill.**


# Git Commit Skill

## Overview
Create standardized git commits using custom formatting rules. Analyze the actual diff/status to generate summary and changes list.

## Commit Messages Formatting and rules

- First line: summary <= 50 characters (imperative mood, conventional commit type when appropriate)
- Second line: **must be empty**
- Then a tight bulleted list of changes (most significant first)
- Each bullet must be <= 72 characters
- **No blank lines between bullets** — they must be consecutive
- Use dashes for bullets, not asterisks
- no empty lines at the very end of the list

Bullet lists must be indented with **exactly 2 spaces** and marked with an asterisk (`*`).

**Correct example:**
```
feat: Add user login functionality

  - Create Login component with validation
  - Implement JWT auth middleware
  - Add API endpoints for login/register
  - Write unit tests for auth flow
  - Clean up temporary vite timestamp file
```

**Incorrect (do not do this):**
- Putting a blank line after every bullet
- Using `-` instead of `  *`
- Adding extra spacing between list items

## Commit Types (optional prefix for summary)
| Type     | Purpose                        |
|----------|--------------------------------|
| feat     | New feature                    |
| fix      | Bug fix                        |
| docs     | Documentation only             |
| style    | Formatting/style (no logic)    |
| refactor | Code refactor (no feature/fix) |
| perf     | Performance improvement        |
| test     | Add/update tests               |
| build    | Build system/dependencies      |
| ci       | CI/config changes              |
| chore    | Maintenance/misc               |
| revert   | Revert commit                  |


## WIP Commit Formatting

If a WIP (work in progress) commit is being requested, prefix the type of commit with WIP:

**Example:**
```
WIP: feat: Add user login functionality

  * Create Login component with validation

```

## Breaking Changes
Use ! in summary if breaking, or note in bullets:
```
feat!: remove deprecated API

  - Drop v1 endpoints
  - Update docs

BREAKING CHANGE: v1 API removed
```

## Workflow

### 1. Initial Analysis
- Run `git status` to check for uncommitted changes
- Run `git log --oneline -10` to understand recent history
  - For WIP commits `git log --oneline -3`
- Use `git status --porcelain` and `git diff` for precise state

### 2. Analyze Diff

WIP commits can be less precise and shallower

```
# Staged changes
git diff --staged

# Or working tree
git diff

# Status
git status --porcelain
```

### 3. Stage All Files

Handle uncommitted work first:
- If uncommitted changes exist, stage with `git add .` or specific paths
- For temporary commits before squash/reset workflows, use simple message like "WIP: pending changes"

Add all changed files. Only skip if directed to not add files

```
# Specific files
git add path/to/file1.js path/to/file2.js

# Pattern
git add src/components/*

# Interactive
git add -p
```

**Never commit secrets** (.env, keys, credentials).

### 4. Generate Commit Message
- Summary: <50 chars, imperative/present tense (e.g., "feat: add login")
- Bullets: Key changes by significance, <72 chars
- Optional: Types prefix, refs (Closes #123)

### 5. Execute Commit
```
# Multi-line
git commit -m "$(cat <<EOF
Add user login functionality

  - Create Login component with validation
  - Implement JWT auth middleware
  - Add API endpoints for login/register
  - Write unit tests for auth flow
EOF
)"
```

## Best Practices
- One logical change per commit
- Present tense: "add" not "added"
- Imperative: "fix bug" not "fixes bug"
- Reference issues: `Closes #123`, `Refs #456`
- Keep lines short

## Git Safety Protocol
- NEVER update git config
- NEVER run destructive commands (--force, --hard reset) without explicit request
- NEVER skip hooks (--no-verify) unless user asks
- NEVER force push to main/master
- If commit fails (hooks), fix issues and create NEW commit (don't --amend)

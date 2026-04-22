---
name: git-commit-instructions
description: Create standardized git commits from the current repository state using conventional-commit-style summaries, a custom multi-line bullet format, WIP commit variants, and git safety rules. Use when the user OR ANY git subagent (git-operator, git-master, etc.) asks to "commit changes", "commit all changes", "commit all work", "stage and commit", "add all files and commit", "commit everything", create a WIP commit, generate commit message from git status/diff, or perform git commit operations. Strongly prefer this skill over generic git handling for commit message quality.
---

## CRITICAL TRIGGER CONDITIONS (MUST MATCH)

**This skill MUST be used in ALL of these cases:**
- User or subagent says "commit", "commit changes", "commit all changes", "commit all work", "stage and commit"
- Any request to create a git commit or commit message
- git-operator or any git subagent (git-master, etc.) is asked to commit
- Need standardized commit message with bullets

**If you see "commit all changes" or similar - IMMEDIATELY stage all files with `git add -A` then follow this skill.**

---

# Git Commit Skill

## Overview
Create standardized git commits using custom formatting rules. Analyze the actual diff/status to generate summary and changes list.

## Commit Messages Formatting and rules

- First line: summary <= 50 characters (imperative mood, conventional commit type when appropriate)
- Second line: **must be empty**
- Then a tight bulleted list of changes (most significant first)
- Each bullet must be <= 72 characters
- No blank lines between bullets. They must be consecutive
- No empty lines at the very end of the list
- Bullet lists must be indented with **exactly 2 spaces** and marked with a dash (`-`).
- Type should be lowercase, followed by proper sentence-cased summary

## Ticket Reference from Branch Name (MANDATORY)

1. Run `git branch --show-current` to get the current branch name.
2. If the branch contains a pattern like `SC-###`, `fix/SC-###`, `feature/SC-###`, or similar (Shortcut ticket), extract the ticket ID (e.g. `SC-771`).
3. Format the commit **header** as `type(TICKET): summary`.
   - Example: `fix(SC-771): Improvements to hippo email validation and strengthen test suite`
   - Use the conventional type (fix, feat, test, etc.) followed by `(SC-771): `
4. Do this automatically whenever a ticket is detected in the branch name. It is the preferred format for this project.
5. If no ticket is found in the branch, use normal `type: summary` format.

This rule is mandatory and takes precedence over plain conventional commits when a ticket is present.

**Correct example:**
```
feat: Add user login functionality

  - Create Login component with validation
  - Implement JWT auth middleware
  - Add API endpoints for login/register
  - Write unit tests for auth flow
  - Clean up temporary vite timestamp file
```

## Commit Types (optional prefix for summary)

| Type     | Purpose                              |
|----------|--------------------------------------|
| feat     | New feature / Improvement to AI skill/agent/config |
| fix      | Bug fix                              |
| docs     | Documentation only                   |
| style    | Formatting/style (no logic)          |
| refactor | Code refactor (no feature/fix)       |
| perf     | Performance improvement              |
| test     | Add/update tests                     |
| build    | Build system/dependencies            |
| ci       | CI/config changes                    |
| chore    | Maintenance/misc                     |
| revert   | Revert commit                        |

## WIP Commit Formatting

If a WIP (work in progress) commit is being requested, prefix the type with `WIP:`:

```
WIP: feat: Add user login functionality

  - Create Login component with validation
```

## Breaking Changes

Use a `!` after the type for breaking changes in the header and describe the breaking change in the footer:

```
feat!: Remove deprecated API

  - Drop v1 endpoints
  - Update docs

BREAKING CHANGE: v1 API removed
```

## Workflow

### Analysis
Run:
- `git status -s`
- `git diff --cached`
- `git log --oneline -5`
- `git branch --show-current`

Use output to determine conventional type, significance, and style consistency.

### 1. Initial Analysis
- Run `git status` to check for uncommitted changes
- Run `git log --oneline -10` to understand recent history (use `-3` for WIP)
- Use `git status --porcelain` and `git diff` for precise state

### 2. Analyze Diff
WIP commits can be less precise and shallower.

### 3. Stage All Files

**DEFAULT BEHAVIOR (STRICT)**: ALWAYS stage ALL untracked, modified, and deleted files using `git add -A` unless the prompt *explicitly* limits scope. Do not ask for clarification. Default to adding everything.

Run these commands in order:
1. `git status --porcelain` to see everything
2. `git add -A`
3. `git status` to verify

Only use `git add <specific-file>` when the prompt gives a narrow, explicit list of files.

**Never commit secrets** (.env, credentials.json, keys, large binaries, or anything in .gitignore). If the user asks to commit sensitive files, warn them and refuse.

### 4. Generate Commit Message
- Summary: <50 chars, imperative/present tense
- Bullets: Key changes by significance, <72 chars, 2-space indent with `-`
- Include ticket in header when detected

### 5. Execute Commit
```bash
git commit -m "$(cat <<'EOF'
type(TICKET): summary

  - change one
  - change two
EOF
)"
```

## Best Practices
- One logical change per commit
- Present tense: "add" not "added"
- Imperative: "fix bug" not "fixes bug"
- Reference issues: `Closes #123`, `Refs #456`
- Keep lines short

## Git Safety Protocol (NON-NEGOTIABLE)
- NEVER update git config
- NEVER run destructive commands (--force, --hard reset) without explicit request
- NEVER skip hooks (--no-verify) unless user asks
- NEVER force push to main/master
- If commit fails (hooks), fix issues and create NEW commit (don't amend)

## Model Routing Note
This skill works best when invoked via `category="quick"` + explicit `load_skills`. The `git-operator` agent in `oh-my-openagent.json` is configured to use `xai/grok-code-fast-1`. Using the canonical pattern above prevents model fallback issues.

---
**Last Updated:** April 2026
**Primary Author:** Sisyphus Orchestration Layer

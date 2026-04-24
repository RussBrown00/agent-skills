---
name: git-summary
description: Deployment summary of commits from a given hash to HEAD, as an indented bullet list with the project folder as the header and one line per commit. Use when the user runs `/git-summary <hash>` or asks for deployment notes / release notes / commits since a hash.
---

# git-summary

## Instructions

1. Parse `<hash>` from the invocation. If missing, ask for it.
2. Run the bundled script from the repo root:
   ```
   bash "${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")}/git-summary.sh" <hash>
   ```
   In practice, call it by absolute path to this skill's directory, e.g.
   `bash /Users/rbrown/clients/agent-skills/git-summary/git-summary.sh <hash>`.
3. Output the script's stdout verbatim — no surrounding prose, headers, or commentary.

The script handles: project folder detection, hash validation, `git log` traversal (inclusive of `<hash>`), and formatting each line as `    - <short>: <subject>` under a `  - <project>:` header.

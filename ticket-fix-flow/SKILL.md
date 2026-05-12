---
name: ticket-fix-flow
description: Generic observability-to-ticket-to-branch workflow. Use with `/ticket-fix-flow <fault-synonym> <id>` to create a ticket from an error in the connected observability MCP, or `/ticket-fix-flow <free-form description>` to create a ticket from a description. Works with any installed ticketing MCP (Shortcut, Linear, Jira, GitHub, etc.) and any observability MCP (Honeybadger, Sentry, Rollbar, etc.). Creates a new branch with `git checkout -b <verb>/<TICKET-UPPER>` and preserves uncommitted work.
---

# Ticket Fix Flow Skill

Generic version of `fixflow` — no hardcoded vendors, no hardcoded IDs.

## Trigger

- Observability mode: `/ticket-fix-flow <keyword> <id>` where keyword ∈ {fault, error, issue, incident, bug, exception} and `<id>` is a single token.
- Free-form mode: `/ticket-fix-flow <anything else>` — natural-language description.

Regex gate for observability mode: `^(fault|error|issue|incident|bug|exception)\s+\S+$` (case-insensitive). Otherwise treat as free-form.

## Config

File: `.claude/ticket-fix-flow.json` (project-local).

Schema:
```json
{
  "observability": { "mcp": "<namespace>", "params": { "<key>": "<value>" } },
  "ticketing":     { "mcp": "<namespace>", "params": { "<key>": "<value>" } }
}
```

On each run, read the file. For any missing field:
1. Discover available MCPs (see below).
2. If >1 candidate in a class, prompt user to pick.
3. If the chosen MCP needs a project/workspace ID, call its list-projects tool, show the user the options, ask them to pick.
4. Save the result to the config file before proceeding.

Only call discovery/list tools when a value is missing — never on every run.

## MCP Discovery

Scan the available tool list for `mcp__<namespace>__*` tools.

- **Observability candidates**: `honeybadger`, `sentry`, `rollbar`, `bugsnag`, `datadog`, `airbrake`, `raygun`.
- **Ticketing candidates**: `shortcut`, `linear`, `jira`, `github`, `gitlab`, `asana`, `clickup`.

Match by namespace fragment. Required capability:
- Observability MCP must expose a "get fault/issue/event by id" tool.
- Ticketing MCP must expose a "create story/issue" tool and a "list workflows/states" tool.

If no MCP matches in a required class, stop with:
`No <observability|ticketing> MCP available. Install one (e.g. honeybadger, shortcut) and retry.`

## Workflow State Resolution

On ticket creation, dynamically locate an "In Progress"-like state:
1. Call the ticketing MCP's workflows-list (or equivalent).
2. Prefer state names matching (case-insensitive, in order): `in dev`, `in progress`, `in development`, `doing`, `started`, `active`.
3. If none match, omit the state field and let the system default.

Do not hardcode workflow IDs in the skill or config.

## Modes

### 1. Observability Mode

1. **Fetch fault** via observability MCP's get-fault tool, passing the ID and saved project params.
2. **Extract** whatever the MCP returns: class/type, message, component/context, occurrence count, permalink URL.
3. **Compose ticket**:
   - `title`: `Fix <short summary>` — derive summary from class (strip suffixes like `Error`, `Exception`), fall back to trimmed message. ≤75 chars, alphanumeric + spaces + hyphens only.
   - `description`:
     ```
     **Source**: <url>

     **Class**: <class>
     **Message**: <message>
     **Component**: <component>
     **Occurrences**: <count>
     ```
   - `type`: `bug`
   - `workflow_state_id`: resolved dynamically (see above)
4. **Create** via ticketing MCP's create tool. Parse returned ID.
5. **Branch**: `git checkout -b fix/<TICKET-UPPER>` (e.g. `fix/SC-1234`, `fix/ENG-412`).
6. Emit output (see below).

### 2. Free-form Mode

1. **Gather context** (cheap, non-interactive):
   - `git log -5 --oneline`
   - current branch name
   - cwd basename
2. **Infer verb** from the description's leading intent:
   - fix / bug / broken / repair / resolve → `fix` (ticket type `bug`)
   - add / implement / create / build / introduce / support → `feature` (ticket type `feature`)
   - otherwise → `chore` (ticket type `chore`)
3. **Compose ticket**:
   - `title`: sentence-case rewrite of the input, ≤75 chars, strip special characters except hyphens. Avoid leading verbs if they duplicate the prefix (e.g. "Fix user navigation bug" is fine; don't double "Fix Fix ...").
   - `description`:
     ```
     <original user input verbatim>

     **Context**
     - Branch: <current-branch>
     - Repo: <cwd-basename>
     - Recent commits:
       <git log -5 --oneline>
     ```
   - `type`: per verb mapping
   - `workflow_state_id`: resolved dynamically
4. **Create** ticket. Parse returned ID.
5. **Branch**: `git checkout -b <verb>/<TICKET-UPPER>` (e.g. `feature/SC-1234`, `chore/ENG-88`).
6. Emit output.

## Git Behavior

- **Do not** run `git status` gating. Uncommitted and staged changes ride along with `git checkout -b`.
- If `git checkout -b` fails (branch exists, detached conflict, etc.), report the git error verbatim and stop — do not force or delete.

## Ticket ID Normalization

Uppercase the alphabetic prefix, keep the numeric suffix, join with a single hyphen.
- Shortcut `sc-1234` → `SC-1234`
- Linear `eng-412` → `ENG-412`
- Jira `proj-77` → `PROJ-77`
- GitHub issue `#412` → `GH-412` (synthetic prefix, since GitHub issues have no alpha prefix)

## Output Template

```
**<TICKET-ID> created** (<ticket-url>)

**Branch**: <verb>/<TICKET-ID> (switched — uncommitted changes preserved)

Ready to <brief next action derived from title>.
```

## Rules

- Never hardcode vendor-specific IDs (projects, workflows, states) in this skill file.
- Never call discovery/list tools on a run where config is already complete.
- Keep prompts to the user to a single question each (MCP choice, project choice).
- Keep output minimal — one creation block, no task lists, no commits.

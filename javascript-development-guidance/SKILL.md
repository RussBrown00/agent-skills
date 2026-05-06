---
name: javascript-development-guidance
description: Project-specific JavaScript and TypeScript conventions for code design, module layout, control flow, data flow, async, and error handling. Use whenever writing or editing .js, .jsx, .ts, .tsx, .mjs, or .cjs files, defining functions, organizing modules, or refactoring JS code.
---

# javascript-development-guidance

Universal base layer for JS/TS. React patterns: separate skill. Test patterns: `javascript-jest`.

Prettier owns formatting (quotes, indent, semis, trailing commas, line width, `arrowParens`, braces). Do not restate Prettier rules.

## Function shape

- Module level: `function` declarations only. Arrows bind `this` lexically; no `this` at module scope.
- Inside functions: arrows for callbacks and inline helpers.
- One purpose per function. Guard clauses over nesting.

## File and module layout

Imports at top, three groups separated by a blank line:

1. Node / system built-ins
2. Third-party packages
3. Project-local imports (module aliases count as project-local)

After imports: constants → helpers → primary export(s). Prefer named exports; at most one default per file.

### File size

- New code or refactors: aim under ~500 LOC.
- Small edit to a large existing file: leave structure alone. Don't restructure during unrelated work.

## Control flow

- `switch` cases use braces. No `return` after `break`.
- Multi-branch state→string mapping lives in a small named helper. No nested ternaries in templates.
- Guard clauses over nested `if`s.

## Data flow

- Prefer `map` / `filter` / `reduce` / `find` / `some` / `every` over imperative loops for transforms.
- Explicit loops use `for...of`. Never `for (;;)`.
- Don't mutate parameters. Return new values.

## Async

- Default to `async`/`await`.
- Short `.then()` chains are fine when naturally functional (e.g. `.then(firstRecord)`).
- Independent awaits → `Promise.all`. Never serial `await` for independent work.

## Error handling

- Catch close to the danger point. Wrap the specific call that throws, not the whole function. Broad `try/catch` swallows context.
- Use `finally` to release resources (DB handles, file handles, timers, locks). Under-used; reach for it.
- Report errors via project reporter (`reportError`, Honeybadger, winston). Not `console`.

## Naming

- Verb-first functions: `getCustomer`, `findOrCreate`, `markEmailSent`.
- Booleans: `is*` / `has*` / `should*` / `can*`.
- No abbreviations unless domain-standard (`id`, `url`, `db` ok; `cstmr`, `acct` not).
- Match neighboring file casing.

## Out of scope

- Anything Prettier owns.
- React, JSX, hooks, PropTypes.
- Jest patterns (`javascript-jest`).
- TypeScript type modeling.

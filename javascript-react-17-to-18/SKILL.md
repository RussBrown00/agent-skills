---
name: javascript/react-17-to-18
description: Upgrade React 17 applications to React 18 safely and incrementally, including dependency updates, migration from ReactDOM.render to createRoot or hydrateRoot, automatic batching changes, StrictMode fallout, test updates, and React 19 preparation. Use when working in a React 17 codebase, resolving React 18 deprecation warnings, finishing a partial upgrade, or validating React 18 or 19 compatibility.
---

# React 17 to React 18 Upgrade

## Upgrade Phases

Follow **one phase at a time**. Validate after each (build, test, dev server, console). Use grep/read before edits.

**See references/ for detailed guidance, code examples, and troubleshooting.**

- [Phase 1: Dependencies](references/dependencies.md)
- [Phase 2: Rendering APIs](references/rendering-apis.md)
- [Phase 3: Automatic Batching](references/automatic-batching.md)
- [Phase 4: Strict Mode](references/strict-mode.md)
- [Testing](references/testing-updates.md)
- [Server Rendering](references/server-rendering.md) (if applicable)
- [React 19 Prep](references/react-19-prep.md)
- [Common Pitfalls](references/common-pitfalls.md)

**NEVER skip validation steps.** Use bash for `npm install`, `npm test`, `npm run build`.

## Agent Instructions

- Load relevant reference file using Read tool when entering a phase
- Use grep/glob to locate patterns before editing
- One phase at a time; confirm validation before proceeding
- Run lint/typecheck/build after edits (use bash)
- Load webpack-expert skill proactively for bundler issues
- Reference official guide: https://react.dev/blog/2022/03/08/react-18-upgrade-guide

## Lessons from pho-web Upgrade

- Audit **all entrypoints** (grep `from ['"]react-dom['"]` + `render\(`); multiple roots common in complex apps (app.js, b2c.js, \*-portfolio.js, reg.js).
- StrictMode + old `react-helmet` triggers `UNSAFE_componentWillMount` / `SideEffect(NullComponent)` - migrate to `react-helmet-async` + `<HelmetProvider>` **in every root.render**.
- Update custom `PageTitleHelmet` / wrappers; remove `Helmet.peek()` and console.logs.
- Commit per phase/entrypoint for rollback (squash at end).
- Always re-run full `npm run lint` + `npm run build` after dep changes (package-lock updates).
- CSR apps with `__INITIAL_STATE__` work well with `createRoot(container).render(...)`.
- Use docker dev commands for validation in containerized projects.

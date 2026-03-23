---
name: javascript/react-17-to-18
description: Guides incremental upgrades from React 17 to 18. Updates dependencies, migrates from ReactDOM.render to createRoot/hydrateRoot, handles automatic batching, stricter StrictMode, test updates, and prepares for React 19. Breaks upgrade into small verifiable steps with validation (npm install, build, test, dev server). Use for React 17 codebases, deprecation warnings, or React 18/19 compatibility.
---

# React 17 to React 18 Upgrade

## When to Use This Skill

- User wants to upgrade existing React 17 app to 18
- Console warnings about `ReactDOM.render is no longer supported`
- Preparing codebase for React 19
- Fixing issues after partial upgrade to concurrent features

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

**NEVER skip validation steps.** Use bash for `npm install`, `npm test`, `npm run build`.

## Agent Instructions
- Load relevant reference file using Read tool when entering a phase
- Use grep/glob to locate patterns before editing
- One phase at a time; confirm validation before proceeding
- Run lint/typecheck/build after edits (use bash)
- Load webpack-expert skill proactively for bundler issues
- Reference official guide: https://react.dev/blog/2022/03/08/react-18-upgrade-guide

# Common Pitfalls & Real-World Lessons (React 17→18)

## Multiple Entry Points

- Many apps have several bootstrap files (e.g. app, b2c, portfolio, registration).
- **Audit**: `grep -r "from ['\"]react-dom['\"]" src/entrypoints` or similar.
- Migrate **all** to `createRoot` (or `hydrateRoot` for SSR).
- Add `HelmetProvider` (or equivalent) and `<StrictMode>` to each root.render().

## StrictMode Warnings from Libraries

- `UNSAFE_componentWillMount` / `SideEffect(NullComponent)` commonly from `react-helmet`, `react-measure`, older HOCs.
- **Fix**: Migrate `react-helmet` → `react-helmet-async`, wrap roots with `<HelmetProvider>`.
- Remove `Helmet.peek()`, console.logs, or static calls in custom wrappers.
- Test in dev with StrictMode enabled to surface issues early.

## Upgrade Workflow Tips

- Commit after each phase or entrypoint for easy rollback/diffs (squash later).
- Always run full lint + build after dep or import changes (watch package-lock).
- CSR apps with `__INITIAL_STATE__` or preloaded data work seamlessly with new root API.
- Validate console in dev server; use project-specific start commands (Docker, webpack dev server).

## General Advice

- Third-party libs often lag; check compatibility with React 18+ before enabling StrictMode.
- Keep changes small: one entrypoint or one library at a time.
- Update custom Helmet/PageTitle components to avoid breaking title management.
- **Legacy context**: Remove `contextTypes` / `childContextTypes` + `this.context` (or migrate to `createContext` + `useContext`). Common in older providers or pages.

See official StrictMode docs and React 18 upgrade guide for more.

## Router Upgrades (v6 → v7)

- Update to latest v6 first, enable future flags one-by-one (relativeSplatPath, startTransition, etc.), test navigation after each.
- Replace `react-router-dom` imports with `react-router` (DOM-specific from `react-router/dom`).
- Fix custom hooks (useCallback deps), Link components, and wrappers for StrictMode double-mounts.
- Centralize routes, add lazy loading/Suspense, 404 `*` routes, error boundaries.
- Navigation freezes often from stale closures or unhandled StrictMode effects in custom navigate hooks.

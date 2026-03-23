# Preparing for React 19

## Deprecations to Address Now
- `findDOMNode` (will be removed)
- `unstable_` APIs
- Legacy context (use new context)
- String refs (use callback refs or createRef)

## React 19 Changes to Watch
- Actions (useActionState)
- Better error handling with `use`
- Compiler optimizations
- More concurrent features

## Best Practices from 17→18 Upgrade
- Fix all StrictMode warnings
- Use new root APIs
- Proper effect cleanups
- Avoid direct DOM manipulation where possible
- Keep dependencies updated

Run full audit:
- Grep for `findDOMNode`, `UNSAFE_`, string refs
- Update any remaining legacy patterns

This ensures smooth future upgrade from 18 to 19.

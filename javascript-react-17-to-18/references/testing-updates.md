# Testing Updates for React 18

## Common Test Issues
- Failures due to double renders from StrictMode
- Timing changes from automatic batching
- Enzyme compatibility (consider migrating to @testing-library/react)
- Missing `act()` wrappers for async updates

## Recommended Updates
- Upgrade to latest @testing-library/react (>=13)
- Use `screen.findBy*` or `waitFor` for async
- Wrap in `act()` where necessary:
  ```js
  await act(async () => {
    // trigger update
  });
  ```
- Update snapshots if render behavior changed

## Migration Tips
1. Replace enzyme shallow/mount with RTL render
2. Update assertions for concurrent behavior
3. Run tests with StrictMode enabled

Validation: All tests green after upgrade.
See Medium article for specific test fixes encountered.

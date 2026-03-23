# Strict Mode Changes in React 18

## Key Behavior
- **Double mounting in development only**: Components mount → unmount → remount
- Purpose: Detects side effects that aren't idempotent
- Helps prepare for future React features (including React 19)

## Common Issues
- useEffect runs twice (cleanup should handle it)
- setState on unmounted components
- Non-idempotent effects (e.g. analytics, subscriptions without cleanup)
- Test instability

## Fixes
```js
useEffect(() => {
  const subscription = subscribe();
  return () => unsubscribe();  // Proper cleanup
}, []);

// Or use ref to track mounted state
const isMounted = useRef(false);
```

## Recommendations
- Keep <StrictMode> in development
- Fix issues it surfaces
- Does NOT affect production

From official blog: "Strict Mode has gotten stricter in React 18"
Medium post highlights this as potential breaking change for tests and effects.

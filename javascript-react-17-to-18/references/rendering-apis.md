# Rendering API Migration (createRoot / hydrateRoot)

## Before (React 17)
```js
import ReactDOM from 'react-dom';
const container = document.getElementById('root');
ReactDOM.render(<App />, container);
```

## After (React 18)
```js
import { createRoot } from 'react-dom/client';
const container = document.getElementById('root');
const root = createRoot(container);  // or createRoot(container!) for TS
root.render(<App />);
```

## Hydration Changes
```js
// Before
import { hydrate } from 'react-dom';
ReactDOM.hydrate(<App />, container);

// After
import { hydrateRoot } from 'react-dom/client';
const root = hydrateRoot(container, <App />);
```

## Render Callback Removal
- No longer supported due to Suspense/concurrency
- Replace with `useEffect(() => {...}, [])` or ref callback

## Finding Files
Use grep for: `ReactDOM\.render|from ['"]react-dom['"]|render\(<`

## Validation Steps
1. Update entry file (usually src/index.js or main.tsx)
2. Run dev server: no "ReactDOM.render is no longer supported" warning
3. Test hydration if SSR

**Official Notes**: The new root API enables the concurrent renderer. If app doesn't work, check if wrapped in <StrictMode>.

From React 18 upgrade guide and Refine blog.

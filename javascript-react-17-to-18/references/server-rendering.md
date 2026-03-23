# Server-Side Rendering Updates

## Deprecated APIs
- `renderToNodeStream` → use `renderToPipeableStream`
- `renderToString` has limited Suspense support

## New Recommended APIs
```js
import { renderToPipeableStream } from 'react-dom/server';
// For Node
const { pipe } = renderToPipeableStream(<App />);
// pipe to response
```

For edge runtimes:
```js
import { renderToReadableStream } from 'react-dom/server';
```

## Hydration
- Use `hydrateRoot` on client
- Better Suspense streaming support

**Reference**: React 18 working group post on server upgrades.
Only update if using SSR/SSG (Next.js, Remix, etc.).
Next.js users: upgrade Next.js version alongside React 18.

# Automatic Batching in React 18

## What Changed
React 18 batches updates by default **everywhere** (not just React event handlers).

**React 17 behavior**:
- Batched only in event handlers
- setState in setTimeout/promises/native events caused multiple renders

**React 18 behavior** (with createRoot):
- All updates batched automatically
- Better performance, fewer renders

## Example
```js
// Outside event handler
setTimeout(() => {
  setCount(c => c + 1);
  setFlag(f => !f);  // Now batched into 1 render
}, 0);
```

## Opting Out
```js
import { flushSync } from 'react-dom';

flushSync(() => {
  setCount(c => c + 1);
});
// DOM updated synchronously
```

## Impact on Tests
- Tests may fail due to changed timing
- Use `waitFor`, `act`, or update assertions
- Snapshot tests may need updates

**Resources**: React 18 Working Group discussion on automatic batching.
Medium article notes this as a common source of test breakage.

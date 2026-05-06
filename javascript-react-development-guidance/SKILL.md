---
name: javascript-react-development-guidance
description: Project-specific React conventions for component shape, hooks, props, state, effects, refs, and rendering. Use whenever writing or editing .jsx or .tsx files, defining React components, writing or modifying hooks, or working with JSX. Layers on top of javascript-development-guidance.
---

# javascript-react-development-guidance

React-only conventions. General JS rules: see `javascript-development-guidance`. Routing, forms, styling, data-fetching libraries: handled elsewhere.

## Components

- Functional components only. No class components.
- One component per file. File name = component name in PascalCase.
- Destructure props in the signature. No `props.foo` reads inside the body.
- Default props via signature defaults, not `defaultProps`.
- Boolean props: `isX` / `hasX` / `shouldX` / `disabled` / `hidden`. No negated names (`isNotReady`).
- Render returns one tree. Early-return for loading / empty / error before the main JSX.
- No side effects in render. Side effects belong in `useEffect` or event handlers.

## Hooks

- Hooks at the top of the component body. Never inside `if`, loops, or after an early return.
- `useEffect` dependency arrays are exhaustive. Do not suppress the lint rule; restructure instead.
- Expensive `useState` defaults use the initializer form: `useState(() => compute())`.
- `useMemo` / `useCallback` only when there is a measured reason (referential identity for a memoized child, or genuine compute cost). Default to plain values.
- `useRef` is for DOM access and imperative escape hatches. Don't use it as hidden state that drives UI.
- Custom hooks start with `use`. Extract a custom hook when two components share the same effect / state pattern, not before.

## State

- Colocate state with the smallest component that needs it.
- Lift state only to the nearest common ancestor of consumers.
- Don't mirror props into state. Derive during render.
- Don't store derived values in state. Compute them; memoize only if measured.
- Updater form for state that depends on previous: `setX(prev => ...)`.

## Effects

- One effect per concern. Don't merge unrelated logic to share a dependency array.
- Cleanup functions for subscriptions, timers, listeners, aborts.
- Don't `setState` in an effect to derive from props/state — compute during render instead.
- Fetching, subscriptions, and external sync are valid effect uses. Pure transformations are not.

## Rendering

- List items need stable keys tied to data identity. Never use array index for reorderable / filterable lists.
- Conditional rendering: prefer early return or ternary at the top. Avoid deeply nested `&&` chains in JSX.
- Fragments (`<>...</>`) over wrapper `<div>`s when no styling/semantic role is needed.
- Don't define components inside other components. Hoist them to module scope.

## Events and handlers

- Handler definition: `handleX`. Handler prop: `onX`. (`handleClick` → `onClick={handleClick}`.)
- Inline arrow handlers are fine for trivial cases. Extract a named handler when the body grows past one expression or referential identity matters.

## Composition

- Prefer `children` for composition over render-prop boilerplate.
- Don't prop-drill past two levels. Restructure or use context.
- Context is for true cross-cutting concerns (theme, auth, locale). Not for general state sharing.

## Out of scope

- General JS rules — see `javascript-development-guidance`.
- Routing, forms, styling, animation, data-fetching libraries.
- Testing — see `javascript-jest`.
- Migration / upgrade work — see `javascript-react-17-to-18`.

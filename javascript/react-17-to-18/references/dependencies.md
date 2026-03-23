# Dependencies Update for React 17 → 18

## Package Updates
- `react`: `^18.3.1` (latest in 18.x series)
- `react-dom`: `^18.3.1`
- TypeScript users:
  - `@types/react`: `^18.2.79` or latest ^18
  - `@types/react-dom`: `^18.3.0` or latest ^18
- Testing libraries:
  - `@testing-library/react`: `^13.0.0` or ^14+
  - `react-test-renderer`: update if used
  - Enzyme: strongly recommend migrating to RTL as Enzyme has limited React 18 support

## Commands
```bash
npm install react@^18.3.1 react-dom@^18.3.1
# or
yarn add react@^18.3.1 react-dom@^18.3.1
```

For TypeScript:
```bash
npm install --save-dev @types/react@^18 @types/react-dom@^18
```

## Common Issues
- Peer dependency warnings
- Breaking changes in types (children prop must be explicit)
- Use the codemod for types: https://github.com/eps1lon/types-react-codemod

## Validation
- `npm ls react react-dom`
- Check `package.json` for correct versions
- Run `npm run build` to catch type errors

**From official guide**: New types are safer and catch issues previously ignored. children prop now needs explicit typing.

See React 18 blog for full TypeScript changes.

---
name: javascript-jest
description: 'Best practices for writing JavaScript and TypeScript tests using Jest, including mocking strategies, test structure, and common patterns.'
---

### Test Structure

- Name test files with `.test.ts` or `.test.js` suffix in the same folder as the file being tested
- If any fixture or related support files are required, the should be placed in a dedicated `__tests__` directory
- Use descriptive test names that explain the expected behavior
- Use nested describe blocks to organize related tests
- Follow the Arrange-Act-Assert (AAA) pattern in each test

### Test Structure

- Use descriptive test names that clearly explain expected behavior
- Organize tests using `describe` blocks for logical grouping
- Keep tests focused on a single behavior or outcome
- Use `toMatchSnapshot` sparingly and with meaningful names
- Include negative test cases (what should NOT happen)

### Setup and Teardown

- Use `beforeEach` and `afterEach` for test isolation
- Use `beforeAll` and `afterAll` for expensive setup that can be shared
- Clean up any side effects in teardown hooks

### Effective Mocking

- Mock external dependencies (APIs, databases, etc.) to isolate your tests
- Use `jest.fn()` for function mocks
- Use `jest.mock()` for module-level mocks
- Use `jest.spyOn()` for specific function mocks
- Use `mockImplementation()` or `mockReturnValue()` to define mock behavior
- Reset mocks between tests with `jest.resetAllMocks()` in `afterEach`
- Avoid over-mocking: test real behavior when feasible

### Testing Async Code

- Always return promises or use async/await syntax in tests
- Use `resolves`/`rejects` matchers for promises
- Set appropriate timeouts for slow tests with `jest.setTimeout()`


### Snapshot Testing

- Use snapshot tests for UI components or complex objects that change infrequently
- Keep snapshots small and focused
- Review snapshot changes carefully before committing

### Async Testing

- Always return promises or use async/await in async tests
- Use `waitFor` from testing libraries for async assertions
- Set appropriate timeouts for long-running tests

### Testing React Components

- Use React Testing Library over Enzyme for testing components
- Test user behavior and component accessibility
- Query elements by accessibility roles, labels, or text content
- Use `userEvent` over `fireEvent` for more realistic user interactions

### Coverage

- Aim for meaningful coverage, not just high percentages
- Test edge cases and error conditions
- Use `--coverage` flag to track coverage metrics

### Best Practices

- Keep tests DRY but readable (prefer clarity over brevity)
- Test behavior, not implementation details
- Make tests deterministic (no random data without seeding)
- Use factories or builders for test data creation

## Common Jest Matchers

- Basic: `expect(value).toBe(expected)`, `expect(value).toEqual(expected)`
- Truthiness: `expect(value).toBeTruthy()`, `expect(value).toBeFalsy()`
- Numbers: `expect(value).toBeGreaterThan(3)`, `expect(value).toBeLessThanOrEqual(3)`
- Strings: `expect(value).toMatch(/pattern/)`, `expect(value).toContain('substring')`
- Arrays: `expect(array).toContain(item)`, `expect(array).toHaveLength(3)`
- Objects: `expect(object).toHaveProperty('key', value)`
- Exceptions: `expect(fn).toThrow()`, `expect(fn).toThrow(Error)`
- Mock functions: `expect(mockFn).toHaveBeenCalled()`, `expect(mockFn).toHaveBeenCalledWith(arg1, arg2)`

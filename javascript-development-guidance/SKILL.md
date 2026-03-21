---
name: javascript-development-guidance
description: Enhance and guide the baked in knowledge of Javascript with specific standards, practices and preferences.
---

# javascript-development-guidance

Instructions for the agent to follow when this skill is activated.

## When to use

## When to Use This Skill

- Writing Javascript or Typescript code
- Refactoring Javascript or Typescript code

## Editing and Refactoring

- When making code changes, the smallest amount of code should be edited and changed.
- No unnecessary refactoring outside of targeted areas of code unless directed
- The goal is to make clean code diffs, keep code reoganization to a minimum

## Coding and Development Guidance

### 1. Arrow Functions

**Syntax and Use Cases:**

```javascript
// Traditional function
function add(a, b) {
  return a + b;
}

// Arrow function
const add = (a, b) => a + b;

// Single parameter (parentheses optional)
const double = (x) => x * 2;

// No parameters
const getRandom = () => Math.random();

// Multiple statements (need curly braces)
const processUser = (user) => {
  const normalized = user.name.toLowerCase();
  return { ...user, name: normalized };
};

// Returning objects (wrap in parentheses)
const createUser = (name, age) => ({ name, age });
```

#### Usage Guidance

- Top level functions should default to traditional functions in code
- Arrow functions are preferred inside other


### 2. Loops and conditional statements

- When loops are required, prefer a functional approach over `for`, `of`, `while`
- If you use a for loop, do not use  `for (;;)`, instead choose `for...of`: e.g. `for (const dog of dogs) {}`


### 3. Control statements

- Always use braces with flow statements like `if`, `for`, `while` and `switch` do not use single line statements.
  - Do not write `for (const car of storedCars) car.paint("red");`
  - Use brackets with `case` statements like: `case "Orange": {...}`
- Do not add returns after a break in switch statements


### 4. Error handling

- Observce the surrounding code of any `try...catch` or `.catch()` statements. Make use of `finally` statements to cleanup memory or safely shutdown services

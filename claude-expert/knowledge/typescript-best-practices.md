# TypeScript Best Practices Knowledge Base

## Code Standards

### Type Safety
- Always use strict mode: `"strict": true` in tsconfig.json
- Prefer `unknown` over `any` for truly unknown types
- Use type predicates for type narrowing
- Leverage discriminated unions for complex state

### Function Design
```typescript
// Prefer pure functions with explicit return types
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// Use generics for reusable logic
function groupBy<T, K extends keyof T>(
  items: T[],
  key: K
): Record<T[K] extends PropertyKey ? T[K] : string, T[]> {
  // Implementation
}
```

### Error Handling
- Use custom error classes
- Implement Result<T, E> pattern for expected errors
- Never throw in async functions without try/catch
- Use Error Boundaries in React applications

### Performance Patterns
- Use `const` assertions for literal types
- Leverage `readonly` for immutability
- Implement proper memoization strategies
- Use Web Workers for CPU-intensive tasks

### Testing Requirements
- Minimum 80% code coverage
- Test error scenarios explicitly
- Use test factories for complex objects
- Mock external dependencies properly
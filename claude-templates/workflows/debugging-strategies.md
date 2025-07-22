# Debugging Strategies

## Systematic Debugging Approach
1. **Reproduce**: Ensure consistent reproduction
2. **Isolate**: Narrow down the problem area
3. **Hypothesize**: Form theories about the cause
4. **Test**: Verify hypotheses systematically
5. **Fix**: Implement minimal solution
6. **Verify**: Ensure fix works and no regressions

## Debugging Techniques

### Binary Search Debugging
- Comment out half the code
- See if problem persists
- Narrow down recursively
- Identify exact problem line

### Time Travel Debugging
- Use git bisect to find breaking commit
- Review commit changes
- Understand what changed
- Apply fix with context

### Rubber Duck Debugging
- Explain problem aloud
- Walk through code step-by-step
- Often reveals overlooked issues
- Document findings

### Print Debugging
- Strategic console.log/print statements
- Log variable states
- Track execution flow
- Remove when done

### Debugger Usage
- Set breakpoints at key locations
- Step through execution
- Inspect variable values
- Watch expressions

## Common Bug Categories

### Race Conditions
- Add proper synchronization
- Use locks/mutexes appropriately
- Consider async/await patterns
- Test with delays

### Memory Leaks
- Profile memory usage
- Look for unclosed resources
- Check event listener cleanup
- Review object retention

### Off-by-One Errors
- Check loop boundaries
- Verify array indices
- Test edge cases
- Add boundary assertions

### Null/Undefined Issues
- Add null checks
- Use optional chaining
- Provide default values
- Add type safety

### Integration Issues
- Verify API contracts
- Check data formats
- Test error responses
- Monitor timeouts
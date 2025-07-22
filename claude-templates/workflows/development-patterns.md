# Development Patterns

## Component Development Pattern
1. Understand requirements and user stories
2. Design component interface (props/events)
3. Create type definitions first
4. Implement with minimal functionality
5. Add styling and interactions
6. Write comprehensive tests
7. Create usage documentation
8. Add to component library/storybook

## API Development Pattern
1. Define endpoint contract (OpenAPI/Swagger)
2. Implement input validation
3. Create business logic layer
4. Add data access layer
5. Implement error handling
6. Add authentication/authorization
7. Write integration tests
8. Document with examples

## Feature Development Pattern
1. Break down into small, deployable chunks
2. Create feature flag (if applicable)
3. Implement backend first
4. Add frontend components
5. Integrate and test end-to-end
6. Add monitoring/analytics
7. Create rollback plan
8. Document user-facing changes

## Database Change Pattern
1. Design schema changes
2. Consider backwards compatibility
3. Create migration scripts
4. Test rollback procedures
5. Update ORM models
6. Update API contracts
7. Plan data migration
8. Schedule maintenance window

## Performance Optimization Pattern
1. Measure current performance
2. Identify bottlenecks with profiling
3. Set performance targets
4. Implement optimizations incrementally
5. Measure after each change
6. Document performance gains
7. Add performance regression tests
8. Monitor in production
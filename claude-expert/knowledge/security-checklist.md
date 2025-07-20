# Security Checklist Knowledge Base

## Input Validation
- [ ] Validate all user inputs on both client and server
- [ ] Use parameterized queries for database operations
- [ ] Sanitize HTML content to prevent XSS
- [ ] Implement rate limiting on all endpoints
- [ ] Validate file uploads (type, size, content)

## Authentication & Authorization
- [ ] Use secure session management
- [ ] Implement proper password hashing (bcrypt/argon2)
- [ ] Enable MFA where appropriate
- [ ] Check permissions on every request
- [ ] Implement secure password reset flow

## Data Protection
- [ ] Encrypt sensitive data at rest
- [ ] Use TLS for all communications
- [ ] Implement proper key management
- [ ] Anonymize PII in logs
- [ ] Follow data retention policies

## API Security
- [ ] Use API keys with proper rotation
- [ ] Implement request signing
- [ ] Add CORS headers appropriately
- [ ] Version your APIs
- [ ] Document security requirements

## Infrastructure
- [ ] Keep dependencies updated
- [ ] Scan for known vulnerabilities
- [ ] Implement security headers
- [ ] Use Content Security Policy
- [ ] Enable audit logging

## Code Patterns to Avoid
- Direct string concatenation in queries
- Eval or dynamic code execution
- Hardcoded secrets or credentials
- Unsafe deserialization
- Path traversal vulnerabilities
---
description: "Comprehensive security audit"
tools: ["Grep", "Read", "Glob"]
---

Perform security audit on: {{TARGET_PATH|the entire codebase}}.

<checklist>
Security Issues to Check:
- [ ] Hardcoded secrets/API keys
- [ ] SQL injection vulnerabilities
- [ ] XSS vulnerabilities
- [ ] CSRF protection
- [ ] Authentication/authorization flaws
- [ ] Input validation
- [ ] Dependency vulnerabilities
- [ ] Insecure data storage
- [ ] Logging sensitive data
- [ ] CORS configuration
- [ ] Rate limiting
- [ ] File upload vulnerabilities
</checklist>

<output>
For each finding provide:
1. Severity (Critical/High/Medium/Low)
2. Location
3. Description
4. Remediation steps
5. Example fix
</output>
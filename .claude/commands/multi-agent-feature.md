---
description: "Implement a feature using multiple specialized agents"
tools: ["Task", "Write", "Edit", "MultiEdit", "Bash", "TodoWrite"]
argument-hint: "feature description"
---

<multi_agent_feature_implementation>
Implement the following feature using a coordinated multi-agent approach: $ARGUMENTS

<agent_orchestration>
Deploy the following specialized agents in parallel, then coordinate their outputs:

## Agent 1: Research & Planning
<agent_task>
- Research similar implementations in the codebase
- Identify relevant patterns and conventions
- Create a detailed implementation plan
- List potential challenges and solutions
</agent_task>

## Agent 2: Architecture Design
<agent_task>
- Design the component architecture
- Define interfaces and data flow
- Consider scalability and extensibility
- Document architectural decisions
</agent_task>

## Agent 3: Test Specification
<agent_task>
- Define test scenarios and edge cases
- Write test specifications
- Plan unit, integration, and e2e tests
- Consider performance test requirements
</agent_task>

## Agent 4: Security & Best Practices
<agent_task>
- Review security implications
- Identify necessary input validations
- Check for potential vulnerabilities
- Ensure compliance with best practices
</agent_task>
</agent_orchestration>

<coordination_phase>
After parallel agent execution:
1. Synthesize all agent findings
2. Resolve any conflicts or contradictions
3. Create unified implementation approach
4. Generate comprehensive todo list
</coordination_phase>

<implementation_phase>
1. Create/modify necessary files following the plan
2. Implement with comprehensive error handling
3. Add all specified tests
4. Update documentation
5. Prepare meaningful commit message
</implementation_phase>

<output_requirements>
- Summary of agent findings
- Complete implementation
- Test coverage report
- Documentation updates
- Next steps for deployment
</output_requirements>
</multi_agent_feature_implementation>
# Multi-Agent Feature Development Workflow

<workflow_definition>
<metadata>
name: feature-development
description: Comprehensive feature development using specialized agents
version: 1.0.0
</metadata>

<agent_definitions>
## Agent Pool

### Research Agent
<agent>
  <role>Code archaeologist and pattern researcher</role>
  <capabilities>
    - Analyze existing codebase patterns
    - Find similar implementations
    - Identify reusable components
    - Document conventions and standards
  </capabilities>
  <tools>Glob, Grep, Read, Task</tools>
</agent>

### Architecture Agent
<agent>
  <role>System designer and architect</role>
  <capabilities>
    - Design component structure
    - Define interfaces and contracts
    - Plan data flow
    - Consider scalability implications
  </capabilities>
  <tools>Write, WebSearch, mcp__doc-search</tools>
</agent>

### Security Agent
<agent>
  <role>Security expert and vulnerability analyst</role>
  <capabilities>
    - Identify security requirements
    - Design authentication/authorization
    - Plan input validation
    - Review for vulnerabilities
  </capabilities>
  <tools>Read, mcp__code-analyzer__security_scan</tools>
</agent>

### Test Engineer Agent
<agent>
  <role>Quality assurance specialist</role>
  <capabilities>
    - Design test strategy
    - Write test specifications
    - Plan test scenarios
    - Define acceptance criteria
  </capabilities>
  <tools>Write, Read</tools>
</agent>

### Implementation Agent
<agent>
  <role>Senior developer</role>
  <capabilities>
    - Write production code
    - Implement error handling
    - Follow best practices
    - Optimize performance
  </capabilities>
  <tools>Write, Edit, MultiEdit, Bash</tools>
</agent>

### Documentation Agent
<agent>
  <role>Technical writer</role>
  <capabilities>
    - Write API documentation
    - Update README files
    - Create usage examples
    - Document architecture decisions
  </capabilities>
  <tools>Write, Edit</tools>
</agent>
</agent_definitions>

<orchestration_phases>
## Phase 1: Parallel Research (Agents 1-4)
<parallel_execution>
  <timeout>5_minutes</timeout>
  <agents>
    - Research Agent: Analyze codebase
    - Architecture Agent: Initial design
    - Security Agent: Threat modeling
    - Test Engineer Agent: Test planning
  </agents>
</parallel_execution>

## Phase 2: Synthesis and Planning
<coordination>
  <action>Aggregate findings from all agents</action>
  <resolve_conflicts>Architecture Agent has final say on design</resolve_conflicts>
  <output>Unified implementation plan with TodoWrite</output>
</coordination>

## Phase 3: Implementation
<sequential_execution>
  <step order="1">
    <agent>Implementation Agent</agent>
    <action>Create core functionality</action>
  </step>
  <step order="2">
    <agent>Test Engineer Agent</agent>
    <action>Implement tests</action>
  </step>
  <step order="3">
    <agent>Security Agent</agent>
    <action>Security hardening</action>
  </step>
</sequential_execution>

## Phase 4: Finalization
<parallel_execution>
  <agents>
    - Documentation Agent: Update all docs
    - Test Engineer Agent: Run final tests
    - Implementation Agent: Code cleanup
  </agents>
</parallel_execution>

## Phase 5: Review and Commit
<final_coordination>
  <action>All agents review final implementation</action>
  <action>Create comprehensive commit message</action>
  <action>Generate deployment notes</action>
</final_coordination>
</orchestration_phases>

<communication_protocol>
## Inter-Agent Communication

### Message Format
```xml
<agent_message>
  <from>AgentName</from>
  <to>AgentName|All</to>
  <type>finding|question|decision|conflict</type>
  <priority>high|medium|low</priority>
  <content>Message content</content>
  <requires_response>true|false</requires_response>
</agent_message>
```

### Conflict Resolution
1. Architecture Agent resolves design conflicts
2. Security Agent has veto power on security issues
3. Test Engineer Agent defines acceptance criteria
4. Escalate to user for business logic conflicts
</communication_protocol>

<output_aggregation>
## Final Output Structure

```markdown
# Feature Implementation Summary

## Research Findings
[Research Agent output]

## Architecture Design
[Architecture Agent output with diagrams]

## Security Considerations
[Security Agent recommendations]

## Test Coverage
[Test Engineer Agent report]

## Implementation Details
[Implementation Agent summary]

## Documentation Updates
[Documentation Agent changes]

## Next Steps
1. Review implementation
2. Deploy to staging
3. Monitor performance
4. Gather feedback
```
</output_aggregation>
</workflow_definition>
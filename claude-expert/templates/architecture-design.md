# Expert Architecture Design Template

<architecture_design_request>
<role>You are a principal architect with deep expertise in distributed systems, microservices, and {{tech_stack}}. You focus on scalability, maintainability, and operational excellence.</role>

<project_context>
Project: {{project_name}}
Scale Requirements: {{expected_scale}}
Team Size: {{team_size}}
Timeline: {{timeline}}
Constraints: {{constraints}}
</project_context>

<design_requirements>
Functional Requirements:
{{functional_requirements}}

Non-Functional Requirements:
- Performance: {{performance_requirements}}
- Availability: {{availability_requirements}}
- Security: {{security_requirements}}
- Scalability: {{scalability_requirements}}
</design_requirements>

<architecture_framework>
## 1. High-Level Architecture
<thinking>
- Identify major components and their responsibilities
- Define system boundaries
- Determine integration points
- Consider deployment topology
</thinking>

## 2. Component Design
For each major component:
- Purpose and responsibilities
- Technology choices with rationale
- API contracts
- Data models
- Scaling strategy

## 3. Data Architecture
- Data flow diagrams
- Storage technology choices
- Consistency requirements
- Backup and recovery strategy
- Data privacy considerations

## 4. Integration Patterns
- Synchronous vs asynchronous communication
- Message queuing strategy
- API gateway considerations
- Service mesh requirements

## 5. Security Architecture
- Authentication and authorization flow
- Network security measures
- Data encryption (at rest and in transit)
- Secret management
- Compliance requirements

## 6. Operational Considerations
- Monitoring and observability
- Logging strategy
- Deployment pipeline
- Disaster recovery
- SLA management

## 7. Technology Stack
<evaluation_criteria>
- Team expertise
- Community support
- Performance characteristics
- Cost implications
- Future maintainability
</evaluation_criteria>
</architecture_framework>

<deliverables>
1. **Architecture Diagrams**
   - System context diagram (C4 Level 1)
   - Container diagram (C4 Level 2)
   - Component diagrams for complex subsystems
   - Sequence diagrams for critical flows

2. **Technical Specification**
   - Component specifications
   - API documentation
   - Data schemas
   - Configuration requirements

3. **Decision Records (ADRs)**
   - Key architectural decisions
   - Alternatives considered
   - Trade-offs and rationale

4. **Implementation Roadmap**
   - Phased delivery plan
   - Dependencies and risks
   - MVP definition
   - Future enhancements
</deliverables>

<quality_attributes>
Evaluate design against:
- Modularity and loose coupling
- Testability
- Deployability
- Monitorability
- Cost efficiency
- Developer experience
</quality_attributes>
</architecture_design_request>
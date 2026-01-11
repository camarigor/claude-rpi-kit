---
name: plan
description: RPI Planning phase - Create executable implementation blueprint from research
arguments:
  - name: feature
    description: Feature to plan (e.g., "add refresh token", "implement rate limiting")
    required: true
  - name: research_file
    description: Path to research file (optional, will auto-detect latest if not provided)
    required: false
---

# EXECUTE IMMEDIATELY - DO NOT SKIP

**STOP. Before reading ANY further instructions, you MUST first read the research artifact, then launch ALL validation subagents IN PARALLEL.**

## STEP 1: Consume Research First

Read the research artifact completely:
- If `$ARGUMENTS.research_file` provided, read that file
- Otherwise, find the latest file in `thoughts/research/`

Extract and note:
- Key findings
- Relevant files with line numbers
- Integration points
- Patterns to follow
- Constraints
- Technology stack involved
- **CRITICAL: Extract the "Specialists Deployed" section** - these agents were recommended by agent-organizer and validated by discovery

---

## STEP 2: LAUNCH TESSL + ALL VALIDATION SUBAGENTS NOW (MANDATORY)

**After reading research, you MUST launch Tessl query AND all validators IN PARALLEL:**

### Tessl Documentation Query (ALWAYS - run in parallel with validators)

**Query Tessl MCP for implementation guidance:**

```
Tool: mcp__tessl__query_library_docs
Query: "I'm planning to implement '$ARGUMENTS.feature'.
        Based on the technology stack (FastAPI, React, MongoDB, Python), provide:
        - Best practices for implementing this type of feature
        - API design patterns and recommendations
        - Security considerations
        - Performance optimization tips
        - Common pitfalls to avoid
        - Code examples if available"
```

**Purpose**: Get curated documentation and best practices to inform the implementation plan. This runs IN PARALLEL with validators to save time.

---

### Validator Selection Strategy

```
Plan Validators = Core Fixed (5) + Inherited from Research (if relevant) + Tessl Docs
```

**From Research Artifact, extract:**
- Which specialists were deployed in Phase 2
- Their focus areas and findings
- Use these same specialists as additional validators
- External documentation from Phase 1b (Tessl)

---

### Core Validators (ALWAYS launch these 5 - non-negotiable)

**Task call 1 - API Design Validation:**
```
subagent_type: "api-designer"
description: "Validate API design"
prompt: "Review the proposed design for '$ARGUMENTS.feature'. Based on the research findings [paste key findings], validate:
- Is the API design consistent with existing patterns?
- Are endpoints RESTful and well-structured?
- Are request/response schemas appropriate?
- OpenAPI/contract compatibility
Return validation result with specific recommendations."
```

**Task call 2 - Security Validation:**
```
subagent_type: "security-auditor"
description: "Security review"
prompt: "Review the proposed design for '$ARGUMENTS.feature'. Based on the research [paste relevant security findings], identify:
- Authentication/authorization gaps
- Input validation concerns
- Data exposure risks
- OWASP Top 10 considerations
- Secrets management
Return security assessment with severity ratings."
```

**Task call 3 - Performance Validation:**
```
subagent_type: "performance-engineer"
description: "Performance review"
prompt: "Review the proposed design for '$ARGUMENTS.feature'. Assess:
- Will this approach scale?
- Database query efficiency
- Caching opportunities
- Potential bottlenecks
- Resource utilization
Return performance assessment with recommendations."
```

**Task call 4 - Architecture Validation:**
```
subagent_type: "architect-reviewer"
description: "Architecture review"
prompt: "Review the proposed design for '$ARGUMENTS.feature'. Validate:
- Does it fit the existing architecture layers?
- Are dependencies correctly structured?
- Does it follow SOLID principles?
- Are there any architectural anti-patterns?
- Scalability and maintainability
Return architecture assessment."
```

**Task call 5 - Testing Strategy Validation:**
```
subagent_type: "qa-expert"
description: "Testing strategy review"
prompt: "Review the proposed design for '$ARGUMENTS.feature'. Define:
- Unit test requirements
- Integration test scenarios
- Edge cases to cover
- Mocking requirements
- Test data needs
Return comprehensive testing strategy."
```

### Inherited Validators (from Research Phase 0/2)

**CRITICAL: Check the research artifact's "Specialists Deployed" table.**

For EACH specialist that was deployed during research AND is relevant for validation:

```
subagent_type: "<agent from research>"
description: "Validate <domain> design"
prompt: "You were deployed during research for '$ARGUMENTS.feature' and found:
<PASTE FINDINGS FROM RESEARCH ARTIFACT>

Now validate the proposed design:
- Are the patterns you identified being followed?
- Are there any concerns with the proposed approach?
- What constraints from your analysis should be enforced?

Return validation result with specific recommendations."
```

**Example - If research deployed these specialists, add them as validators:**

| Research Deployed | Add as Validator? | Validation Focus |
|-------------------|-------------------|------------------|
| python-pro | ✅ Yes | FastAPI patterns, async, types |
| react-specialist | ✅ Yes | Components, hooks, state |
| database-administrator | ✅ Yes | Schema, queries, indexes |
| sre-engineer | ✅ Yes | Observability, SLOs |
| architect-reviewer | ⚠️ Already in Core 5 | Skip (duplicate) |
| Explore (docs) | ❌ No | Not a validator |

---

### Stack-Specific Validators (fallback if no research available)

**Only use these if research artifact doesn't exist or doesn't have specialist recommendations:**

**Task call 6 - Python/FastAPI Validation (if Python involved):**
```
subagent_type: "python-pro"
description: "Python patterns review"
prompt: "Validate the design for '$ARGUMENTS.feature' against Python/FastAPI best practices:
- Async/await patterns
- Pydantic model design
- Dependency injection
- Error handling patterns
- Type hints and validation
Return Python-specific recommendations."
```

**Task call 7 - TypeScript/React Validation (if frontend involved):**
```
subagent_type: "react-specialist"
description: "React/TypeScript review"
prompt: "Validate the design for '$ARGUMENTS.feature':
- Type safety considerations
- Component structure and composition
- State management approach
- Hook usage patterns
- Performance optimizations (memo, useMemo, useCallback)
Return frontend-specific recommendations."
```

**Task call 8 - Database Validation (if data storage involved):**
```
subagent_type: "database-administrator"
description: "Database design review"
prompt: "Validate the data design for '$ARGUMENTS.feature':
- Schema design and normalization
- Index requirements
- Query patterns and optimization
- Data integrity constraints
- Migration strategy
Return database-specific recommendations."
```

**Task call 9 - DevOps/Infrastructure Validation (if infra changes):**
```
subagent_type: "devops-engineer"
description: "Infrastructure review"
prompt: "Validate infrastructure needs for '$ARGUMENTS.feature':
- Deployment considerations
- Environment variables and secrets
- Configuration management
- CI/CD pipeline changes
- Container/Kubernetes considerations
Return infrastructure recommendations."
```

**Task call 10 - Integration Validation (if external services):**
```
subagent_type: "backend-developer"
description: "Integration review"
prompt: "Validate external integrations for '$ARGUMENTS.feature':
- API contract compatibility
- Error handling for external calls
- Retry/circuit breaker needs
- Data transformation requirements
- Timeout and resilience patterns
Return integration recommendations."
```

### Additional Validators (launch if relevant)

**Task call 11 - Observability Validation:**
```
subagent_type: "sre-engineer"
description: "Observability review"
prompt: "Validate observability needs for '$ARGUMENTS.feature':
- Logging requirements (structured logging)
- Metrics to capture
- Distributed tracing needs
- Alerting considerations
- SLO/SLI definitions
Return observability recommendations."
```

**Task call 12 - Documentation Validation:**
```
subagent_type: "technical-writer"
description: "Documentation review"
prompt: "Identify documentation needs for '$ARGUMENTS.feature':
- API documentation updates
- README changes
- Architecture diagram updates
- User-facing documentation
- Code comments and docstrings
Return documentation requirements."
```

### Domain-Specific Validators (launch when applicable)

**Task call 13 - Security Engineering (for auth/crypto features):**
```
subagent_type: "security-engineer"
description: "Security engineering review"
prompt: "Review security implementation for '$ARGUMENTS.feature':
- Cryptographic considerations
- Token/session management
- Zero-trust principles
- Compliance requirements
Return security engineering recommendations."
```

**Task call 14 - Code Quality Review:**
```
subagent_type: "code-reviewer"
description: "Code quality review"
prompt: "Review code quality aspects for '$ARGUMENTS.feature':
- Code maintainability
- Design patterns appropriateness
- Technical debt considerations
- Refactoring opportunities
Return code quality recommendations."
```

**⚠️ LAUNCH AT MINIMUM: Core 5 + Inherited from Research = typically 8-12 validators IN PARALLEL.**

**Validator Count Formula:**
```
Total = 5 (core) + N (inherited from research, excluding duplicates)
```

---

## Available Specialized Agents Reference (127 total)

**01-core-development (10)**
`api-designer`, `backend-developer`, `electron-pro`, `frontend-developer`, `fullstack-developer`, `graphql-architect`, `microservices-architect`, `mobile-developer`, `ui-designer`, `websocket-engineer`

**02-language-specialists (26)**
`angular-architect`, `cpp-pro`, `csharp-developer`, `django-developer`, `dotnet-core-expert`, `dotnet-framework-4.8-expert`, `elixir-expert`, `flutter-expert`, `golang-pro`, `java-architect`, `javascript-pro`, `kotlin-specialist`, `laravel-specialist`, `nextjs-developer`, `php-pro`, `powershell-5.1-expert`, `powershell-7-expert`, `python-pro`, `rails-expert`, `react-specialist`, `rust-engineer`, `spring-boot-engineer`, `sql-pro`, `swift-expert`, `typescript-pro`, `vue-expert`

**03-infrastructure (14)**
`azure-infra-engineer`, `cloud-architect`, `database-administrator`, `deployment-engineer`, `devops-engineer`, `devops-incident-responder`, `incident-responder`, `kubernetes-specialist`, `network-engineer`, `platform-engineer`, `security-engineer`, `sre-engineer`, `terraform-engineer`, `windows-infra-admin`

**04-quality-security (14)**
`accessibility-tester`, `ad-security-reviewer`, `architect-reviewer`, `chaos-engineer`, `code-reviewer`, `compliance-auditor`, `debugger`, `error-detective`, `penetration-tester`, `performance-engineer`, `powershell-security-hardening`, `qa-expert`, `security-auditor`, `test-automator`

**05-data-ai (12)**
`ai-engineer`, `data-analyst`, `database-optimizer`, `data-engineer`, `data-scientist`, `llm-architect`, `machine-learning-engineer`, `ml-engineer`, `mlops-engineer`, `nlp-engineer`, `postgres-pro`, `prompt-engineer`

**06-developer-experience (13)**
`build-engineer`, `cli-developer`, `dependency-manager`, `documentation-engineer`, `dx-optimizer`, `git-workflow-manager`, `legacy-modernizer`, `mcp-developer`, `powershell-module-architect`, `powershell-ui-architect`, `refactoring-specialist`, `slack-expert`, `tooling-engineer`

**07-specialized-domains (12)**
`api-documenter`, `blockchain-developer`, `embedded-systems`, `fintech-engineer`, `game-developer`, `iot-engineer`, `m365-admin`, `mobile-app-developer`, `payment-integration`, `quant-analyst`, `risk-manager`, `seo-specialist`

**08-business-product (11)**
`business-analyst`, `content-marketer`, `customer-success-manager`, `legal-advisor`, `product-manager`, `project-manager`, `sales-engineer`, `scrum-master`, `technical-writer`, `ux-researcher`, `wordpress-master`

**09-meta-orchestration (9)**
`agent-organizer`, `context-manager`, `error-coordinator`, `it-ops-orchestrator`, `knowledge-synthesizer`, `multi-agent-coordinator`, `performance-monitor`, `task-distributor`, `workflow-orchestrator`

**10-research-analysis (6)**
`competitive-analyst`, `data-researcher`, `market-researcher`, `research-analyst`, `search-specialist`, `trend-analyst`

---

## STEP 3: Create BD Issue

```bash
bd create --title="Plan: $ARGUMENTS.feature" --type=task --priority=2
bd update <id> --status=in_progress
```

---

## STEP 4: Synthesize Validations into Plan

Combine ALL validator feedback into a comprehensive plan.

Create file: `thoughts/plans/YYYY-MM-DD-HHmm-$ARGUMENTS.feature.md`

### Plan Template

```markdown
# Plan: $ARGUMENTS.feature

**Date**: YYYY-MM-DD HH:mm
**BD Issue**: <plan-issue-id>
**Research Source**: <research-file-path>
**Status**: Awaiting Approval

## Validators Consulted

| Type | Agent | Source |
|------|-------|--------|
| Core | api-designer | Fixed |
| Core | security-auditor | Fixed |
| Core | performance-engineer | Fixed |
| Core | architect-reviewer | Fixed |
| Core | qa-expert | Fixed |
| Inherited | python-pro | Research Phase 2 |
| Inherited | react-specialist | Research Phase 2 |
| Inherited | database-administrator | Research Phase 2 |
| ... | ... | ... |

## Tessl Documentation Insights

**Libraries/Frameworks Referenced:**
| Library | Best Practice Applied | Impact on Plan |
|---------|----------------------|----------------|
| FastAPI | [pattern from docs] | [how it affects implementation] |
| React | [pattern from docs] | [how it affects implementation] |
| MongoDB | [pattern from docs] | [how it affects implementation] |

**Key Tessl Recommendations:**
- [Best practice 1 and how it will be applied]
- [Security consideration and mitigation]
- [Performance tip and implementation]

**Pitfalls to Avoid:**
- [Common mistake 1] → [Prevention strategy]
- [Common mistake 2] → [Prevention strategy]

## Executive Summary
[2-3 sentences describing what will be implemented]

## Validation Results

| Validator | Agent Type | Source | Status | Key Findings |
|-----------|------------|--------|--------|--------------|
| API Designer | api-designer | Core | ✅ Approved | [summary] |
| Security Auditor | security-auditor | Core | ⚠️ Concerns | [summary] |
| Performance Engineer | performance-engineer | Core | ✅ Approved | [summary] |
| Architect | architect-reviewer | Core | ✅ Approved | [summary] |
| QA Expert | qa-expert | Core | ✅ Approved | [summary] |
| Python Expert | python-pro | Inherited | ✅ Approved | [summary] |
| React Specialist | react-specialist | Inherited | ✅ Approved | [summary] |
| Database Admin | database-administrator | Inherited | ✅ Approved | [summary] |
| ... | ... | ... | ... | ... |

## Design Decisions

| Decision | Justification | Validated By |
|----------|---------------|--------------|
| Use pattern X | Because Y | architect-reviewer, python-pro |
| Store in Z | Because W | database-administrator, security-auditor |
| ... | ... | ... |

## Implementation Phases

### Phase 1: <Phase Name>
**BD Issue**: <to-be-created>
**Depends On**: None
**Estimated Complexity**: Low/Medium/High

**Files to modify**:
- `path/to/file.py:L10-L50` - Add new function

**Changes**:
\`\`\`python
# Add after line 50
def new_function():
    pass
\`\`\`

**Verification**:
\`\`\`bash
pytest tests/test_file.py -v
\`\`\`

**Success Criteria**:
- [ ] Function exists and handles edge cases
- [ ] Tests pass with 100% coverage
- [ ] No security alerts

**Delegate To**: python-pro, backend-developer

---

### Phase 2: <Phase Name>
**BD Issue**: <to-be-created>
**Depends On**: Phase 1
**Estimated Complexity**: Medium

[Continue pattern...]

---

## Testing Strategy
[From qa-expert validator]

| Phase | Test Type | Scenarios | Command |
|-------|-----------|-----------|---------|
| 1 | Unit | [list] | `pytest tests/test_x.py` |
| 2 | Integration | [list] | `pytest tests/test_int.py` |
| All | E2E | [list] | `npm run test:e2e` |

## Security Checklist
[From security-auditor validator]

- [ ] Input validation on all endpoints
- [ ] Authentication required
- [ ] Authorization checks
- [ ] No sensitive data exposure
- [ ] Rate limiting considered

## Performance Considerations
[From performance-engineer validator]

- [ ] Database queries optimized
- [ ] Caching strategy defined
- [ ] No N+1 queries
- [ ] Async operations where appropriate

## Rollback Plan
If Phase N fails:
1. Revert changes: `git revert <commit>`
2. Create bug issue with discovered-from
3. Re-plan affected phases

## Quality Gates (Post-Implementation)
- [ ] Coverage >= 100%
- [ ] Performance benchmarks met
- [ ] Security scan passes

---
**FACTS Validation**:
- [x] Feasible: Validated by 8+ specialists
- [x] Atomic: Each phase is a logical unit
- [x] Clear: No ambiguity in any phase
- [x] Testable: Each phase has verification
- [x] Scoped: No scope creep
```

---

## STEP 5: Create BD Issues for Phases

After creating the plan, create implementation issues:

```bash
bd create --title="Impl: Phase 1 - <description>" --type=task --priority=2
# Returns: bd-201

bd create --title="Impl: Phase 2 - <description>" --type=task --priority=2
# Returns: bd-202

# Set dependencies
bd dep add bd-202 bd-201  # Phase 2 depends on Phase 1
```

Update the plan.md with the actual BD issue IDs.

---

## STEP 6: Human Approval Gate

**STOP AND WAIT FOR APPROVAL**

Present to user:
```
Plan complete: thoughts/plans/<filename>.md

Summary:
- X phases identified
- Y specialized validators consulted
- BD issues created: bd-201, bd-202, ...
- Dependencies configured

Validation Summary:
- api-designer: ✅
- security-auditor: ⚠️ (addressed in Phase 2)
- performance-engineer: ✅
- architect-reviewer: ✅
- qa-expert: ✅
[... all validators with their agent types]

Please review the plan and confirm:
1. Design decisions are acceptable
2. Phase breakdown is appropriate
3. Security concerns addressed
4. Ready for implementation

Awaiting your approval to proceed.
```

---

## STEP 7: Completion

Only after user approves:

```bash
bd close <plan-id> --reason="Plan approved, ready for /implement"
```

---

## Rules

**MUST:**
- ✅ Read research artifact FIRST
- ✅ Extract "Specialists Deployed" from research for inherited validators
- ✅ Query Tessl MCP for implementation best practices (parallel with validators)
- ✅ Launch Core 5 validators (api-designer, security-auditor, performance-engineer, architect-reviewer, qa-expert)
- ✅ Launch inherited validators from research (excluding duplicates)
- ✅ Use correct specialized agent types (NOT general-purpose)
- ✅ Wait for ALL validator results AND Tessl response
- ✅ Include ALL validator feedback in plan
- ✅ Include Tessl documentation insights in plan
- ✅ Create phases with clear success criteria
- ✅ Define specialist agent to delegate for each phase
- ✅ Wait for human approval

**MUST NOT:**
- ❌ Skip Tessl documentation query
- ❌ Launch fewer than Core 5 validators
- ❌ Ignore specialists recommended by research
- ❌ Use "general-purpose" when specialized agent exists
- ❌ Create plan without validation
- ❌ Skip any validator results
- ❌ Execute any code
- ❌ Close plan issue before approval
- ❌ Create phases without verification steps

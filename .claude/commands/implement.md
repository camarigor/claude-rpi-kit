---
name: implement
description: RPI Implementation phase - Execute approved plan phase by phase, delegating to specialist agents
arguments:
  - name: plan_file
    description: Path to approved plan file (optional, will auto-detect latest if not provided)
    required: false
---

# EXECUTE IMMEDIATELY - DO NOT SKIP

**STOP. For EACH phase, you MUST launch MULTIPLE specialist subagents IN PARALLEL to implement, test, and review.**

## Pre-Flight Check

1. Verify plan exists and was approved
2. Read plan completely
3. Check `bd ready` for available phases

```bash
bd ready
```

---

## Available Specialist Subagents (127 total)

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

## PHASE EXECUTION LOOP - MANDATORY MULTI-AGENT APPROACH

**For EACH phase in the plan, you MUST launch 4-6 subagents IN PARALLEL:**

### Step 1: Claim Phase
```bash
bd update <phase-id> --status=in_progress
```

### Step 2: LAUNCH IMPLEMENTATION SUBAGENTS IN PARALLEL (MANDATORY)

**You MUST call Task tool 4-6 times IN PARALLEL for each phase:**

**Task call 1 - Primary Implementation:**
```
subagent_type: "[select from: python-pro, typescript-pro, react-specialist, backend-developer, fullstack-developer]"
description: "Implement Phase N code"
prompt: "Implement Phase [N] exactly as specified:

CONTEXT FROM PLAN:
- Feature: [feature name]
- Phase objective: [from plan]

FILES TO MODIFY:
[Paste exact file paths and line numbers from plan]

CHANGES TO MAKE:
[Paste exact code changes from plan]

EXISTING PATTERNS TO FOLLOW:
[Paste patterns identified in research]

CONSTRAINTS:
- Follow existing code style
- Do NOT deviate from plan
- Include type hints (Python) / types (TypeScript)

Return the implementation with file paths."
```

**Task call 2 - Test Implementation:**
```
subagent_type: "test-automator"
description: "Write tests for Phase N"
prompt: "Write comprehensive tests for Phase [N]:

WHAT WAS IMPLEMENTED:
[Summary of implementation]

TEST REQUIREMENTS FROM PLAN:
[Paste testing strategy from plan]

COVERAGE TARGET: 100%

Write:
1. Unit tests for all new functions
2. Edge case tests
3. Error handling tests
4. Integration tests if needed

Return test files with file paths."
```

**Task call 3 - Code Review:**
```
subagent_type: "code-reviewer"
description: "Review Phase N code"
prompt: "Review the implementation of Phase [N]:

CODE IMPLEMENTED:
[Summary of changes]

CHECK FOR:
- Code quality and readability
- SOLID principles
- Error handling
- Security issues
- Performance concerns
- Missing edge cases

Return review findings with specific line references."
```

**Task call 4 - Security Review:**
```
subagent_type: "security-auditor"
description: "Security review Phase N"
prompt: "Review Phase [N] implementation for security issues:

CODE CHANGES:
[Summary of changes]

CHECK FOR:
- Input validation
- Authentication/authorization
- Data exposure
- Injection vulnerabilities
- OWASP Top 10

Return security findings with severity ratings."
```

**Task call 5 - Documentation Update (if needed):**
```
subagent_type: "technical-writer"
description: "Update docs for Phase N"
prompt: "Update documentation for Phase [N]:

CHANGES MADE:
[Summary of changes]

UPDATE:
- Docstrings/JSDoc
- README if API changed
- Type definitions
- Inline comments for complex logic

Return documentation updates."
```

**Task call 6 - Performance Check (if performance-critical):**
```
subagent_type: "performance-engineer"
description: "Performance review Phase N"
prompt: "Review Phase [N] for performance:

CODE CHANGES:
[Summary]

CHECK FOR:
- Database query efficiency
- Algorithm complexity
- Memory usage
- Async patterns
- Caching opportunities

Return performance assessment."
```

### Step 3: Apply All Changes

After all subagents complete:
1. Review all implementation results
2. Apply code changes
3. Apply test files
4. Address any review findings
5. Apply documentation updates

### Step 4: Run Verification
```bash
# Run the verification command from the plan
pytest tests/test_x.py -v --cov=src --cov-report=term-missing

# Or for frontend
npm run test:coverage
```

### Step 5: Quality Check Before Closing

**MANDATORY - Launch quality check subagent:**

**Task call - Final Quality Check:**
```
subagent_type: "qa-expert"
description: "Final quality check Phase N"
prompt: "Verify Phase [N] is complete:

IMPLEMENTATION: [summary]
TESTS: [summary]
REVIEWS: [findings addressed?]

VERIFY:
- All success criteria from plan met
- Tests passing
- Coverage >= 100%
- No unresolved review findings
- Documentation updated

Return pass/fail with details."
```

### Step 6: Close or Fix

**If ALL CHECKS PASSED:**
- Mark `[x]` in plan.md
- `bd close <phase-id> --reason="Phase complete - all quality checks passed"`

**If ANY CHECK FAILED:**
```bash
bd create --title="Bug: <error>" --type=bug --priority=1
```
Then launch fix subagents:
```
subagent_type: "[relevant specialist: python-pro, typescript-pro, etc.]"
description: "Fix Phase N issue"
prompt: "Fix this issue in Phase [N]:

ERROR: [error message or review finding]
FILE: [file path]
EXPECTED: [expected behavior]

Fix the issue and return the corrected code."
```

---

## Available Specialized Agents Reference

| Domain | Agent | Use When |
|--------|-------|----------|
| Python | `python-pro` | Python/FastAPI implementation |
| TypeScript | `typescript-pro` | TypeScript code |
| React | `react-specialist` | React components |
| Frontend | `frontend-developer` | General frontend |
| Backend | `backend-developer` | General backend |
| Full Stack | `fullstack-developer` | End-to-end features |
| Testing | `test-automator` | Test implementation |
| QA | `qa-expert` | Quality verification |
| Code Review | `code-reviewer` | Code quality review |
| Security Audit | `security-auditor` | Security review |
| Security Impl | `security-engineer` | Security implementation |
| Performance | `performance-engineer` | Performance optimization |
| Database | `database-administrator` | DB implementation |
| DevOps | `devops-engineer` | CI/CD, deployment |
| SRE | `sre-engineer` | Observability |
| Documentation | `technical-writer` | Docs updates |
| API Design | `api-designer` | API implementation |

---

## QUALITY GATES (After ALL Phases Complete)

**MANDATORY - Launch quality gate subagents IN PARALLEL:**

### Launch Quality Gate Subagents

**Task call 1 - Coverage Analysis:**
```
subagent_type: "qa-expert"
description: "Verify test coverage"
prompt: "Verify test coverage:

Run coverage report for all changed files.

TARGET: 100% on Stmts, Branch, Funcs, Lines

Identify any uncovered lines and suggest tests."
```

**Task call 3 - Security Scan:**
```
subagent_type: "security-engineer"
description: "Run security scan"
prompt: "Run security scans:

1. SAST analysis
2. Secrets detection

Return security scan results."
```

**Task call 4 - Integration Test:**
```
subagent_type: "test-automator"
description: "Run integration tests"
prompt: "Run integration tests:

Run all integration tests for affected components.

Return test results with any failures."
```

**Task call 5 - Documentation Review:**
```
subagent_type: "technical-writer"
description: "Review documentation"
prompt: "Verify documentation is complete:

CHECK:
- All new APIs documented
- README updated if needed
- CHANGELOG entry added
- Type definitions current

Return documentation status."
```

### Quality Gate Results

Wait for ALL quality gate subagents to complete, then create summary:

| Gate | Status | Details |
|------|--------|---------|
| Coverage | ✅/❌ | [percentage] |
| Security | ✅/❌ | [vulnerabilities] |
| Integration | ✅/❌ | [test results] |
| Documentation | ✅/❌ | [status] |

If ANY gate fails, create issues and fix:
```bash
bd create --title="QualityGate: <gate> failed - <reason>" --type=bug --priority=1
```

---

## SESSION COMPLETION

After all phases and quality gates pass:

```bash
bd sync
```

Provide summary:

```markdown
## Implementation Session Summary

**Date**: YYYY-MM-DD
**Plan**: thoughts/plans/<filename>.md

### Subagents Used Per Phase

| Phase | Implementation | Tests | Review | Security | Total |
|-------|----------------|-------|--------|----------|-------|
| 1 | python-pro | test-automator | code-reviewer | security-auditor | 4 |
| 2 | react-specialist | test-automator | code-reviewer | security-auditor | 4 |
| ... | ... | ... | ... | ... | ... |

### Phases Completed
- [x] Phase 1: <description> (bd-201) - 4 subagents
- [x] Phase 2: <description> (bd-202) - 5 subagents
- [x] Phase 3: <description> (bd-203) - 4 subagents

### Bugs Discovered and Fixed
- bd-210: <description> (discovered-from: bd-202)

### Quality Gates
| Gate | Status | Notes |
|------|--------|-------|
| Coverage | ✅ 100% | All lines covered |
| Security | ✅ Clean | No CVEs |
| Integration | ✅ Passed | All tests green |
| Documentation | ✅ Complete | README updated |

### Files Changed
- src/auth/token.py (new)
- src/auth/middleware.py (modified)
- tests/test_token.py (new)

### Total Subagents Launched
- Implementation: X
- Tests: X
- Review: X
- Security: X
- Quality Gates: X
- **Total: XX subagents**

### BD Sync
All changes committed and synced.
```

---

## Rules

**MUST:**
- ✅ Read plan completely before starting
- ✅ Launch **4-6 specialized subagents IN PARALLEL per phase**
- ✅ Use correct specialized agent types (NOT general-purpose)
- ✅ Always include: Implementation + Tests + Code Review + Security Review
- ✅ Wait for ALL subagent results before proceeding
- ✅ Address ALL review findings
- ✅ Run verification after each phase
- ✅ Launch **5 quality gate subagents** after all phases
- ✅ Create discovered-from issues for bugs
- ✅ `bd sync` at session end

**MUST NOT:**
- ❌ Launch only 1 subagent per phase
- ❌ Use "general-purpose" when specialized agent exists
- ❌ Skip test implementation subagent
- ❌ Skip code review subagent
- ❌ Skip security review subagent
- ❌ Proceed with unresolved review findings
- ❌ Skip quality gates
- ❌ Code directly instead of delegating

---

## The Implementer's Mantra

> "Every phase gets a team of specialists, not a single generic agent. Implementation, Testing, Review, Security - all specialists working in parallel."

You orchestrate specialist teams. Experts execute in parallel. Quality gates validate.

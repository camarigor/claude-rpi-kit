---
name: research
description: RPI Research phase - Explore and document codebase state without opinions or suggestions
arguments:
  - name: topic
    description: What to research (e.g., "auth system", "payment flow", "database schema")
    required: true
---

# Four-Phase Dynamic Research

This skill uses a 4-phase approach with intelligent agent selection from 127 specialists.

```
Phase 0:  agent-organizer → Analyzes topic, recommends best agents from 127
Phase 1a: Explore         → Discovers all files related to topic
Phase 1b: Tessl Docs      → Queries external library documentation (parallel with 1a)
Phase 2:  Specialists     → Only recommended + validated agents launched
```

---

## PHASE 0: Agent Selection (EXECUTE FIRST)

**STOP. Launch agent-organizer to select the best agents for this topic:**

```
subagent_type: "agent-organizer"
description: "Select best agents for topic"
prompt: "Analyze the research topic '$ARGUMENTS.topic' and select the BEST specialist agents from the 130 available.

## Available Agents by Category (130 total)

### 00-rpi-core (3)
researcher, planner, implementer

### 01-core-development (10)
api-designer, backend-developer, electron-pro, frontend-developer, fullstack-developer, graphql-architect, microservices-architect, mobile-developer, ui-designer, websocket-engineer

### 02-language-specialists (26)
angular-architect, cpp-pro, csharp-developer, django-developer, dotnet-core-expert, dotnet-framework-4.8-expert, elixir-expert, flutter-expert, golang-pro, java-architect, javascript-pro, kotlin-specialist, laravel-specialist, nextjs-developer, php-pro, powershell-5.1-expert, powershell-7-expert, python-pro, rails-expert, react-specialist, rust-engineer, spring-boot-engineer, sql-pro, swift-expert, typescript-pro, vue-expert

### 03-infrastructure (14)
azure-infra-engineer, cloud-architect, database-administrator, deployment-engineer, devops-engineer, devops-incident-responder, incident-responder, kubernetes-specialist, network-engineer, platform-engineer, security-engineer, sre-engineer, terraform-engineer, windows-infra-admin

### 04-quality-security (14)
accessibility-tester, ad-security-reviewer, architect-reviewer, chaos-engineer, code-reviewer, compliance-auditor, debugger, error-detective, penetration-tester, performance-engineer, powershell-security-hardening, qa-expert, security-auditor, test-automator

### 05-data-ai (12)
ai-engineer, data-analyst, database-optimizer, data-engineer, data-scientist, llm-architect, machine-learning-engineer, ml-engineer, mlops-engineer, nlp-engineer, postgres-pro, prompt-engineer

### 06-developer-experience (13)
build-engineer, cli-developer, dependency-manager, documentation-engineer, dx-optimizer, git-workflow-manager, legacy-modernizer, mcp-developer, powershell-module-architect, powershell-ui-architect, refactoring-specialist, slack-expert, tooling-engineer

### 07-specialized-domains (12)
api-documenter, blockchain-developer, embedded-systems, fintech-engineer, game-developer, iot-engineer, m365-admin, mobile-app-developer, payment-integration, quant-analyst, risk-manager, seo-specialist

### 08-business-product (11)
business-analyst, content-marketer, customer-success-manager, legal-advisor, product-manager, project-manager, sales-engineer, scrum-master, technical-writer, ux-researcher, wordpress-master

### 09-meta-orchestration (9)
agent-organizer, context-manager, error-coordinator, it-ops-orchestrator, knowledge-synthesizer, multi-agent-coordinator, performance-monitor, task-distributor, workflow-orchestrator

### 10-research-analysis (6)
competitive-analyst, data-researcher, market-researcher, research-analyst, search-specialist, trend-analyst

---

## Your Task

1. **Analyze the topic**: What domain does '$ARGUMENTS.topic' belong to?
2. **Identify relevant categories**: Which of the 11 categories are most relevant?
3. **Select specific agents**: Choose 6-10 BEST agents for this topic
4. **Justify each selection**: Why is this agent better than alternatives?

## Output Format

Return a JSON structure:
{
  \"topic_analysis\": {
    \"domain\": \"<primary domain>\",
    \"subdomain\": \"<specific area>\",
    \"keywords\": [\"keyword1\", \"keyword2\", ...]
  },
  \"relevant_categories\": [
    {\"category\": \"<category-name>\", \"relevance\": \"high|medium|low\", \"reason\": \"<why>\"}
  ],
  \"recommended_agents\": [
    {
      \"agent\": \"<agent-name>\",
      \"category\": \"<category>\",
      \"priority\": 1-10,
      \"reason\": \"<specific reason why this agent is best for this topic>\",
      \"what_to_analyze\": \"<what this agent should focus on>\"
    }
  ],
  \"agents_considered_but_rejected\": [
    {\"agent\": \"<name>\", \"reason\": \"<why not selected>\"}
  ]
}

Be specific. Don't just pick common agents - analyze the topic deeply and select specialists that truly match."
```

**⚠️ WAIT for agent-organizer to complete before proceeding to Phase 1.**

---

## PHASE 1a + 1b: Discovery (AFTER Phase 0) - RUN IN PARALLEL

Launch BOTH Explore AND Tessl docs query IN PARALLEL:

### Phase 1a: Codebase Discovery

```
subagent_type: "Explore"
description: "Discover all files for topic"
prompt: "Comprehensively search the entire codebase for EVERYTHING related to '$ARGUMENTS.topic'.

Search in ALL these locations:
- repos/apis/**           (Python/FastAPI backends)
- repos/connectors/**     (Workers and event processors)
- repos/frontends/**      (React/TypeScript frontend)
- repos/libraries/**      (Python shared libraries)
- repos/pipelines/**      (CI/CD templates)
- repos/tools/**          (Utility tools)
- history/**              (Documentation)

Use Grep and Glob extensively. Search for:
- Direct references to the topic
- Related terms and synonyms
- Configuration files
- Test files
- Documentation files

RETURN A STRUCTURED REPORT:
1. **Files by Layer** - List all files organized by:
   - Python/FastAPI code (repos/apis/, repos/libraries/)
   - React/TypeScript code (repos/frontends/)
   - Worker/Connector code (repos/connectors/)
   - Pipeline/CI-CD code (repos/pipelines/)
   - Database/Models
   - Configuration
   - Tests
   - Documentation

2. **File Count Summary**:
   - python_files: <count>
   - typescript_files: <count>
   - react_components: <count>
   - worker_files: <count>
   - pipeline_files: <count>
   - database_files: <count>
   - test_files: <count>
   - doc_files: <count>

3. **Repositories Involved**: List which repos/ subdirectories have relevant code

4. **Technology Stack Detected**: What languages/frameworks are actually used

This discovery will validate which recommended agents to actually launch."
```

### Phase 1b: External Documentation (Tessl)

**Run IN PARALLEL with Phase 1a using the Tessl MCP tool:**

```
Tool: mcp__tessl__query_library_docs
Query: "Based on the topic '$ARGUMENTS.topic', what libraries, frameworks, or patterns are relevant?
        Include documentation for: authentication, authorization, FastAPI, React, MongoDB,
        and any other technologies that might be related to this topic."
```

**Purpose**: Get curated, up-to-date documentation about libraries and frameworks used in the project that relate to the research topic. This complements the codebase discovery with external best practices and API references.

**What to extract from Tessl response:**
- Library documentation relevant to the topic
- Best practices and patterns
- API references
- Common pitfalls and recommendations

**⚠️ WAIT for BOTH Phase 1a AND Phase 1b to complete before proceeding to Phase 2.**

---

## PHASE 2: Specialist Analysis (AFTER Phase 0 + Phase 1a + Phase 1b)

### Combine Phase 0 + Phase 1a + Phase 1b Results

1. **From Phase 0**: Get the list of recommended agents with priorities
2. **From Phase 1a**: Get the actual files discovered
3. **From Phase 1b**: Get external documentation insights from Tessl

### Validation Rules

| Phase 0 Recommended | Phase 1 Found | Action |
|---------------------|---------------|--------|
| python-pro | Python files exist | ✅ Launch |
| python-pro | No Python files | ❌ Skip |
| react-specialist | React files exist | ✅ Launch |
| data-analyst | Metrics/KPI code | ✅ Launch |
| devops-engineer | Pipeline files | ✅ Launch |

### Launch Pattern

For EACH validated agent from Phase 0, launch with specific context:

```
subagent_type: "<agent from Phase 0 recommendation>"
description: "<what_to_analyze from Phase 0>"
prompt: "Based on discovery, these files are relevant to '$ARGUMENTS.topic':
<LIST THE SPECIFIC FILES FROM PHASE 1>

You were selected because: <reason from Phase 0>

Focus your analysis on:
- <what_to_analyze from Phase 0>
- Patterns and conventions used
- Integration points with other components
- Potential issues or gaps

Return detailed analysis with file:line references."
```

### Required Agents (Always Launch)

Even if not in Phase 0 recommendations:
1. **Explore** - Read LLM_CONTEXT.md documentation files
2. **architect-reviewer** - Map component relationships (unless already recommended)

---

## STEP 3: Create BD Issue

After launching Phase 2 agents:

```bash
bd create --title="Research: $ARGUMENTS.topic" --type=task --priority=2
bd update <id> --status=in_progress
```

---

## STEP 4: Synthesize Results

Combine results from ALL agents into a comprehensive research artifact.

Create file: `thoughts/research/YYYY-MM-DD-HHmm-$ARGUMENTS.topic.md`

Use this template:

```markdown
# Research: $ARGUMENTS.topic

**Date**: YYYY-MM-DD HH:mm
**BD Issue**: <issue-id>
**Status**: Complete

## Agent Selection Summary (Phase 0)

**Topic Analysis**:
- Domain: <from agent-organizer>
- Keywords: <from agent-organizer>

**Agents Recommended by agent-organizer**:
| Agent | Category | Priority | Reason |
|-------|----------|----------|--------|
| ... | ... | ... | ... |

**Agents Considered but Rejected**:
| Agent | Reason |
|-------|--------|
| ... | ... |

## Discovery Summary (Phase 1a - Codebase)

| Layer | Files Found | Repositories |
|-------|-------------|--------------|
| Python/FastAPI | X files | repos/apis/..., repos/libraries/... |
| React/TypeScript | X files | repos/frontends/devops-portal/... |
| Workers | X files | repos/connectors/... |
| Pipelines | X files | repos/pipelines/... |
| Database | X files | ... |
| Documentation | X files | history/..., repos/.../history/... |

## External Documentation (Phase 1b - Tessl)

**Libraries/Frameworks Documented:**
| Library | Version | Relevance to Topic |
|---------|---------|-------------------|
| ... | ... | ... |

**Key Documentation Insights:**
- [Best practices found]
- [Recommended API patterns]
- [Common pitfalls to avoid]

## Specialists Deployed (Phase 2)

| Agent | Recommended By | Validated by Discovery | Files Analyzed |
|-------|----------------|------------------------|----------------|
| python-pro | agent-organizer (P1) | 5 Python files found | 5 files |
| data-analyst | agent-organizer (P2) | Metrics code found | 3 files |
| ... | ... | ... | ... |

**Agents Skipped (recommended but not validated)**:
| Agent | Reason |
|-------|--------|
| react-specialist | No React files found |
| ... | ... |

---

## Executive Summary
[2-3 sentences synthesizing all findings]

---

## Architecture Overview
[From architect-reviewer agent]

### Component Diagram
[High-level relationships between components]

### Layer Structure
[How layers interact]

---

## Code Analysis

### Python Code
[From python-pro agent - if deployed]

| File | Purpose | Key Functions |
|------|---------|---------------|
| path:L10-50 | ... | func1(), func2() |

**Patterns Found:**
- FastAPI patterns: ...
- Decorators: ...
- Async patterns: ...

### TypeScript/React Code
[From react-specialist agent - if deployed]

| Component | Props | State |
|-----------|-------|-------|
| ... | ... | ... |

### Data/Metrics Analysis
[From data-analyst or data-engineer agent - if deployed]

| Metric/Data Point | Source | Processing |
|-------------------|--------|------------|
| ... | ... | ... |

---

## API Contracts
[From api-designer agent - if deployed]

| Endpoint | Method | Auth | Request | Response |
|----------|--------|------|---------|----------|
| /api/... | POST | JWT | {...} | {...} |

---

## Data Flow
[From data-engineer agent - if deployed]

```
Entry Point → Processing → Storage → Output
```

### Models/Schemas
[Pydantic models, TypeScript interfaces, MongoDB schemas]

---

## Database Analysis
[From database-administrator agent - if deployed]

| Collection | Purpose | Indexes |
|------------|---------|---------|
| ... | ... | ... |

---

## DevOps/Pipeline Analysis
[From devops-engineer or sre-engineer agent - if deployed]

| Pipeline | Purpose | Stages |
|----------|---------|--------|
| ... | ... | ... |

---

## Integrations
[From backend-developer agent - if deployed]

| External Service | Integration Type | Files |
|------------------|------------------|-------|
| LDAP | REST API | ... |
| ServiceNow | REST API | ... |

---

## Security Considerations
[From security-auditor agent - if deployed]

- Authentication: ...
- Authorization: ...
- Input validation: ...
- Sensitive data: ...

---

## Patterns Identified
[Consolidated from all agents]

1. **Pattern Name**: Description (file:line references)
2. ...

## Open Questions
[Questions for the planner to resolve]

1. ...
2. ...

---
**Validation**:
- [x] Phase 0: agent-organizer intelligently selected specialists
- [x] Phase 1a: Codebase discovery validated recommendations
- [x] Phase 1b: Tessl documentation enriched context
- [x] Phase 2: Only validated specialists were launched
- [x] Factual: Based on real code
- [x] Actionable: Comprehensive data for planning
```

---

## STEP 5: Close Issue

```bash
bd close <id> --reason="Research complete: thoughts/research/<filename>.md"
```

---

## STEP 6: Report to User

Tell the user:
- Research artifact location
- Agent selection summary (what agent-organizer recommended and why)
- Discovery summary (what was found)
- Which specialists were deployed and why
- Which specialists were skipped and why
- Suggest running `/plan` next

---

## Repository Reference (for discovery)

```
repos/
├── apis/                           # FastAPI Python APIs
│   ├── api-management-platform/    # BFF Gateway
│   ├── plat-devsecops-api-infrastructure/
│   ├── plat-devsecops-api-ldap/
│   ├── plat-devsecops-api-pipeline/
│   ├── plat-devsecops-api-release-management/
│   └── plat-devsecops-api-webhook/
├── connectors/                     # Workers
│   ├── connector-notification/
│   ├── plat-devsecops-conn-ai-service/
│   ├── plat-devsecops-conn-infrastructure/
│   └── worker-core/
├── frontends/
│   └── devops-portal/              # React/TypeScript
├── libraries/                      # Python shared libs
│   ├── py-rnn-businessmap/
│   ├── py-rnn-common-api/
│   ├── py-rnn-git/
│   ├── py-rnn-mongodb/
│   ├── py-rnn-servicenow/
│   ├── py-rnn-shared-utils/
│   ├── py-rnn-structured-logger/
│   └── rnn-py-notification/
├── pipelines/
│   └── pipelines-templates/
└── tools/
    └── mongo-migration/
```

Each repo has `history/LLM_CONTEXT.md` with documentation.

---

## Rules

**MUST:**
- ✅ Execute Phase 0 (agent-organizer) FIRST
- ✅ Wait for Phase 0 before Phase 1a/1b
- ✅ Execute Phase 1a (Explore) AND Phase 1b (Tessl) IN PARALLEL
- ✅ Wait for BOTH Phase 1a AND Phase 1b before Phase 2
- ✅ Query Tessl for external documentation related to topic
- ✅ Validate Phase 0 recommendations against Phase 1a discovery
- ✅ Only launch agents that are BOTH recommended AND validated
- ✅ Always include architect-reviewer and documentation Explore
- ✅ Launch Phase 2 agents IN PARALLEL
- ✅ Create bd issue
- ✅ Synthesize results into comprehensive artifact (including Tessl docs)
- ✅ Document agent selection rationale from Phase 0
- ✅ Document which agents were deployed AND which were skipped
- ✅ Document facts only with file:line references

**MUST NOT:**
- ❌ Skip Phase 0 (agent-organizer selection)
- ❌ Skip Phase 1b (Tessl documentation query)
- ❌ Launch agents not recommended by Phase 0 (except required ones)
- ❌ Launch agents not validated by Phase 1a discovery
- ❌ Use "general-purpose" when specialized agent exists
- ❌ Do research yourself instead of using subagents
- ❌ Give opinions or suggestions
- ❌ Write any code
- ❌ Proceed to next phase without waiting for current phase

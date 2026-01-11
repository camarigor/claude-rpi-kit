# AGENTS.md

## Issue Tracking with bd (beads)

**IMPORTANT**: This project uses **bd (beads)** for ALL issue tracking. DO NOT use markdown TODOs, task lists, or other tracking methods.

---

## ⚠️ MANDATORY RULE: ALL WORK MUST BE TRACKED IN BD

**THIS RULE IS NON-NEGOTIABLE AND MUST NEVER BE FORGOTTEN:**

For **EVERY** problem reported by the user, **ANY** fix, **ANY** feature, or **ANY** code change:

1. **MUST create a bd issue FIRST** - Before writing any code
2. **MUST set the issue to in_progress** - Before starting work
3. **MUST close the issue when done** - After completing the work
4. **MUST close issues ONLY AFTER the task is finished** - NEVER close before task completion
5. **MUST move to the next issue** - Until ALL open issues in the session are finished

**There is NO option to skip bd registration. It is MANDATORY.**

```bash
# The workflow for ANY work:
bd create --title="Work description" --type=task|bug|feature --priority=2
bd update <id> --status=in_progress
# ... do the work ...
bd close <id>
# ... move to the next issue ...
```

**Examples of work that MUST be tracked:**

- User reports a bug → Create bd issue before fixing
- User requests a feature → Create bd issue before implementing
- User points out a problem → Create bd issue before solving
- Code changes needed → Create bd issue before modifying
- Refactoring required → Create bd issue before refactoring
- Documentation updates → Create bd issue before writing

**NEVER start coding without a bd issue. NEVER.**

---

Every time you compact the session you need to read AGENTS.md

### Why bd?

- Dependency-aware: Tracks blockers and relationships between issues
- Git-friendly: Auto-syncs to JSONL for version control
- Agent-optimized: JSON output, ready-work detection, discovered-from links
- Prevents duplicate tracking systems and confusion

### Quick Start

**Check ready work:**

```bash
bd ready --json
```

**Create new issues:**

```bash
bd create "Issue title" -t bug|feature|task -p 0-4 --json
bd create "Issue title" -p 1 --deps discovered-from:bd-123 --json
bd create "Subtask" --parent <epic-id> --json  # Hierarchical subtask (receives ID as epic-id.1)
```

**Claim and update:**

```bash
bd update bd-42 --status in_progress --json
bd update bd-42 --priority 1 --json
```

**Complete work:**

```bash
bd close bd-42 --reason "Completed" --json
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (main features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `bd ready` shows unblocked issues
2. **Claim your task**: `bd update <id> --status in_progress`
3. **Work on it**: Implement, test, document
4. **Discovered new work?** Create linked issue:
   - `bd create "Bug found" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done"`

---

## RPI Workflow (Research-Plan-Implement)

For complex features, use the RPI workflow with specialized AI agents.

### Commands

| Command | When to Use | Subagents |
|---------|-------------|-----------|
| `/research <topic>` | Understand existing code before changes | 6-8 (2 phases) |
| `/plan <feature>` | Design implementation with validation | 8-12 validators |
| `/implement [plan]` | Execute approved plan | 4-6 per phase |

### Flow

```
/research → /plan → /implement
    ↓          ↓         ↓
  Facts    Blueprint   Executed
  Only     Validated   + Tested
```

### /research - Four-Phase Dynamic Agent Selection

**Phase 0**: agent-organizer analyzes the topic, recommends 6-10 best agents from 130
**Phase 1a**: Explore agent discovers ALL related files in the codebase
**Phase 1b**: Tessl MCP queries external library documentation (parallel with 1a)
**Phase 2**: Launches only agents that are BOTH recommended AND validated by discovery

```
Example: /research DORA Metrics
→ Phase 0: agent-organizer recommended python-pro, react-specialist, database-administrator, sre-engineer
→ Phase 1a: Found 21 files (Python, React, MongoDB)
→ Phase 1b: Tessl returned FastAPI, React, MongoDB documentation
→ Phase 2: 5 validated agents, launched in parallel
→ Output: thoughts/research/2026-01-10-0220-dora-metrics.md
```

**Rules**:
- ✅ agent-organizer intelligently selects specialists from 130 agents
- ✅ Explore + Tessl run in parallel for discovery
- ✅ Discovery validates recommendations before launching
- ✅ Launches only agents for code that actually exists
- ❌ Never use pattern matching to select agents
- ❌ Never launch agents not recommended by agent-organizer

### /plan - Validation-First Planning (Hybrid + Tessl)

Uses **Fixed Core Validators + Inherited from Research + Tessl Documentation**:

**Tessl MCP Query (always - parallel with validators):**
- Queries `mcp__tessl__query_library_docs` for implementation best practices
- Gets library documentation, patterns, security tips, pitfalls to avoid

**Fixed Core (always launched):**
| Validator | Checks |
|-----------|--------|
| api-designer | REST patterns, schemas |
| security-auditor | Auth, input validation, OWASP |
| performance-engineer | Scale, queries, cache |
| architect-reviewer | Layers, SOLID, patterns |
| qa-expert | Test strategy, coverage |

**Inherited from Research (if research deployed them):**
| Validator | Added When |
|-----------|------------|
| python-pro | Research found Python files |
| react-specialist | Research found React files |
| database-administrator | Research found DB code |
| sre-engineer | Research analyzed observability |

```
Total = Tessl Docs + 5 (core) + N (inherited from research Phase 2)
```

**Rules**:
- ✅ Query Tessl for implementation best practices
- ✅ Read research artifact first
- ✅ Extract Phase 2 specialists from research
- ✅ Launch Tessl + Core 5 + inherited validators in parallel
- ✅ Include Tessl insights in the plan
- ✅ Wait for human approval
- ❌ Never implement without approved plan

### /implement - Multi-Agent Execution

For EACH phase, launch 4-6 specialists IN PARALLEL:

1. **Implementation** - python-pro, react-specialist, etc.
2. **Tests** - test-automator
3. **Code Review** - code-reviewer
4. **Security Review** - security-auditor
5. **Documentation** - technical-writer
6. **Performance** - performance-engineer

After ALL phases, run Quality Gates:
- Coverage (100%)
- Integration tests

**Rules**:
- ✅ 4-6 specialists per phase, not 1
- ✅ Resolve all review findings before closing
- ✅ Run verification after each phase
- ❌ Never skip tests or security review

### Artifact Locations

| Type | Path |
|------|------|
| Research | `thoughts/research/YYYY-MM-DD-HHmm-<topic>.md` |
| Plans | `thoughts/plans/YYYY-MM-DD-HHmm-<feature>.md` |
| Skill Files | `.claude/commands/{research,plan,implement}.md` |

### Available Specialist Agents (127 total)

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

### Auto-Sync

bd automatically syncs with git:

- Exports to `.beads/issues.jsonl` after changes (5s debounce)
- Imports from JSONL when newer (e.g., after `git pull`)
- No manual export/import needed!

### GitHub Copilot Integration

If using GitHub Copilot, also create `.github/copilot-instructions.md` for auto-loading instructions.
Run `bd onboard` to get the content, or see step 2 of onboard instructions.

### MCP Server (Recommended)

If using Claude or MCP-compatible clients, install the beads MCP server:

```bash
pip install beads-mcp
```

Add to MCP config (e.g., `~/.config/claude/config.json`):

```json
{
  "beads": {
    "command": "beads-mcp",
    "args": []
  }
}
```

Then use `mcp__beads__*` functions instead of CLI commands.

### Managing AI-Generated Planning Documents

AI assistants frequently create planning and design documents during development:

- PLAN.md, IMPLEMENTATION.md, ARCHITECTURE.md
- DESIGN.md, CODEBASE_SUMMARY.md, INTEGRATION_PLAN.md
- TESTING_GUIDE.md, TECHNICAL_DESIGN.md, and similar files

**Best Practice: Use a dedicated directory for these ephemeral files**

**Recommended approach:**

- Create a `history/` directory at project root
- Store ALL AI-generated planning/design docs in `history/`
- Keep repository root clean and focused on permanent project files
- Access `history/` only when explicitly asked to review past planning

**Example .gitignore entry (optional):**

```
# AI planning documents (ephemeral)
history/
```

**Benefits:**

- ✅ Clean repository root
- ✅ Clear separation between ephemeral and permanent documentation
- ✅ Easy to exclude from version control if desired
- ✅ Preserves planning history for archaeological research
- ✅ Reduces noise when browsing project

### CLI Help

Run `bd <command> --help` to see all available flags for any command.
For example: `bd create --help` shows `--parent`, `--deps`, `--assignee`, etc.

### Important Rules

**⚠️ RULE #0 (NON-NEGOTIABLE):**
**Create bd issue FIRST → Set in_progress → Do work → Close issue → Next issue. NO EXCEPTIONS.**

- ✅ **Create bd issue BEFORE any code change** - User problem, fix, feature, ANY change = bd issue first
- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic usage
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ✅ Store AI planning docs in `history/` directory
- ✅ Run `bd <cmd> --help` to discover available flags
- ✅ **Finish ALL session issues** - Never leave issues open when session ends
- ✅ **Close issues ONLY AFTER task completion** - NEVER close before work is done
- ❌ DO NOT create markdown TODO lists
- ❌ DO NOT use external issue trackers
- ❌ DO NOT duplicate tracking systems
- ❌ DO NOT pollute repo root with planning documents
- ❌ **NEVER start coding without a bd issue**

For more details, see README.md and QUICKSTART.md.

---

## Beads Workflow Integration

This project uses [beads](https://github.com/Dicklesworthstone/beads_viewer) for issue tracking. Issues are stored in `.beads/` and tracked in git.

### Essential Commands

```bash
# View issues (launches TUI - avoid in automated sessions)
bv

# CLI commands for agents (use these instead)
bd ready              # Show issues ready to work on (no blockers)
bd list --status=open # All open issues
bd show <id>          # Full issue details with dependencies
bd create --title="..." --type=task --priority=2
bd update <id> --status=in_progress
bd close <id> --reason="Completed"
bd close <id1> <id2>  # Close multiple issues at once
bd sync               # Commit and push changes
```

### Workflow Pattern

1. **Start**: Run `bd ready` to find actionable work
2. **Claim**: Use `bd update <id> --status=in_progress`
3. **Work**: Implement the task
4. **Complete**: Use `bd close <id>`
5. **Sync**: Always run `bd sync` at session end
6. **Summarize**: After `bd sync` you are required to provide a summary about which changes you made and which bd issues were closed in this session.

### Key Concepts

- **Dependencies**: Issues can block other issues. `bd ready` shows only unblocked work.
- **Priority**: P0=critical, P1=high, P2=medium, P3=low, P4=backlog (use numbers, not words)
- **Types**: task, bug, feature, epic, question, docs
- **Blocking**: `bd dep add <issue> <depends-on>` to add dependencies

### Session Protocol

**Before ending any session, run this checklist:**

```bash
bd sync                 # Commit beads changes
```

### Best Practices

- Check `bd ready` at session start to find available work
- Update status as you work (in_progress → closed)
- Create new issues with `bd create` when you discover tasks
- Use descriptive titles and set appropriate priority/type
- Always `bd sync` before ending session

---

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `bd sync` succeeds.

**MANDATORY WORKFLOW:**

1. **Register issues for remaining work** - Create issues for anything needing follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Do handoff** - Provide context for next session

**CRITICAL RULES:**

- Work is NOT complete until `bd sync` succeeds
- NEVER stop before finishing all bd issues - this leaves work incomplete.
- ALWAYS say "ready to push when you are"

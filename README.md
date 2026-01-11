# Claude RPI Kit

A workflow toolkit that initializes repositories with the **Research-Plan-Implement (RPI)** methodology for Claude Code. This kit provides a structured approach to software development using specialized AI agents, issue tracking, and a tile registry for enhanced capabilities.

## What is RPI?

RPI (Research-Plan-Implement) is a three-phase development workflow designed to maximize the effectiveness of AI-assisted coding:

1. **Research** - Explore and document the codebase state without opinions or suggestions. Understand existing patterns, architecture, and conventions before making changes.

2. **Plan** - Create an executable implementation blueprint based on research findings. Define clear phases, dependencies, and acceptance criteria.

3. **Implement** - Execute the approved plan phase by phase, delegating tasks to specialist agents with domain expertise.

## Purpose

This toolkit solves common problems in AI-assisted development:

- **Context Loss** - Persistent issue tracking with beads prevents losing work context across sessions
- **Unstructured Changes** - The RPI workflow ensures changes are well-researched and planned before implementation
- **Generic Solutions** - 127+ specialist agents provide domain-specific expertise for different tasks
- **Tool Integration** - Pre-configured MCP servers extend Claude Code capabilities

## Subagent Workflow: Context Management

The RPI workflow uses **subagents** (child processes) to prevent context overflow and reduce hallucinations. This is a critical architectural decision.

### Why Subagents?

Every AI model has a **context window** - a fixed amount of information it can process at once. When Claude Code works on complex tasks, the context fills up with:

- File contents being analyzed
- Code being written and reviewed
- Tool outputs and error messages
- Intermediate reasoning and decisions

Once the context window fills up, the model must start "forgetting" earlier information to make room for new content. This leads to:

1. **Lost instructions** - The model forgets what you asked it to do
2. **Inconsistent changes** - Earlier decisions are forgotten, leading to contradictions
3. **Hallucinations** - The model invents information to fill gaps in context
4. **Degraded quality** - Responses become less accurate and coherent

**Subagents solve this by isolating work into separate context windows.** Each subagent is a fresh Claude instance with its own context, focused on a single task. The main session stays clean, receiving only summaries instead of full content.

### The Problem

When an AI agent accumulates too much context in a single session:
- Context window fills up with intermediate results
- Model starts "forgetting" earlier instructions
- Increased probability of hallucinations
- Performance degrades as context grows

### The Solution: Delegation to Subagents

Instead of doing all work in the main session, RPI delegates tasks to specialized subagents:

```
Main Session (orchestrator)
    |
    +---> Subagent 1: python-pro (analyzes Python code)
    |         Returns: summary only
    |
    +---> Subagent 2: react-specialist (analyzes React code)
    |         Returns: summary only
    |
    +---> Subagent 3: security-auditor (security review)
              Returns: summary only
```

### How It Works

1. **Main session** reads the plan and orchestrates execution
2. **Subagents** are launched with specific, focused tasks
3. Each subagent has its **own context window** (isolated)
4. Subagents return **only the summary/result** to main session
5. Main session receives minimal context, stays focused

### Benefits

| Aspect | Without Subagents | With Subagents |
|--------|-------------------|----------------|
| Context usage | Grows unbounded | Stays minimal |
| Hallucination risk | High | Low |
| Specialization | Generic responses | Domain expertise |
| Parallelization | Sequential | Parallel execution |
| Failure isolation | Cascading | Contained |

### Example: /implement Phase

When implementing a feature phase:

```
Main Session:
  "Implement authentication for Phase 2"
      |
      +---> python-pro: "Write the auth module"
      |         (works in isolation, returns: "Created auth.py with JWT handling")
      |
      +---> test-automator: "Write tests for auth"
      |         (works in isolation, returns: "Created test_auth.py with 15 tests")
      |
      +---> security-auditor: "Review auth implementation"
              (works in isolation, returns: "No vulnerabilities found")

Main Session receives only summaries, not all the code/analysis.
```

### Rules for Subagent Usage

1. **Always delegate** - Never do specialist work in main session
2. **Parallel when possible** - Launch independent subagents together
3. **Specific prompts** - Give subagents focused, clear tasks
4. **Summary returns** - Subagents return results, not full context
5. **Right specialist** - Use domain-specific agents, not general-purpose

## What Gets Installed

When you run the initialization script on a target repository, it installs:

```
target-repo/
├── .claude/
│   ├── commands/
│   │   ├── research.md    -> /research <topic>
│   │   ├── plan.md        -> /plan <feature>
│   │   └── implement.md   -> /implement
│   └── agents/            -> 127 specialist agents
├── tessl.json             -> Tessl tile registry
├── .mcp.json              -> MCP server configuration
├── .beads/                -> Issue tracking database
├── AGENTS.md              -> Workflow documentation
└── thoughts/
    ├── research/          -> Research artifacts
    └── plans/             -> Plan artifacts
```

## Installation

### Prerequisites

- Git
- Node.js and npm (for tessl)
- Claude Code CLI

### Clone the Kit

```bash
git clone --recursive https://github.com/your-org/claude-rpi-kit.git
cd claude-rpi-kit
```

If you cloned without `--recursive`, initialize the submodule:

```bash
git submodule update --init --recursive
```

### Initialize a Target Repository

1. Open Claude Code in the kit directory:

```bash
cd claude-rpi-kit
claude
```

2. Run the initialization command:

```
/initialize
```

3. When prompted, provide the absolute path to your target repository.

The initialization will:

1. Validate the kit structure
2. Copy agents and commands to the target repository
3. Install and initialize beads (issue tracking)
4. Install and authenticate tessl (tile registry)
5. Configure MCP servers

## Usage

After initialization, open Claude Code in your target repository and use the RPI commands:

```
/research <topic>    - Explore and document the codebase
/plan <feature>      - Create an implementation blueprint
/implement           - Execute the plan with specialist agents
```

## Dependencies

This project integrates the following open-source tools:

### Awesome Claude Code Subagents

A curated collection of specialist agent definitions for Claude Code.

- **Repository**: https://github.com/VoltAgent/awesome-claude-code-subagents
- **Purpose**: Provides 127+ agent definitions with domain-specific expertise (security, performance, architecture, testing, language-specific, etc.)
- **Integration**: Included as a git submodule, agents are copied to target repositories during initialization

### Beads (bd)

A git-friendly issue tracking system optimized for AI agents.

- **Repository**: https://github.com/steveyegge/beads
- **Purpose**: Persistent issue tracking with dependency management, designed for multi-session AI workflows
- **Integration**: Installed globally via install script, initialized per-repository with `bd init`
- **Documentation**: https://github.com/steveyegge/beads#readme

### Tessl

The official tile registry and MCP integration for Claude Code.

- **Repository**: https://github.com/anthropics/tessl
- **Purpose**: Access to curated tiles (tools, integrations, capabilities) via MCP protocol
- **Integration**: Installed via npm, requires authentication via `tessl login`
- **Documentation**: https://tessl.io

## Configuration

### Beads Configuration

By default, the script configures beads with:

```bash
bd config set no-git-ops true
```

This disables automatic git operations, giving you full control over commits.

### Tessl Authentication

Tessl requires authentication to access the tile registry. During initialization, you will be prompted to login if not already authenticated:

```bash
tessl login
```

This opens a browser for authentication via the Tessl platform.

## Project Structure

```
claude-rpi-kit/
├── .claude/
│   ├── agents/            -> Agent definitions (populated from submodule)
│   └── commands/          -> RPI skill commands
├── awesome-claude-code-subagents/  -> Git submodule
├── initialize_repo.sh     -> Main initialization script
├── AGENTS.md              -> Template for target repos
├── tessl.json             -> Kit tessl configuration
└── .mcp.json              -> Kit MCP configuration
```

## License

MIT License - See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome. Please ensure any changes maintain compatibility with the RPI workflow and all integrated tools.

## Acknowledgments

- [VoltAgent](https://github.com/VoltAgent) for the awesome-claude-code-subagents collection
- [Steve Yegge](https://github.com/steveyegge) for the beads issue tracking system
- [Anthropic](https://github.com/anthropics) for tessl and Claude Code

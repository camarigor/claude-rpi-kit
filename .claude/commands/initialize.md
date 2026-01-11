---
name: initialize
description: Initialize a target repository with the RPI workflow (agents, skills, beads)
---

# RPI Repository Initializer

This skill executes the `initialize_repo.sh` script to set up a target repository with the complete RPI workflow.

---

## STEP 1: Ask for Target Repository

**Use AskUserQuestion tool to ask the user for the target repository path:**

```
question: "What is the absolute path to the repository you want to initialize?"
header: "Target repo"
options:
  - label: "Enter path manually"
    description: "You'll provide the full path (e.g., /home/user/my-project)"
```

Wait for the user to provide the absolute path to the target repository.

**Store the path in variable: TARGET_REPO**

---

## STEP 2: Validate Target Repository

Verify the target repository exists and is valid:

```bash
# Check if path exists
ls -la "<TARGET_REPO>"

# Check if it's a git repository
ls -la "<TARGET_REPO>/.git"
```

If the path doesn't exist, inform the user and ask for a valid path.

---

## STEP 3: Execute Initialization Script

Run the initialization script with the target repository path:

```bash
# Find the RPI kit location
RPI_KIT_DIR="$HOME/git/claude-rpi-kit"

# Execute the script with the target repo path
echo "<TARGET_REPO>" | "$RPI_KIT_DIR/initialize_repo.sh"
```

**IMPORTANT**: Capture the full output and analyze it for any errors or warnings.

---

## STEP 3: Analyze Output

After running the script, check for:

### Success Indicators
- `[OK] Populated X agents into kit`
- `[OK] Copied .claude directory`
- `[OK] Copied AGENTS.md`
- `[OK] Created thoughts directory`
- `[OK] beads installed` or `[OK] beads already installed`
- `[OK] beads initialized in target repository`
- `INITIALIZATION COMPLETE`

### Warning Indicators (may need action)
- `[WARN] Target already has .claude directory` → Ask user if overwrite is ok
- `[WARN] Target already has AGENTS.md` → Ask user if overwrite is ok
- `[WARN] Submodule not found` → Need to initialize git submodule
- `[WARN] Could not install beads automatically` → Manual installation needed
- `[WARN] beads (bd) command not found` → Installation failed

### Error Indicators (need fix)
- `[ERROR] Directory does not exist` → Invalid path provided
- `[ERROR] Missing .claude directory in kit` → Kit is corrupted
- `[ERROR] Kit validation failed` → Kit needs repair

---

## STEP 4: Handle Failures

### If submodule not found:
```bash
cd "$RPI_KIT_DIR"
git submodule update --init --recursive
```
Then re-run the initialization.

### If beads installation failed:
```bash
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```
Then initialize beads manually:
```bash
cd "<TARGET_REPO>"
bd init
```

### If bd init fails with hook conflicts:
The script should handle this, but if it fails:
```bash
cd "<TARGET_REPO>"
bd init
# Choose option 1 (Chain with existing hooks) when prompted
```

### If bd init fails with permission errors:
```bash
chmod +x "<TARGET_REPO>/.git/hooks/"*
cd "<TARGET_REPO>"
bd init
```

---

## STEP 5: Verify Installation

After successful initialization, verify everything is in place:

```bash
# Check .claude structure
ls -la "<TARGET_REPO>/.claude/"
ls "<TARGET_REPO>/.claude/agents/" | wc -l
ls "<TARGET_REPO>/.claude/commands/"

# Check AGENTS.md
ls -la "<TARGET_REPO>/AGENTS.md"

# Check thoughts directory
ls -la "<TARGET_REPO>/thoughts/"

# Check beads
ls -la "<TARGET_REPO>/.beads/"
cd "<TARGET_REPO>" && bd stats
```

---

## STEP 6: Report to User

Provide a summary:

```markdown
## Repository Initialized Successfully

**Target**: <TARGET_REPO>

### Installed Components
| Component | Status | Details |
|-----------|--------|---------|
| .claude/agents/ | ✅ | X specialist agents |
| .claude/commands/ | ✅ | research, plan, implement |
| AGENTS.md | ✅ | Workflow documentation |
| thoughts/ | ✅ | Artifact directories |
| .beads/ | ✅ | Issue tracking ready |

### Available Commands
- `/research <topic>` - Discover and document codebase
- `/plan <feature>` - Create implementation blueprint
- `/implement` - Execute plan with specialist agents

### Next Steps
1. `cd <TARGET_REPO>`
2. Start with `/research <topic>` to explore the codebase
```

---

## Rules

**MUST:**
- ✅ Validate target path before running script
- ✅ Capture and analyze full script output
- ✅ Handle any errors or warnings
- ✅ Verify installation after script completes
- ✅ Report clear status to user

**MUST NOT:**
- ❌ Ignore script errors or warnings
- ❌ Skip verification step
- ❌ Leave failed initialization without attempting fix

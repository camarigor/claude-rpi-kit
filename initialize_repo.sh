#!/bin/bash

# ============================================================================
# RPI Kit - Repository Initializer
# ============================================================================
# This script initializes a target repository with the RPI (Research-Plan-
# Implement) workflow structure, including Claude skills and agent definitions.
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located (the kit root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/.rpi-targets"

# ============================================================================
# Helper Functions
# ============================================================================

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║     ██████╗ ██████╗ ██╗    ██╗  ██╗██╗████████╗                 ║"
    echo "║     ██╔══██╗██╔══██╗██║    ██║ ██╔╝██║╚══██╔══╝                 ║"
    echo "║     ██████╔╝██████╔╝██║    █████╔╝ ██║   ██║                    ║"
    echo "║     ██╔══██╗██╔═══╝ ██║    ██╔═██╗ ██║   ██║                    ║"
    echo "║     ██║  ██║██║     ██║    ██║  ██╗██║   ██║                    ║"
    echo "║     ╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝  ╚═╝╚═╝   ╚═╝                    ║"
    echo "║                                                                  ║"
    echo "║     Research → Plan → Implement Workflow Kit                     ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# ============================================================================
# Main Functions
# ============================================================================

validate_kit() {
    print_step "Validating RPI Kit structure..."

    local missing=0

    if [[ ! -d "$SCRIPT_DIR/.claude" ]]; then
        print_error "Missing .claude directory in kit"
        missing=1
    fi

    if [[ ! -f "$SCRIPT_DIR/AGENTS.md" ]]; then
        print_error "Missing AGENTS.md in kit"
        missing=1
    fi

    if [[ ! -d "$SCRIPT_DIR/.claude/commands" ]]; then
        print_error "Missing .claude/commands directory in kit"
        missing=1
    fi

    if [[ ! -d "$SCRIPT_DIR/.claude/agents" ]]; then
        print_error "Missing .claude/agents directory in kit"
        missing=1
    fi

    if [[ $missing -eq 1 ]]; then
        print_error "Kit validation failed. Please ensure the kit is complete."
        exit 1
    fi

    print_success "Kit structure validated"
}

prompt_for_repository() {
    echo ""
    print_step "Repository Selection"
    echo ""
    echo -e "Enter the ${YELLOW}full path${NC} to the repository you want to initialize:"
    echo -e "(Example: /home/user/projects/my-project)"
    echo ""
    read -p "> " TARGET_REPO

    # Expand ~ to home directory
    TARGET_REPO="${TARGET_REPO/#\~/$HOME}"

    # Remove trailing slash if present
    TARGET_REPO="${TARGET_REPO%/}"

    # Validate the path
    if [[ -z "$TARGET_REPO" ]]; then
        print_error "No path provided"
        exit 1
    fi

    if [[ ! -d "$TARGET_REPO" ]]; then
        print_error "Directory does not exist: $TARGET_REPO"
        exit 1
    fi

    # Check if it's a git repository
    if [[ ! -d "$TARGET_REPO/.git" ]]; then
        print_warning "Target is not a git repository"
        read -p "Continue anyway? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Aborted by user"
            exit 0
        fi
    fi

    print_success "Target repository: $TARGET_REPO"
}

save_target() {
    print_step "Saving target repository..."

    # Add to config file if not already present
    if [[ -f "$CONFIG_FILE" ]]; then
        if grep -Fxq "$TARGET_REPO" "$CONFIG_FILE" 2>/dev/null; then
            print_info "Repository already in saved targets"
        else
            echo "$TARGET_REPO" >> "$CONFIG_FILE"
            print_success "Repository added to saved targets"
        fi
    else
        echo "$TARGET_REPO" > "$CONFIG_FILE"
        print_success "Created targets file and saved repository"
    fi
}

copy_claude_directory() {
    print_step "Copying .claude directory..."

    local source="$SCRIPT_DIR/.claude"
    local dest="$TARGET_REPO/.claude"

    if [[ -d "$dest" ]]; then
        print_warning "Target already has .claude directory"
        read -p "Overwrite? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Skipping .claude directory"
            return
        fi
        rm -rf "$dest"
    fi

    cp -r "$source" "$dest"

    # Count what was copied
    local commands_count=$(find "$dest/commands" -name "*.md" 2>/dev/null | wc -l)
    local agents_count=$(find "$dest/agents" -name "*.md" 2>/dev/null | wc -l)

    print_success "Copied .claude directory"
    print_info "  - $commands_count skill commands (research, plan, implement)"
    print_info "  - $agents_count agent definitions"
}

copy_agents_md() {
    print_step "Copying AGENTS.md..."

    local source="$SCRIPT_DIR/AGENTS.md"
    local dest="$TARGET_REPO/AGENTS.md"

    if [[ -f "$dest" ]]; then
        print_warning "Target already has AGENTS.md"
        read -p "Overwrite? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Skipping AGENTS.md"
            return
        fi
    fi

    cp "$source" "$dest"
    print_success "Copied AGENTS.md"
}

populate_kit_agents() {
    print_step "Populating kit agents from submodule..."

    local submodule_dir="$SCRIPT_DIR/awesome-claude-code-subagents/categories"
    local kit_agents="$SCRIPT_DIR/.claude/agents"

    # Verify submodule exists
    if [[ ! -d "$submodule_dir" ]]; then
        print_warning "Submodule not found at: $submodule_dir"
        print_info "Skipping agent population"
        return
    fi

    # Create agents directory in kit if it doesn't exist
    mkdir -p "$kit_agents"

    # Copy all .md files (excluding README.md) from submodule to kit
    find "$submodule_dir" -type f -name "*.md" ! -name "README.md" -exec cp {} "$kit_agents/" \;

    # Count agents
    local agent_count
    agent_count=$(find "$kit_agents" -type f -name "*.md" | wc -l)

    print_success "Populated $agent_count agents into kit"
    print_info "  - Source: awesome-claude-code-subagents/categories/"
    print_info "  - Kit: .claude/agents/"
}

create_thoughts_directory() {
    print_step "Creating thoughts directory structure..."

    local thoughts_dir="$TARGET_REPO/thoughts"

    mkdir -p "$thoughts_dir/research"
    mkdir -p "$thoughts_dir/plans"

    # Create .gitkeep files to preserve empty directories
    touch "$thoughts_dir/research/.gitkeep"
    touch "$thoughts_dir/plans/.gitkeep"

    print_success "Created thoughts directory"
    print_info "  - thoughts/research/ (for /research artifacts)"
    print_info "  - thoughts/plans/ (for /plan artifacts)"
}

install_beads() {
    print_step "Checking beads installation..."

    # Check if beads is already installed
    if command -v bd &> /dev/null; then
        local version
        version=$(bd --version 2>/dev/null || echo "unknown")
        print_success "beads already installed (version: $version)"
        return
    fi

    print_info "beads not found, installing..."

    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        print_warning "curl not found, cannot install beads automatically"
        print_info "Please install manually:"
        print_info "  curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash"
        return
    fi

    # Install beads using official install script
    if curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash; then
        if command -v bd &> /dev/null; then
            print_success "beads installed successfully"
            return
        fi
    fi

    print_warning "Could not install beads automatically"
    print_info "Please install manually:"
    print_info "  curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash"
}

initialize_beads() {
    print_step "Initializing beads in target repository..."

    # Check if bd command exists
    if ! command -v bd &> /dev/null; then
        print_warning "beads (bd) command not found, skipping initialization"
        print_info "Install beads and run 'bd init' manually in target repo"
        return
    fi

    # Check if beads is already initialized (look for database file, not just directory)
    if [[ -f "$TARGET_REPO/.beads/beads.db" ]]; then
        print_info "beads already initialized in target repository"
        return
    fi

    # Initialize beads in target repository
    cd "$TARGET_REPO" || return

    # Run bd init
    if bd init --quiet 2>/dev/null; then
        print_success "beads initialized in target repository"
        print_info "  - Created .beads/ directory"
        print_info "  - Issue tracking ready"
    else
        # Try without --quiet flag
        if bd init 2>/dev/null; then
            print_success "beads initialized in target repository"
        else
            print_warning "Could not initialize beads automatically"
            print_info "Run 'bd init' manually in target repo"
            cd - > /dev/null || return
            return
        fi
    fi

    # Configure beads to disable git operations
    print_info "Configuring beads..."
    if bd config set no-git-ops true 2>/dev/null; then
        print_success "beads configured (no-git-ops: true)"
    fi

    # Run bd doctor --fix until no warnings remain
    print_info "Running bd doctor --fix..."
    local max_attempts=5
    local attempt=1
    local doctor_output

    while [[ $attempt -le $max_attempts ]]; do
        # Pass Y to confirm fixes automatically
        doctor_output=$(echo "Y" | bd doctor --fix 2>&1) || true

        # Check if there are any issues marked with ✖ or ⚠
        if echo "$doctor_output" | grep -q "✖\|⚠" 2>/dev/null; then
            print_info "bd doctor attempt $attempt: fixing issues..."
            echo "$doctor_output" | grep "✖\|⚠" 2>/dev/null | head -10 || true
            ((attempt++))
            sleep 1
        else
            print_success "bd doctor: all checks passed"
            break
        fi
    done

    if [[ $attempt -gt $max_attempts ]]; then
        print_warning "bd doctor: some issues may remain after $max_attempts attempts"
        print_info "Run 'bd doctor --fix' manually to resolve"
    fi

    # Prime the database
    bd prime 2>/dev/null

    # Return to original directory
    cd - > /dev/null || return
}

install_tessl() {
    print_step "Checking tessl installation..."

    # Check if tessl is already installed
    if command -v tessl &> /dev/null; then
        local version
        version=$(tessl --version 2>/dev/null || echo "unknown")
        print_success "tessl already installed (version: $version)"
        return 0
    fi

    print_info "tessl not found, installing..."

    # Check if npm is available
    if ! command -v npm &> /dev/null; then
        print_warning "npm not found, cannot install tessl automatically"
        print_info "Please install npm and then run:"
        print_info "  npm install -g @anthropic-ai/tessl"
        return 1
    fi

    # Install tessl using npm
    print_info "Running: npm install -g @anthropic-ai/tessl"
    if npm install -g @anthropic-ai/tessl; then
        if command -v tessl &> /dev/null; then
            print_success "tessl installed successfully"
            return 0
        fi
    fi

    print_warning "Could not install tessl automatically"
    print_info "Please install manually:"
    print_info "  npm install -g @anthropic-ai/tessl"
    return 1
}

authenticate_tessl() {
    print_step "Checking tessl authentication..."

    # Check if tessl command exists
    if ! command -v tessl &> /dev/null; then
        return 1
    fi

    # Check if user is already authenticated
    if tessl whoami &> /dev/null; then
        local email
        email=$(tessl whoami 2>/dev/null | grep -i "email" | awk '{print $2}')
        print_success "tessl authenticated as: $email"
        return 0
    fi

    # User needs to login
    print_warning "tessl not authenticated"
    echo ""
    echo -e "${YELLOW}Tessl requires authentication to access the tile registry.${NC}"
    echo -e "This will open a browser for you to login/register."
    echo ""
    read -p "Do you want to login now? (Y/n): " confirm

    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        print_info "Skipping tessl authentication"
        print_info "Run 'tessl login' later to authenticate"
        return 1
    fi

    # Run tessl login
    print_info "Starting tessl login..."
    if tessl login; then
        print_success "tessl authentication complete"
        return 0
    else
        print_warning "tessl login failed or was cancelled"
        print_info "Run 'tessl login' later to authenticate"
        return 1
    fi
}

initialize_tessl() {
    print_step "Initializing tessl in target repository..."

    # Check if tessl command exists
    if ! command -v tessl &> /dev/null; then
        print_warning "tessl not installed, skipping initialization"
        return
    fi

    # Check if user is authenticated
    if ! tessl whoami &> /dev/null; then
        print_warning "tessl not authenticated, skipping initialization"
        return
    fi

    # Check if tessl is already initialized (tessl.json exists)
    if [[ -f "$TARGET_REPO/tessl.json" ]]; then
        print_info "tessl already initialized in target repository"

        # Ensure .mcp.json has tessl configured
        if [[ ! -f "$TARGET_REPO/.mcp.json" ]] || ! grep -q '"tessl"' "$TARGET_REPO/.mcp.json" 2>/dev/null; then
            print_info "Configuring tessl MCP..."
            cd "$TARGET_REPO" || return
            tessl init --agent claude-code  2>/dev/null
            cd - > /dev/null || return
        fi
        return
    fi

    # Initialize tessl in target repository
    cd "$TARGET_REPO" || return

    # Run tessl init
    if tessl init --agent claude-code  2>/dev/null; then
        print_success "tessl initialized in target repository"
        print_info "  - Created tessl.json"
        print_info "  - Configured .mcp.json with tessl MCP server"
    else
        print_warning "Could not initialize tessl automatically"
        print_info "Run 'tessl init --agent claude-code' manually in target repo"
    fi

    # Return to original directory
    cd - > /dev/null || return
}

print_summary() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    INITIALIZATION COMPLETE                       ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Repository initialized:${NC} $TARGET_REPO"
    echo ""
    # Count actual agents in destination
    local final_agent_count=$(find "$TARGET_REPO/.claude/agents" -name "*.md" 2>/dev/null | wc -l)

    # Check if beads was initialized
    local beads_status="not initialized"
    if [[ -d "$TARGET_REPO/.beads" ]]; then
        beads_status="initialized"
    fi

    # Check if tessl was initialized
    local tessl_status="not initialized"
    if [[ -f "$TARGET_REPO/tessl.json" ]]; then
        tessl_status="initialized"
    fi

    echo -e "${YELLOW}What was installed:${NC}"
    echo "  ├── .claude/"
    echo "  │   ├── commands/"
    echo "  │   │   ├── research.md    → /research <topic>"
    echo "  │   │   ├── plan.md        → /plan <feature>"
    echo "  │   │   └── implement.md   → /implement"
    echo "  │   └── agents/            → $final_agent_count specialist agents"
    echo "  ├── tessl.json             → Tessl registry ($tessl_status)"
    echo "  ├── .mcp.json              → MCP servers (tessl)"
    echo "  ├── .beads/                → Issue tracking ($beads_status)"
    echo "  ├── AGENTS.md              → Agent rules and workflow docs"
    echo "  └── thoughts/"
    echo "      ├── research/          → Research artifacts"
    echo "      └── plans/             → Plan artifacts"
    echo ""
    echo -e "${YELLOW}Available RPI Commands:${NC}"
    echo "  /research <topic>   - Discover and document codebase state"
    echo "  /plan <feature>     - Create validated implementation blueprint"
    echo "  /implement          - Execute plan with parallel specialist agents"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "  1. cd $TARGET_REPO"
    echo "  2. Open Claude Code"
    echo "  3. Run /research <topic> to start"
    echo ""
}

show_saved_targets() {
    if [[ -f "$CONFIG_FILE" ]]; then
        echo ""
        print_info "Previously initialized repositories:"
        while IFS= read -r line; do
            echo "  - $line"
        done < "$CONFIG_FILE"
        echo ""
    fi
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    print_banner

    # Show previously saved targets
    show_saved_targets

    # Validate the kit structure
    validate_kit

    # Ask for target repository
    prompt_for_repository

    # Save the target for future reference
    save_target

    echo ""
    print_step "Starting initialization..."
    echo ""

    # First, populate kit with agents from submodule
    populate_kit_agents

    # Then copy components to target
    copy_claude_directory
    copy_agents_md
    create_thoughts_directory

    # Install and initialize beads
    install_beads
    initialize_beads

    # Install, authenticate and initialize tessl
    install_tessl
    authenticate_tessl
    initialize_tessl

    # Print summary
    print_summary
}

# Run main function
main "$@"

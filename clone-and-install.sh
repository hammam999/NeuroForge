#!/usr/bin/env bash

# AI-Powered IDEs Installer Script
# This script installs Kiro or Windsurf on any Linux distribution

set -e

# Colors and styles for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Repository information
KIRO_REPO_URL="https://github.com/mazonyfahmi/kiro-ide-linux"
TEMP_DIR="/tmp/ai_ide_installer_$(date +%s)"
SELECTED_APP=""
INSTALL_SCRIPT=""

print_banner() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}${WHITE}🚀 NeuroForge - AI IDEs Installer${NC}                         ${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${DIM}Forge Your AI Development Environment${NC}                      ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_app_menu() {
    echo -e "${BOLD}${WHITE}📦 Select an IDE to install:${NC}"
    echo
    echo -e "  ${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}1${NC}) ${GREEN}🔷 Kiro IDE${NC}                                         ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}    ${DIM}AI-powered development environment${NC}                  ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}    ${DIM}✨ Smart code completion & AI assistance${NC}            ${CYAN}│${NC}"
    echo -e "  ${CYAN}├─────────────────────────────────────────────────────────┤${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}2${NC}) ${BLUE}🌊 Windsurf IDE${NC}                                     ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}    ${DIM}The first agentic IDE, and then some${NC}               ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}    ${DIM}🤖 Advanced AI agent capabilities${NC}                  ${CYAN}│${NC}"
    echo -e "  ${CYAN}├─────────────────────────────────────────────────────────┤${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}3${NC}) ${MAGENTA}⚡ Install Both${NC}                                     ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC}    ${DIM}Get the best of both worlds${NC}                        ${CYAN}│${NC}"
    echo -e "  ${CYAN}├─────────────────────────────────────────────────────────┤${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}0${NC}) ${RED}❌ Exit${NC}                                             ${CYAN}│${NC}"
    echo -e "  ${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo
}

show_selection() {
    local app=$1
    echo
    echo -e "${GREEN}╭────────────────────────────────────────╮${NC}"
    echo -e "${GREEN}│${NC}  ✓ Selected: ${BOLD}${WHITE}$app${NC}                ${GREEN}│${NC}"
    echo -e "${GREEN}╰────────────────────────────────────────╯${NC}"
    echo
}

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        echo -e "${YELLOW}Cleaning up temporary files...${NC}"
        rm -rf "$TEMP_DIR"
    fi
}

# Set up cleanup on exit
trap cleanup EXIT

check_dependencies() {
    echo -e "${YELLOW}⏳ Checking dependencies...${NC}"
    
    local deps=("git" "bash" "curl")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}❌ Error: Missing required dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Please install the missing dependencies and try again.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ All dependencies satisfied.${NC}"
}

clone_kiro_repo() {
    echo -e "${YELLOW}📥 Cloning Kiro repository...${NC}"
    echo -e "${BLUE}Repository: $KIRO_REPO_URL${NC}"
    echo -e "${BLUE}Temporary directory: $TEMP_DIR${NC}"
    
    if ! git clone "$KIRO_REPO_URL" "$TEMP_DIR"; then
        echo -e "${RED}❌ Error: Failed to clone repository${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Repository cloned successfully.${NC}"
}

copy_local_scripts() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    echo -e "${YELLOW}📋 Copying installation scripts...${NC}"
    
    mkdir -p "$TEMP_DIR"
    
    # Copy both installation scripts
    if [ -f "$script_dir/install-kiro.sh" ]; then
        cp "$script_dir/install-kiro.sh" "$TEMP_DIR/"
        chmod +x "$TEMP_DIR/install-kiro.sh"
        echo -e "${GREEN}✓ Kiro installer copied${NC}"
    fi
    
    if [ -f "$script_dir/install-windsurf.sh" ]; then
        cp "$script_dir/install-windsurf.sh" "$TEMP_DIR/"
        chmod +x "$TEMP_DIR/install-windsurf.sh"
        echo -e "${GREEN}✓ Windsurf installer copied${NC}"
    fi
    
    # Copy icon if exists
    if [ -f "$script_dir/Kiro_1024x1024x32.png" ]; then
        cp "$script_dir/Kiro_1024x1024x32.png" "$TEMP_DIR/"
        echo -e "${GREEN}✓ Kiro icon copied${NC}"
    fi
}

run_kiro_installer() {
    local script_path="$TEMP_DIR/install-kiro.sh"
    
    echo
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Installing Kiro IDE...${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo
    
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}❌ Error: Kiro installer not found${NC}"
        exit 1
    fi
    
    cd "$TEMP_DIR"
    "$script_path" "$@"
}

run_windsurf_installer() {
    local script_path="$TEMP_DIR/install-windsurf.sh"
    
    echo
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Installing Windsurf IDE...${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo
    
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}❌ Error: Windsurf installer not found${NC}"
        exit 1
    fi
    
    "$script_path" "$@"
}

get_user_choice() {
    local choice
    while true; do
        echo -ne "${BOLD}${WHITE}👉 Enter your choice [0-3]: ${NC}"
        read -r choice
        
        case $choice in
            1)
                SELECTED_APP="kiro"
                show_selection "Kiro IDE"
                return 0
                ;;
            2)
                SELECTED_APP="windsurf"
                show_selection "Windsurf IDE"
                return 0
                ;;
            3)
                SELECTED_APP="both"
                show_selection "Both IDEs"
                return 0
                ;;
            0)
                echo -e "${YELLOW}\n👋 Exiting installer. Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please select 0-3.${NC}\n"
                ;;
        esac
    done
}

print_usage() {
    print_banner
    echo -e "${BOLD}Usage:${NC} $0 [OPTIONS]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo -e "  ${GREEN}--user${NC}        Install for current user only (no sudo required)"
    echo -e "  ${GREEN}--force${NC}       Force reinstall even if same version exists"
    echo -e "  ${GREEN}--uninstall${NC}   Uninstall selected IDE"
    echo -e "  ${GREEN}--clean${NC}       Remove user data during uninstall"
    echo -e "  ${GREEN}--help${NC}        Display this help message"
    echo
    echo -e "${BOLD}Examples:${NC}"
    echo -e "  ${CYAN}$0${NC}                    # Interactive menu"
    echo -e "  ${CYAN}$0 --user${NC}            # Install for current user"
    echo -e "  ${CYAN}$0 --force${NC}           # Force reinstall"
    echo -e "  ${CYAN}$0 --uninstall --user${NC} # Uninstall user installation"
    echo
}

# Main script execution
main() {
    # Check for help flag
    for arg in "$@"; do
        case $arg in
            --help | -h)
                print_usage
                exit 0
                ;;
        esac
    done
    
    # Show banner and menu
    print_banner
    print_app_menu
    
    # Get user choice
    get_user_choice
    
    # Check dependencies
    check_dependencies
    
    # Copy local scripts to temp directory
    copy_local_scripts
    
    # Execute installation based on selection
    case $SELECTED_APP in
        kiro)
            run_kiro_installer "$@"
            ;;
        windsurf)
            run_windsurf_installer "$@"
            ;;
        both)
            run_kiro_installer "$@"
            echo
            echo -e "${MAGENTA}═══════════════════════════════════════════${NC}"
            echo
            run_windsurf_installer "$@"
            ;;
    esac
    
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${BOLD}✨ Installation completed!${NC}          ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
}

# Run main function
main "$@"
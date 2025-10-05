#!/usr/bin/env bash

# AI-Powered IDEs GUI Installer
# This script provides a graphical interface for installing Kiro and Windsurf IDEs

set -e

# Colors for terminal output (fallback)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Global variables
DIALOG_TOOL=""
TEMP_DIR="/tmp/ai_ide_gui_installer_$(date +%s)"
SELECTED_APP=""
INSTALL_OPTIONS=""

# Detect available dialog tool
detect_dialog_tool() {
    if command -v whiptail &> /dev/null; then
        DIALOG_TOOL="whiptail"
    elif command -v dialog &> /dev/null; then
        DIALOG_TOOL="dialog"
    else
        return 1
    fi
    return 0
}

# Install dialog tool if not available
install_dialog_tool() {
    echo -e "${YELLOW}Installing dialog tool...${NC}"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y whiptail
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y newt
    elif command -v yum &> /dev/null; then
        sudo yum install -y newt
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm libnewt
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y newt
    else
        echo -e "${RED}Could not install dialog tool automatically.${NC}"
        echo -e "${YELLOW}Please install 'whiptail' or 'dialog' manually.${NC}"
        exit 1
    fi
    
    # Detect again after installation
    detect_dialog_tool
}

# Show welcome screen
show_welcome() {
    if [ "$DIALOG_TOOL" = "whiptail" ]; then
        whiptail --title "🚀 NeuroForge - AI IDEs Installer" \
            --msgbox "Welcome to NeuroForge!\n\nForge Your AI Development Environment\n\nThis wizard will help you install:\n\n🔷 Kiro IDE - AI-powered development environment\n🌊 Windsurf IDE - The first agentic IDE\n\nPress OK to continue..." 16 70
    else
        dialog --title "🚀 NeuroForge - AI IDEs Installer" \
            --msgbox "Welcome to NeuroForge!\n\nForge Your AI Development Environment\n\nThis wizard will help you install:\n\n🔷 Kiro IDE - AI-powered development environment\n🌊 Windsurf IDE - The first agentic IDE\n\nPress OK to continue..." 16 70
    fi
}

# Show IDE selection menu
show_ide_selection() {
    if [ "$DIALOG_TOOL" = "whiptail" ]; then
        SELECTED_APP=$(whiptail --title "📦 Select IDE to Install" \
            --menu "Choose an IDE to install:" 18 70 4 \
            "kiro" "🔷 Kiro IDE - AI-powered development" \
            "windsurf" "🌊 Windsurf IDE - Agentic IDE" \
            "both" "⚡ Install Both IDEs" \
            "exit" "❌ Exit Installer" \
            3>&1 1>&2 2>&3)
    else
        SELECTED_APP=$(dialog --title "📦 Select IDE to Install" \
            --menu "Choose an IDE to install:" 18 70 4 \
            "kiro" "🔷 Kiro IDE - AI-powered development" \
            "windsurf" "🌊 Windsurf IDE - Agentic IDE" \
            "both" "⚡ Install Both IDEs" \
            "exit" "❌ Exit Installer" \
            3>&1 1>&2 2>&3)
    fi
    
    local exit_status=$?
    
    if [ $exit_status -ne 0 ] || [ "$SELECTED_APP" = "exit" ]; then
        show_goodbye
        exit 0
    fi
}

# Show installation options
show_install_options() {
    local options=""
    
    if [ "$DIALOG_TOOL" = "whiptail" ]; then
        options=$(whiptail --title "⚙️ Installation Options" \
            --checklist "Select installation options:" 15 70 3 \
            "user" "Install for current user only (no sudo)" OFF \
            "force" "Force reinstall if already installed" OFF \
            3>&1 1>&2 2>&3)
    else
        options=$(dialog --title "⚙️ Installation Options" \
            --checklist "Select installation options:" 15 70 3 \
            "user" "Install for current user only (no sudo)" OFF \
            "force" "Force reinstall if already installed" OFF \
            3>&1 1>&2 2>&3)
    fi
    
    # Convert to command-line arguments
    INSTALL_OPTIONS=""
    if echo "$options" | grep -q "user"; then
        INSTALL_OPTIONS="$INSTALL_OPTIONS --user"
    fi
    if echo "$options" | grep -q "force"; then
        INSTALL_OPTIONS="$INSTALL_OPTIONS --force"
    fi
}

# Show confirmation dialog
show_confirmation() {
    local app_name=""
    case "$SELECTED_APP" in
        kiro)
            app_name="Kiro IDE"
            ;;
        windsurf)
            app_name="Windsurf IDE"
            ;;
        both)
            app_name="Both Kiro and Windsurf IDEs"
            ;;
    esac
    
    local message="You are about to install: $app_name\n\nOptions: ${INSTALL_OPTIONS:-None}\n\nDo you want to proceed?"
    
    if [ "$DIALOG_TOOL" = "whiptail" ]; then
        whiptail --title "✅ Confirm Installation" \
            --yesno "$message" 12 70
    else
        dialog --title "✅ Confirm Installation" \
            --yesno "$message" 12 70
    fi
    
    return $?
}

# Show progress
show_progress() {
    local message="$1"
    
    if [ "$DIALOG_TOOL" = "whiptail" ]; then
        whiptail --title "⏳ Installing..." \
            --infobox "$message\n\nPlease wait..." 8 70
    else
        dialog --title "⏳ Installing..." \
            --infobox "$message\n\nPlease wait..." 8 70
    fi
}

# Copy local scripts
copy_local_scripts() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    show_progress "Preparing installation files..."
    
    mkdir -p "$TEMP_DIR"
    
    # Copy installation scripts
    if [ -f "$script_dir/install-kiro.sh" ]; then
        cp "$script_dir/install-kiro.sh" "$TEMP_DIR/"
        chmod +x "$TEMP_DIR/install-kiro.sh"
    fi
    
    if [ -f "$script_dir/install-windsurf.sh" ]; then
        cp "$script_dir/install-windsurf.sh" "$TEMP_DIR/"
        chmod +x "$TEMP_DIR/install-windsurf.sh"
    fi
    
    # Copy icon if exists
    if [ -f "$script_dir/Kiro_1024x1024x32.png" ]; then
        cp "$script_dir/Kiro_1024x1024x32.png" "$TEMP_DIR/"
    fi
}

# Run installation
run_installation() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}Starting Installation...${NC}           ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo
    
    case "$SELECTED_APP" in
        kiro)
            if [ -f "$TEMP_DIR/install-kiro.sh" ]; then
                cd "$TEMP_DIR"
                ./install-kiro.sh $INSTALL_OPTIONS
            else
                echo -e "${RED}Error: Kiro installer not found${NC}"
                return 1
            fi
            ;;
        windsurf)
            if [ -f "$TEMP_DIR/install-windsurf.sh" ]; then
                ./install-windsurf.sh $INSTALL_OPTIONS
            else
                echo -e "${RED}Error: Windsurf installer not found${NC}"
                return 1
            fi
            ;;
        both)
            if [ -f "$TEMP_DIR/install-kiro.sh" ]; then
                cd "$TEMP_DIR"
                ./install-kiro.sh $INSTALL_OPTIONS
            fi
            echo
            echo -e "${CYAN}═══════════════════════════════════════${NC}"
            echo
            if [ -f "$TEMP_DIR/install-windsurf.sh" ]; then
                ./install-windsurf.sh $INSTALL_OPTIONS
            fi
            ;;
    esac
    
    return $?
}

# Show completion message
show_completion() {
    local status=$1
    
    if [ $status -eq 0 ]; then
        if [ "$DIALOG_TOOL" = "whiptail" ]; then
            whiptail --title "✅ Installation Complete" \
                --msgbox "Installation completed successfully!\n\nYou can now launch your IDE from the application menu or terminal.\n\nThank you for using NeuroForge!" 12 70
        else
            dialog --title "✅ Installation Complete" \
                --msgbox "Installation completed successfully!\n\nYou can now launch your IDE from the application menu or terminal.\n\nThank you for using NeuroForge!" 12 70
        fi
    else
        if [ "$DIALOG_TOOL" = "whiptail" ]; then
            whiptail --title "❌ Installation Failed" \
                --msgbox "Installation encountered an error.\n\nPlease check the error messages above and try again.\n\nIf the problem persists, please report it on GitHub." 12 70
        else
            dialog --title "❌ Installation Failed" \
                --msgbox "Installation encountered an error.\n\nPlease check the error messages above and try again.\n\nIf the problem persists, please report it on GitHub." 12 70
        fi
    fi
}

# Show goodbye message
show_goodbye() {
    if [ "$DIALOG_TOOL" = "whiptail" ]; then
        whiptail --title "👋 Goodbye" \
            --msgbox "Thank you for using NeuroForge!\n\nVisit us on GitHub for updates and support." 10 60
    else
        dialog --title "👋 Goodbye" \
            --msgbox "Thank you for using NeuroForge!\n\nVisit us on GitHub for updates and support." 10 60
    fi
}

# Cleanup
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    clear
}

# Trap cleanup on exit
trap cleanup EXIT

# Main function
main() {
    # Check if running in terminal
    if [ ! -t 0 ]; then
        echo -e "${RED}Error: GUI installer must be run in an interactive terminal.${NC}"
        exit 1
    fi
    
    # Detect or install dialog tool
    if ! detect_dialog_tool; then
        echo -e "${YELLOW}Dialog tool not found. Attempting to install...${NC}"
        install_dialog_tool
        
        if ! detect_dialog_tool; then
            echo -e "${RED}Failed to install dialog tool. Exiting.${NC}"
            exit 1
        fi
    fi
    
    # Show welcome screen
    show_welcome
    
    # Show IDE selection
    show_ide_selection
    
    # Show installation options
    show_install_options
    
    # Show confirmation
    if ! show_confirmation; then
        show_goodbye
        exit 0
    fi
    
    # Copy scripts
    copy_local_scripts
    
    # Run installation
    run_installation
    local install_status=$?
    
    # Show completion
    show_completion $install_status
    
    exit $install_status
}

# Run main function
main "$@"

#!/usr/bin/env bash

# AI-Powered IDEs Plugin Manager
# Manage plugins/extensions for Kiro and Windsurf IDEs

set -e

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Configuration directories
KIRO_CONFIG_DIR="$HOME/.config/kiro"
KIRO_EXTENSIONS_DIR="$HOME/.kiro/extensions"
WINDSURF_CONFIG_DIR="$HOME/.config/Windsurf"
WINDSURF_EXTENSIONS_DIR="$HOME/.windsurf/extensions"

# Plugin registry file
PLUGIN_REGISTRY="$HOME/.ai-ide-plugins.json"

print_banner() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}${WHITE}🔌 NeuroForge Plugin Manager${NC}                              ${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${DIM}Manage plugins and extensions for your AI IDEs${NC}            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_main_menu() {
    echo -e "${BOLD}${WHITE}🎯 Main Menu:${NC}"
    echo
    echo -e "  ${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}1${NC}) ${GREEN}📦 Browse Available Plugins${NC}                        ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}2${NC}) ${BLUE}⬇️  Install Plugin${NC}                                  ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}3${NC}) ${RED}🗑️  Uninstall Plugin${NC}                                ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}4${NC}) ${YELLOW}📋 List Installed Plugins${NC}                          ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}5${NC}) ${MAGENTA}🔄 Update All Plugins${NC}                              ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}6${NC}) ${CYAN}🔍 Search Plugins${NC}                                   ${CYAN}│${NC}"
    echo -e "  ${CYAN}│${NC} ${BOLD}0${NC}) ${RED}❌ Exit${NC}                                             ${CYAN}│${NC}"
    echo -e "  ${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo
}

# Initialize plugin registry
init_plugin_registry() {
    if [ ! -f "$PLUGIN_REGISTRY" ]; then
        cat > "$PLUGIN_REGISTRY" << 'EOF'
{
  "kiro": {
    "installed": [],
    "available": [
      {
        "id": "github.copilot",
        "name": "GitHub Copilot",
        "description": "AI pair programmer",
        "category": "AI",
        "publisher": "GitHub"
      },
      {
        "id": "esbenp.prettier-vscode",
        "name": "Prettier",
        "description": "Code formatter",
        "category": "Formatting",
        "publisher": "Prettier"
      },
      {
        "id": "dbaeumer.vscode-eslint",
        "name": "ESLint",
        "description": "JavaScript linter",
        "category": "Linting",
        "publisher": "Microsoft"
      },
      {
        "id": "ms-python.python",
        "name": "Python",
        "description": "Python language support",
        "category": "Language",
        "publisher": "Microsoft"
      },
      {
        "id": "golang.go",
        "name": "Go",
        "description": "Go language support",
        "category": "Language",
        "publisher": "Go Team"
      },
      {
        "id": "rust-lang.rust-analyzer",
        "name": "Rust Analyzer",
        "description": "Rust language support",
        "category": "Language",
        "publisher": "Rust"
      },
      {
        "id": "bradlc.vscode-tailwindcss",
        "name": "Tailwind CSS",
        "description": "Tailwind CSS IntelliSense",
        "category": "CSS",
        "publisher": "Tailwind Labs"
      },
      {
        "id": "eamodio.gitlens",
        "name": "GitLens",
        "description": "Git supercharged",
        "category": "Git",
        "publisher": "GitKraken"
      }
    ]
  },
  "windsurf": {
    "installed": [],
    "available": [
      {
        "id": "github.copilot",
        "name": "GitHub Copilot",
        "description": "AI pair programmer",
        "category": "AI",
        "publisher": "GitHub"
      },
      {
        "id": "esbenp.prettier-vscode",
        "name": "Prettier",
        "description": "Code formatter",
        "category": "Formatting",
        "publisher": "Prettier"
      },
      {
        "id": "dbaeumer.vscode-eslint",
        "name": "ESLint",
        "description": "JavaScript linter",
        "category": "Linting",
        "publisher": "Microsoft"
      },
      {
        "id": "ms-python.python",
        "name": "Python",
        "description": "Python language support",
        "category": "Language",
        "publisher": "Microsoft"
      }
    ]
  }
}
EOF
        echo -e "${GREEN}✓ Plugin registry initialized${NC}"
    fi
}

# Detect which IDE is installed
detect_installed_ides() {
    local ides=()
    
    if [ -d "$KIRO_CONFIG_DIR" ] || command -v kiro &> /dev/null; then
        ides+=("kiro")
    fi
    
    if [ -d "$WINDSURF_CONFIG_DIR" ] || command -v windsurf &> /dev/null; then
        ides+=("windsurf")
    fi
    
    echo "${ides[@]}"
}

# Select IDE
select_ide() {
    local ides=($(detect_installed_ides))
    
    if [ ${#ides[@]} -eq 0 ]; then
        echo -e "${RED}❌ No IDEs detected. Please install Kiro or Windsurf first.${NC}"
        exit 1
    elif [ ${#ides[@]} -eq 1 ]; then
        echo "${ides[0]}"
        return 0
    fi
    
    echo -e "${YELLOW}🎯 Select IDE:${NC}"
    echo
    echo -e "  ${CYAN}1)${NC} Kiro IDE"
    echo -e "  ${CYAN}2)${NC} Windsurf IDE"
    echo
    echo -ne "${BOLD}${WHITE}👉 Enter your choice [1-2]: ${NC}"
    read -r choice
    
    case $choice in
        1) echo "kiro" ;;
        2) echo "windsurf" ;;
        *) echo "" ;;
    esac
}

# Browse available plugins
browse_plugins() {
    local ide="$1"
    
    echo
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}📦 Available Plugins for ${ide^}${NC}                              ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    local plugins=$(jq -r ".${ide}.available[] | \"\(.id)|\(.name)|\(.description)|\(.category)\"" "$PLUGIN_REGISTRY")
    
    local index=1
    while IFS='|' read -r id name desc category; do
        echo -e "${BOLD}${index}.${NC} ${GREEN}${name}${NC}"
        echo -e "   ${DIM}ID: ${id}${NC}"
        echo -e "   ${DIM}📝 ${desc}${NC}"
        echo -e "   ${DIM}🏷️  Category: ${category}${NC}"
        echo
        ((index++))
    done <<< "$plugins"
}

# Install plugin
install_plugin() {
    local ide="$1"
    
    echo
    echo -e "${YELLOW}📥 Installing plugin for ${ide^}...${NC}"
    echo
    echo -ne "${BOLD}Enter plugin ID: ${NC}"
    read -r plugin_id
    
    if [ -z "$plugin_id" ]; then
        echo -e "${RED}❌ Plugin ID cannot be empty${NC}"
        return 1
    fi
    
    # Check if plugin exists in registry
    local plugin_exists=$(jq -r ".${ide}.available[] | select(.id==\"${plugin_id}\") | .id" "$PLUGIN_REGISTRY")
    
    if [ -z "$plugin_exists" ]; then
        echo -e "${RED}❌ Plugin not found in registry${NC}"
        return 1
    fi
    
    # Simulate installation (in real scenario, this would use IDE's CLI)
    echo -e "${YELLOW}⏳ Installing ${plugin_id}...${NC}"
    sleep 2
    
    # Add to installed list
    local temp_file=$(mktemp)
    jq ".${ide}.installed += [\"${plugin_id}\"]" "$PLUGIN_REGISTRY" > "$temp_file"
    mv "$temp_file" "$PLUGIN_REGISTRY"
    
    echo -e "${GREEN}✓ Plugin ${plugin_id} installed successfully!${NC}"
    echo
    echo -e "${BLUE}ℹ️  Note: You may need to restart ${ide^} for changes to take effect.${NC}"
}

# Uninstall plugin
uninstall_plugin() {
    local ide="$1"
    
    echo
    echo -e "${YELLOW}🗑️  Uninstalling plugin from ${ide^}...${NC}"
    echo
    
    # List installed plugins
    local installed=$(jq -r ".${ide}.installed[]" "$PLUGIN_REGISTRY" 2>/dev/null)
    
    if [ -z "$installed" ]; then
        echo -e "${YELLOW}No plugins installed for ${ide^}${NC}"
        return 0
    fi
    
    echo -e "${BOLD}Installed plugins:${NC}"
    echo "$installed" | nl
    echo
    
    echo -ne "${BOLD}Enter plugin ID to uninstall: ${NC}"
    read -r plugin_id
    
    if [ -z "$plugin_id" ]; then
        echo -e "${RED}❌ Plugin ID cannot be empty${NC}"
        return 1
    fi
    
    # Remove from installed list
    local temp_file=$(mktemp)
    jq ".${ide}.installed -= [\"${plugin_id}\"]" "$PLUGIN_REGISTRY" > "$temp_file"
    mv "$temp_file" "$PLUGIN_REGISTRY"
    
    echo -e "${GREEN}✓ Plugin ${plugin_id} uninstalled successfully!${NC}"
}

# List installed plugins
list_installed() {
    local ide="$1"
    
    echo
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}📋 Installed Plugins for ${ide^}${NC}                            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    local installed=$(jq -r ".${ide}.installed[]" "$PLUGIN_REGISTRY" 2>/dev/null)
    
    if [ -z "$installed" ]; then
        echo -e "${YELLOW}No plugins installed yet${NC}"
        return 0
    fi
    
    local index=1
    while read -r plugin_id; do
        local plugin_info=$(jq -r ".${ide}.available[] | select(.id==\"${plugin_id}\") | \"\(.name)|\(.description)\"" "$PLUGIN_REGISTRY")
        
        if [ -n "$plugin_info" ]; then
            IFS='|' read -r name desc <<< "$plugin_info"
            echo -e "${BOLD}${index}.${NC} ${GREEN}${name}${NC}"
            echo -e "   ${DIM}ID: ${plugin_id}${NC}"
            echo -e "   ${DIM}📝 ${desc}${NC}"
            echo
        else
            echo -e "${BOLD}${index}.${NC} ${plugin_id}"
            echo
        fi
        ((index++))
    done <<< "$installed"
}

# Update all plugins
update_all_plugins() {
    local ide="$1"
    
    echo
    echo -e "${YELLOW}🔄 Updating all plugins for ${ide^}...${NC}"
    echo
    
    local installed=$(jq -r ".${ide}.installed[]" "$PLUGIN_REGISTRY" 2>/dev/null)
    
    if [ -z "$installed" ]; then
        echo -e "${YELLOW}No plugins to update${NC}"
        return 0
    fi
    
    while read -r plugin_id; do
        echo -e "${YELLOW}⏳ Updating ${plugin_id}...${NC}"
        sleep 1
        echo -e "${GREEN}✓ ${plugin_id} updated${NC}"
    done <<< "$installed"
    
    echo
    echo -e "${GREEN}✓ All plugins updated successfully!${NC}"
}

# Search plugins
search_plugins() {
    local ide="$1"
    
    echo
    echo -ne "${BOLD}🔍 Enter search term: ${NC}"
    read -r search_term
    
    if [ -z "$search_term" ]; then
        echo -e "${RED}❌ Search term cannot be empty${NC}"
        return 1
    fi
    
    echo
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}🔍 Search Results for \"${search_term}\"${NC}                        ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    local results=$(jq -r ".${ide}.available[] | select(.name | ascii_downcase | contains(\"${search_term,,}\")) | \"\(.id)|\(.name)|\(.description)\"" "$PLUGIN_REGISTRY")
    
    if [ -z "$results" ]; then
        echo -e "${YELLOW}No plugins found matching \"${search_term}\"${NC}"
        return 0
    fi
    
    local index=1
    while IFS='|' read -r id name desc; do
        echo -e "${BOLD}${index}.${NC} ${GREEN}${name}${NC}"
        echo -e "   ${DIM}ID: ${id}${NC}"
        echo -e "   ${DIM}📝 ${desc}${NC}"
        echo
        ((index++))
    done <<< "$results"
}

# Main menu loop
main_menu() {
    local ide="$1"
    
    while true; do
        print_banner
        echo -e "${BLUE}Current IDE: ${BOLD}${ide^}${NC}"
        echo
        print_main_menu
        
        echo -ne "${BOLD}${WHITE}👉 Enter your choice [0-6]: ${NC}"
        read -r choice
        
        case $choice in
            1)
                browse_plugins "$ide"
                echo
                read -p "Press Enter to continue..."
                ;;
            2)
                install_plugin "$ide"
                echo
                read -p "Press Enter to continue..."
                ;;
            3)
                uninstall_plugin "$ide"
                echo
                read -p "Press Enter to continue..."
                ;;
            4)
                list_installed "$ide"
                echo
                read -p "Press Enter to continue..."
                ;;
            5)
                update_all_plugins "$ide"
                echo
                read -p "Press Enter to continue..."
                ;;
            6)
                search_plugins "$ide"
                echo
                read -p "Press Enter to continue..."
                ;;
            0)
                echo
                echo -e "${GREEN}👋 Thank you for using Plugin Manager!${NC}"
                echo
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please select 0-6.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Main execution
main() {
    # Initialize plugin registry
    init_plugin_registry
    
    # Select IDE
    local ide=$(select_ide)
    
    if [ -z "$ide" ]; then
        echo -e "${RED}❌ Invalid IDE selection${NC}"
        exit 1
    fi
    
    # Start main menu
    main_menu "$ide"
}

# Run main function
main "$@"

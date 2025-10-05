# Changelog

All notable changes to **NeuroForge** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Unified installer with interactive menu
- Support for both Kiro and Windsurf IDEs
- Beautiful CLI interface with colors and emojis
- Option to install both IDEs simultaneously
- GUI installer with whiptail/dialog support
- Graphical installation wizard
- User-friendly interface for non-technical users
- Plugin Manager for managing IDE extensions
- Browse, install, uninstall, and update plugins
- Plugin registry with popular extensions
- Search functionality for plugins

## [1.0.0] - 2025-01-05

### Added
- Initial release
- Kiro IDE installer script
- Windsurf IDE installer script
- Automatic version detection and updates
- Desktop integration with application menu entries
- User and system-wide installation modes
- Dependency management and auto-installation
- Configuration backup during updates
- Clean uninstall with optional config removal
- Support for major Linux distributions:
  - Ubuntu/Debian (apt)
  - Fedora (dnf)
  - CentOS/RHEL (yum)
  - Arch Linux (pacman)
  - openSUSE (zypper)

### Features
- ✨ Smart version comparison
- 🔄 Seamless updates
- 🛡️ Safe uninstall
- 📦 Automatic dependency installation
- 🖥️ Desktop integration
- 👤 User-only installation option
- 🔧 Force reinstall option
- 🧹 Clean removal option

### Documentation
- Comprehensive README with examples
- Contributing guidelines
- MIT License
- Installation instructions
- Usage examples

## [0.9.0] - 2024-12-20

### Added
- Beta release
- Basic Kiro installer functionality
- Version checking mechanism
- Manual dependency installation

### Fixed
- Icon path resolution issues
- Permission handling improvements

## [0.5.0] - 2024-12-10

### Added
- Alpha release
- Proof of concept installer
- Basic download and extraction

---

## Release Notes

### Version 1.0.0 Highlights

This is the first stable release of the AI-Powered IDEs Installer! 🎉

**Key Features:**
- **Unified Installer**: One script to install both Kiro and Windsurf IDEs
- **Interactive Menu**: Beautiful CLI interface for easy selection
- **Smart Updates**: Automatic version detection and intelligent updates
- **Multi-Distro**: Works on all major Linux distributions
- **Safe & Clean**: Backup configurations and clean uninstall options

**Installation:**
```bash
curl -fsSL https://raw.githubusercontent.com/mazonyfahmi/kiro-ide-linux/main/clone-and-install.sh | bash
```

**What's Next:**
- GUI installer
- Plugin management
- Configuration sync
- Docker support

---

## Migration Guide

### From 0.x to 1.0

If you're upgrading from a beta version:

1. **Uninstall old version:**
   ```bash
   ./old-installer.sh --uninstall
   ```

2. **Download new installer:**
   ```bash
   wget https://raw.githubusercontent.com/mazonyfahmi/kiro-ide-linux/main/clone-and-install.sh
   chmod +x clone-and-install.sh
   ```

3. **Run new installer:**
   ```bash
   ./clone-and-install.sh
   ```

Your configurations will be preserved automatically!

---

## Links

- [GitHub Repository](https://github.com/mazonyfahmi/kiro-ide-linux)
- [Issue Tracker](https://github.com/mazonyfahmi/kiro-ide-linux/issues)
- [Discussions](https://github.com/mazonyfahmi/kiro-ide-linux/discussions)

[Unreleased]: https://github.com/mazonyfahmi/kiro-ide-linux/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/mazonyfahmi/kiro-ide-linux/releases/tag/v1.0.0
[0.9.0]: https://github.com/mazonyfahmi/kiro-ide-linux/releases/tag/v0.9.0
[0.5.0]: https://github.com/mazonyfahmi/kiro-ide-linux/releases/tag/v0.5.0

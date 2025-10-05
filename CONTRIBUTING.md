# Contributing to AI-Powered IDEs Installer

First off, thank you for considering contributing to this project! 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our commitment to providing a welcoming and inspiring community for all.

### Our Standards

- ✅ Be respectful and inclusive
- ✅ Welcome newcomers and help them learn
- ✅ Focus on what is best for the community
- ✅ Show empathy towards other community members
- ❌ No harassment, trolling, or discriminatory behavior

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **System information** (distro, version, etc.)
- **Relevant logs** or error messages

**Bug Report Template:**

```markdown
## Description
[Clear description of the bug]

## Steps to Reproduce
1. Run command: `...`
2. Select option: `...`
3. See error: `...`

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## System Information
- Distribution: Ubuntu 22.04
- Bash Version: 5.1.16
- Script Version: 1.0.0

## Additional Context
[Any other relevant information]
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Use case** - why is this enhancement useful?
- **Proposed solution** - how should it work?
- **Alternatives considered**

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Test thoroughly** on multiple distributions if possible
4. **Update documentation** if needed
5. **Write clear commit messages**
6. **Submit a pull request**

## 🛠️ Development Setup

### Prerequisites

```bash
# Install development dependencies
sudo apt install shellcheck  # For Ubuntu/Debian
# or
sudo dnf install ShellCheck  # For Fedora
# or
sudo pacman -S shellcheck    # For Arch
```

### Clone and Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/kiro-ide-linux.git
cd kiro-ide-linux

# Add upstream remote
git remote add upstream https://github.com/mazonyfahmi/kiro-ide-linux.git

# Create a feature branch
git checkout -b feature/your-feature-name
```

### Testing Your Changes

```bash
# Make scripts executable
chmod +x *.sh

# Test the main installer
./clone-and-install.sh --help

# Test individual installers
./install-kiro.sh --help
./install-windsurf.sh --help

# Run shellcheck
shellcheck *.sh
```

## 📝 Coding Standards

### Bash Script Guidelines

1. **Use `#!/usr/bin/env bash`** as shebang
2. **Enable strict mode**: `set -e`
3. **Use meaningful variable names**
4. **Add comments** for complex logic
5. **Use functions** for reusable code
6. **Quote variables** to prevent word splitting
7. **Use `local`** for function variables

### Example Code Style

```bash
#!/usr/bin/env bash

set -e

# Function to check dependencies
check_dependencies() {
    local deps=("curl" "git" "jq")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Missing dependencies: ${missing_deps[*]}"
        return 1
    fi
    
    return 0
}
```

### Color Usage

Use consistent color coding:

```bash
RED='\033[0;31m'      # Errors
GREEN='\033[0;32m'    # Success
YELLOW='\033[0;33m'   # Warnings
BLUE='\033[0;34m'     # Info
CYAN='\033[0;36m'     # Headers
NC='\033[0m'          # No Color
```

## 📋 Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(installer): add support for Arch Linux

- Added pacman package manager detection
- Updated dependency installation for Arch
- Tested on Manjaro and Arch Linux

Closes #123
```

```bash
fix(kiro): resolve icon path issue

The icon path was incorrect for user installations.
Changed to use relative path resolution.

Fixes #456
```

## 🔄 Pull Request Process

1. **Update documentation** if you've changed functionality
2. **Add tests** if applicable
3. **Ensure all tests pass**
4. **Update CHANGELOG.md** with your changes
5. **Request review** from maintainers
6. **Address feedback** promptly
7. **Squash commits** if requested

### PR Template

```markdown
## Description
[Clear description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on Ubuntu/Debian
- [ ] Tested on Fedora/RHEL
- [ ] Tested on Arch Linux
- [ ] Tested user installation
- [ ] Tested system installation

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated

## Related Issues
Closes #[issue number]
```

## 🧪 Testing Checklist

Before submitting a PR, test:

- ✅ Fresh installation
- ✅ Update existing installation
- ✅ Force reinstall
- ✅ User-only installation
- ✅ System-wide installation
- ✅ Uninstall (with and without --clean)
- ✅ Different Linux distributions
- ✅ Error handling

## 📚 Additional Resources

- [Bash Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)
- [Git Commit Messages](https://chris.beams.io/posts/git-commit/)

## 💬 Questions?

Feel free to:
- Open a [Discussion](https://github.com/mazonyfahmi/kiro-ide-linux/discussions)
- Ask in an [Issue](https://github.com/mazonyfahmi/kiro-ide-linux/issues)
- Contact maintainers

---

Thank you for contributing! 🙏

# Git-Kraken Installer (non-commercial)

## Overview
A comprehensive, one-click git-Kraken setup tool for Windows and Linux, featuring GitKraken installation and configuration.

## Supported Platforms
- Windows 10/11
- Ubuntu/Debian-based Linux distributions
  
## Tools Installed
- Node.js (Latest LTS)
- Yarn
- Git
- GitKraken
- GitCracken Utility

## Quick Installation

### Windows
```powershell
powershell -Command "iwr https://raw.githubusercontent.com/mdsaif45/gitKraken-installer/refs/heads/main/gitkraken_setup.bat; .\gitkraken_setup.bat"
```

### Linux
```bash
curl -sSL https://raw.githubusercontent.com/mdsaif45/gitKraken-installer/refs/heads/main/quick_dev_installer.sh | sudo bash
```

## What the Script Does
1. Checks for administrative privileges
2. Installs required development tools
3. Configures GitKraken
4. Applies GitCracken patch for non-commercial use

## Credits & Acknowledgments
- Original GitCracken Concept: [fleece-the-flock/GitCracken](https://github.com/fleece-the-flock/GitCracken)
- Inspiration: Open-source community

## Legal Notice
- This tool is for educational and non-commercial purposes
- Use at your own discretion
- Respect software licensing terms

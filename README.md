# brew-sync <!-- omit from toc -->

**Synchronize brew packages across Eric's Macs**

## Table of Contents <!-- omit from toc -->

- [Purpose of Document](#purpose-of-document)
- [Setup Instructions](#setup-instructions)
- [Maintenance Instructions](#maintenance-instructions)
- [Package Removal Instructions](#package-removal-instructions)

## Purpose of Document

This repository houses the list of `brew` packages that Eric uses on his Mac computers. A script is provided that shouold be periodically run (weekly is suggested) to maintain the repository, install status, and update `brew` packages.

## Setup Instructions

### 1. Install brew <!-- omit from toc -->

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
```

### 2. Run these commands <!-- omit from toc -->

```bash
cd ~
gh repo clone elsevers/brew-sync
cd brew-sync
brew bundle install
chmod +x brew-sync.sh
```

## Maintenance Instructions

Run this script periodically (weekly is recommended):

```bash
brew-sync
```

This will:

1. Update and upgrade all brew packages
2. Pull in any new packages added ti git from another computer
3. Commit to git and push up to GitHub any packages install on this computer

## Package Removal Instructions

Removing a package from all Macs in the sync chain requires deliberate effort to prevent `brew-sync.sh` from reinstalling them. To remove packages, do the following:

### 1. On Mac A (The Origin) <!-- omit from toc -->

First, make sure everything is sync'd:
```bash
brew-sync
```

Uninstall the package normally: `brew uninstall <package-name>`

Run the following commands:

```bash
cd ~
rm BrewFile
brew bundle dump -f
git add Brewfile
git commit -m "Remove package(s) from BrewFile"
git push
```

This updates your Brewfile on GitHub so it no longer includes the package.

### 2. On Mac B (The Destination) <!-- omit from toc -->

```bash
cd ~/dotfiles
git pull
brew bundle cleanup --force
```

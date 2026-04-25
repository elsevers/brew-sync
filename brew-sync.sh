#!/bin/bash

# Define the path to your repository
REPO_DIR="$HOME/dotfiles"

# Navigate to the repo or exit if it doesn't exist
cd "$REPO_DIR" || { echo "Repository directory not found!"; exit 1; }

echo "=== Starting Homebrew Maintenance & Sync ==="

# 1. Update Homebrew itself (fetches newest package formulas)
echo "=> Updating Homebrew..."
brew update

# 2. Upgrade all installed packages to their latest versions
echo "=> Upgrading packages..."
brew upgrade

# 3. Clean up old versions and clear cache
echo "=> Cleaning up..."
brew cleanup

# 4. Pull the latest Brewfile from GitHub
echo "=> Pulling latest changes from GitHub..."
# Discard any local uncommitted changes to Brewfile to prevent merge conflicts.
# The system state is our source of truth, so we don't need to save this file.
git restore Brewfile 2>/dev/null || true 
git pull origin main

# 5. Install any new packages that were pulled from the remote repo
echo "=> Installing missing packages from Brewfile..."
brew bundle install

# 6. Dump the new combined state to capture any manual local installs
echo "=> Dumping current state to Brewfile..."
brew bundle dump -f

# 7 & 8. Check for changes, commit, and push
# git status --porcelain checks if the Brewfile was actually modified
if [[ -n $(git status --porcelain Brewfile) ]]; then
    echo "=> Changes detected in Brewfile. Committing to Git..."
    git add Brewfile
    
    # Use a timestamp in the commit message for easy tracking
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
    git commit -m "Auto-sync Brewfile: $TIMESTAMP"
    
    echo "=> Pushing to GitHub..."
    git push origin main
    echo "=== Sync Complete: Changes pushed to GitHub ==="
else
    echo "=== Sync Complete: Brewfile is already up to date. No push needed. ==="
fi

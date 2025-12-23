#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Git Synchronization..."

# 1. Commit Changes on Main (Current)
echo "-----------------------------------"
echo "📦 Staging and Committing on Main..."
git add .
# Commit only if there are changes
if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
else
    git commit -m "Release: Critical Scheduler Fixes & Dashboard Refactor"
    echo "✅ Committed."
fi

# 2. Push Main
echo "-----------------------------------"
echo "⬆️ Pushing Main to GitHub..."
git push origin main
echo "✅ Main Pushed."

# 3. Merge to Dev
echo "-----------------------------------"
echo "🔀 Merging Main into Dev..."
git checkout dev
git pull origin dev # Ensure local dev is up to date
git merge main -m "Merge main (Hotfixes) into dev"

# 4. Push Dev
echo "-----------------------------------"
echo "⬆️ Pushing Dev to GitHub..."
git push origin dev
echo "✅ Dev Pushed."

# 5. Return to Main
echo "-----------------------------------"
echo "🔙 Returning to Main branch..."
git checkout main

echo "-----------------------------------"
echo "🎉 Synchronization Complete!"
echo "Now log in to your Dev Environment and run: git pull origin dev"

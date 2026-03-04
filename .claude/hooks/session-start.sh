#!/bin/bash
set -euo pipefail

# Only run in Claude Code remote (web) environment
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
DASHBOARD_DIR="$PROJECT_DIR/apps/sys/dashboard"
MYJOBS_DIR="$PROJECT_DIR/apps/sys/myjobs"
SHELL_DIR="$PROJECT_DIR/apps/sys/shell"

echo "=== Installing dependencies for deskdesker (Open OnDemand) ==="

# Ensure bundler 2.3.6 is installed (matches Gemfile.lock versions)
gem install bundler -v 2.3.6 --no-document 2>/dev/null || true

# Install Ruby gems for dashboard (include test group for running tests)
echo "--- Installing gems for dashboard ---"
cd "$DASHBOARD_DIR"
bundle _2.3.6_ config set --local without "doc:package"
bundle _2.3.6_ install --jobs 4 --retry 2

# Install Ruby gems for myjobs (include test group for running tests)
echo "--- Installing gems for myjobs ---"
cd "$MYJOBS_DIR"
bundle _2.3.6_ config set --local without "doc:package"
bundle _2.3.6_ install --jobs 4 --retry 2

# Install Node.js dependencies for dashboard
echo "--- Installing npm packages for dashboard ---"
cd "$DASHBOARD_DIR"
npm install

# Install Node.js dependencies for shell
echo "--- Installing npm packages for shell ---"
cd "$SHELL_DIR"
npm install

echo "=== Dependency installation complete ==="

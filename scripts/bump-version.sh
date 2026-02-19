#!/bin/bash
# Bump version across all project files
# Usage: ./scripts/bump-version.sh 3.1.0

set -e

NEW_VERSION="$1"

if [ -z "$NEW_VERSION" ]; then
  echo "Usage: $0 VERSION"
  echo "Example: $0 3.1.0"
  exit 1
fi

# Validate version format (semver)
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Version must be in semver format (e.g., 3.1.0)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Bumping version to $NEW_VERSION..."

# Update SKILL.md metadata.version
sed -i.bak "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/skills/planning-with-files/SKILL.md"
rm -f "$PROJECT_ROOT/skills/planning-with-files/SKILL.md.bak"

# Update plugin.json version
sed -i.bak "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/.claude-plugin/plugin.json"
rm -f "$PROJECT_ROOT/.claude-plugin/plugin.json.bak"

# Update marketplace.json version (both top-level and plugin array)
sed -i.bak "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/" "$PROJECT_ROOT/.claude-plugin/marketplace.json"
rm -f "$PROJECT_ROOT/.claude-plugin/marketplace.json.bak"

echo "Version updated to $NEW_VERSION in:"
echo "  - skills/planning-with-files/SKILL.md"
echo "  - .claude-plugin/plugin.json"
echo "  - .claude-plugin/marketplace.json"
echo ""
echo "Don't forget to commit and tag the release:"
echo "  git add -A"
echo "  git commit -m \"Bump version to $NEW_VERSION\""
echo "  git tag v$NEW_VERSION"
echo "  git push && git push --tags"

#!/bin/bash
# Generate Puppeteer MCP test steps for a feature
# Usage: ./generate-e2e-test.sh <feature-id>
#
# This script generates test steps that can be used with Puppeteer MCP
# for end-to-end testing of a feature

set -e

FEATURE_ID="$1"

if [ -z "$FEATURE_ID" ]; then
    echo "Usage: $0 <feature-id>"
    echo "Example: $0 feature-001"
    exit 1
fi

if [ ! -f "feature_list.json" ]; then
    echo "Error: feature_list.json not found"
    echo "Run /initialize first to set up the project"
    exit 1
fi

# Use Python to generate test steps
python3 - <<EOF
import json
import sys

try:
    with open('feature_list.json', 'r') as f:
        data = json.load(f)
except FileNotFoundError:
    print("Error: feature_list.json not found")
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON in feature_list.json: {e}")
    sys.exit(1)

feature_found = False
for feature in data['features']:
    if feature['id'] == '$FEATURE_ID':
        feature_found = True

        print("# Puppeteer MCP Test Steps")
        print(f"# Feature: {feature['id']}")
        print(f"# Description: {feature['description']}")
        print()

        if not feature.get('steps'):
            print("# No verification steps defined for this feature.")
            print("# Add steps to the feature_list.json to generate test steps.")
        else:
            print("## Prerequisites")
            print("- Ensure development server is running: ./init.sh dev")
            print("- Note the server URL (typically http://localhost:3000 or similar)")
            print()
            print("## Test Steps")
            for i, step in enumerate(feature.get('steps', []), 1):
                print(f"{i}. {step}")

            print()
            print("## Expected Outcome")
            print("- All steps complete successfully")
            print("- Feature behaves as described")
            print("- No errors in console or server logs")

            print()
            print("## After Implementation")
            print("Use Puppeteer MCP to verify:")
            print("1. Navigate to the application")
            print("2. Execute each step above")
            print("3. Verify the expected outcome")
            print("4. Mark feature as passing in feature_list.json")

        sys.exit(0)

if not feature_found:
    print(f"Error: Feature '{FEATURE_ID}' not found in feature_list.json")
    sys.exit(2)
EOF

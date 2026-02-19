#!/bin/bash
# Verify a single feature from feature_list.json
# Usage: ./verify-feature.sh <feature-id>
#
# This script checks a feature's pass status and displays its verification steps

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

# Use Python to parse and display feature info
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
        status = "PASS" if feature.get('passes', False) else "FAIL"
        priority = feature.get('priority', 'medium').upper()
        category = feature.get('category', 'functional').upper()

        print(f"Feature: {feature['id']}")
        print(f"Description: {feature['description']}")
        print(f"Category: {category}")
        print(f"Priority: {priority}")
        print(f"Status: {status}")
        print()
        print("Verification Steps:")
        for i, step in enumerate(feature.get('steps', []), 1):
            print(f"  {i}. {step}")

        if feature.get('notes'):
            print()
            print(f"Notes: {feature['notes']}")

        # Exit code based on pass status
        sys.exit(0 if feature.get('passes', False) else 1)

if not feature_found:
    print(f"Error: Feature '{FEATURE_ID}' not found in feature_list.json")
    sys.exit(2)
EOF

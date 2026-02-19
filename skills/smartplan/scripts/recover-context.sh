#!/bin/bash
# Context Recovery Script for SmartPlan
# Displays current project state to resume work efficiently

echo "=== Context Recovery ==="
echo "Working directory: $(pwd)"
echo ""

echo "=== Recent Git History ==="
git log --oneline -5 2>/dev/null || echo "No git history"
echo ""

echo "=== Current Progress ==="

if [ -f "feature_list.json" ]; then
    # Feature Mode
    if command -v jq &> /dev/null; then
        PROJECT_NAME=$(jq -r '.project' feature_list.json 2>/dev/null)
        TOTAL=$(jq '.features | length' feature_list.json 2>/dev/null)
        COMPLETED=$(jq '[.features[] | select(.status=="passing")] | length' feature_list.json 2>/dev/null)
        IN_PROGRESS=$(jq '[.features[] | select(.status=="in_progress")] | length' feature_list.json 2>/dev/null)
        FAILING=$(jq '[.features[] | select(.status=="failing")] | length' feature_list.json 2>/dev/null)
        PENDING=$(jq '[.features[] | select(.status=="pending")] | length' feature_list.json 2>/dev/null)

        echo "Mode: Feature-based planning"
        echo "Project: ${PROJECT_NAME:-Unknown}"
        echo "Features: ${COMPLETED:-0}/${TOTAL:-0} completed"
        echo "  - In Progress: ${IN_PROGRESS:-0}"
        echo "  - Failing: ${FAILING:-0}"
        echo "  - Pending: ${PENDING:-0}"

        # Show next pending high-priority feature
        NEXT_FEATURE=$(jq -r '.features[] | select(.status=="pending" or .status=="failing") | select(.priority=="high") | "\(.id) - \(.description)"' feature_list.json 2>/dev/null | head -1)
        if [ -n "$NEXT_FEATURE" ]; then
            echo "Next high-priority: $NEXT_FEATURE"
        fi
    else
        echo "Mode: Feature-based planning (jq not installed)"
        echo "Project: $(grep '"project"' feature_list.json | cut -d'"' -f4)"
    fi

elif [ -f "task_plan.md" ]; then
    # Session Mode
    echo "Mode: Session-based planning"
    CURRENT_PHASE=$(grep -A 2 "## Current Phase" task_plan.md 2>/dev/null || echo "No current phase set")
    echo "$CURRENT_PHASE" | head -3

else
    echo "No active planning session found"
    echo "Run /plan to start a new project or task"
fi

echo ""

# Show recent progress log entries if available
if [ -f "claude-progress.txt" ]; then
    echo "=== Recent Progress Log ==="
    head -20 claude-progress.txt
    echo ""
fi

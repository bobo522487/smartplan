#!/bin/bash
# Detect if project should use long-running mode
# Returns: "large" if >20 files or >5k lines of code, "small" otherwise
# Usage: ./detect-project-size.sh

# Count source files by extension
FILE_COUNT=$(find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o \
    -name "*.tsx" -o -name "*.jsx" -o -name "*.java" -o -name "*.go" -o \
    -name "*.rs" -o -name "*.c" -o -name "*.cpp" -o -name "*.cs" \) \
    2>/dev/null | wc -l)

# Count total lines of code
LINE_COUNT=$(find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o \
    -name "*.tsx" -o -name "*.jsx" -o -name "*.java" -o -name "*.go" -o \
    -name "*.rs" -o -name "*.c" -o -name "*.cpp" -o -name "*.cs" \) \
    -exec cat {} + 2>/dev/null | wc -l)

# Default to 0 if no files found
FILE_COUNT=${FILE_COUNT:-0}
LINE_COUNT=${LINE_COUNT:-0}

if [ "$FILE_COUNT" -gt 20 ] || [ "$LINE_COUNT" -gt 5000 ]; then
    echo "large"
else
    echo "small"
fi

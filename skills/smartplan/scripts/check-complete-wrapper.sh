#!/bin/bash
# Cross-platform wrapper for check-complete script
# Called by Stop hook to report task completion status
# Always exits 0 — incomplete task is a normal state

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IS_WINDOWS=0
if [ "${OS-}" = "Windows_NT" ]; then
  IS_WINDOWS=1
else
  UNAME_S="$(uname -s 2>/dev/null || echo '')"
  case "$UNAME_S" in
    CYGWIN*|MINGW*|MSYS*) IS_WINDOWS=1 ;;
  esac
fi

if [ "$IS_WINDOWS" -eq 1 ]; then
  if command -v pwsh >/dev/null 2>&1; then
    pwsh -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1" 2>/dev/null ||
    powershell -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1" 2>/dev/null ||
    sh "$SCRIPT_DIR/check-complete.sh"
  else
    powershell -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1" 2>/dev/null ||
    sh "$SCRIPT_DIR/check-complete.sh"
  fi
else
  sh "$SCRIPT_DIR/check-complete.sh"
fi

exit 0

#!/bin/bash
# Auto-generated init script for project setup
# Usage: ./init.sh [dev|test|stop]

set -e

PROJECT_NAME="{{PROJECT_NAME}}"
ACTION="${1:-dev}}"

case "$ACTION" in
  dev)
    echo "Starting development server for $PROJECT_NAME..."
    # Project-specific commands go here
    # Example: npm run dev, python main.py, etc.
    ;;
  test)
    echo "Running tests..."
    # Test commands go here
    # Example: npm test, pytest, etc.
    ;;
  stop)
    echo "Stopping services..."
    # Stop commands go here
    # Example: killall node, docker-compose down, etc.
    ;;
  *)
    echo "Usage: $0 [dev|test|stop]"
    exit 1
    ;;
esac

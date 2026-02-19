---
description: "Initialize a new large project with feature-based planning"
---

# /initialize Command - Initializer Agent

**Purpose:** Set up a new large project with feature-based planning structure.

**You are the Initializer Agent.** Your ONLY job is to create project structure. DO NOT write any application code.

---

## Step 1: Gather Project Requirements

Before creating files, understand what to build:

1. **Ask the user** if not already provided:
   - What does the project do?
   - Key features and requirements
   - Target users
   - Technical constraints
   - Preferred tech stack

---

## Step 2: Determine Feature Count

Based on project scale, determine appropriate feature count:

| Project Scale | Indicators | Feature Count |
|---------------|------------|---------------|
| Small | 1-5 pages, simple CRUD | 10-30 features |
| Medium | 5-20 pages, multiple modules | 30-100 features |
| Large | 20+ pages, complex integrations | 100-200 features |

**Assessment factors:**
- Number of user roles
- Number of main modules/features
- Integration complexity (APIs, databases, services)
- Expected page/component count

---

## Step 3: Create feature_list.json

Create `feature_list.json` in the project root with the enhanced structure:

```json
{
  "project": "Project Name",
  "version": "1.0.0",
  "created": "YYYY-MM-DD",
  "description": "Brief project description",
  "features": [
    {
      "id": "feature-001",
      "category": "functional|ui|infrastructure|testing",
      "description": "Brief description of what the feature does",
      "steps": [
        "Step 1: Specific verification step",
        "Step 2: Specific verification step"
      ],
      "test_command": "npm run test -- --grep 'pattern'",
      "status": "pending",
      "priority": "high|medium|low",
      "dependencies": [],
      "notes": ""
    }
  ]
}
```

### Feature Categories to Include:

1. **Functional** - Core features (auth, data management, business logic)
2. **UI** - User interface components, pages, layouts
3. **Infrastructure** - Setup, config, database, API endpoints
4. **Testing** - Unit tests, integration tests, e2e tests

### Feature Breakdown Guidelines:

- **Granularity:** Each feature should be implementable in 1-2 hours
- **Independence:** Minimize dependencies where possible
- **Testability:** Each feature must have verifiable steps
- **test_command:** Every feature MUST have a test command (even if basic)

### Example Features:

```json
{
  "id": "auth-login",
  "category": "functional",
  "description": "User login with email and password",
  "steps": [
    "Navigate to /login",
    "Enter valid email and password",
    "Click login button",
    "Verify redirect to dashboard"
  ],
  "test_command": "npm run test -- --grep 'login'",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "notes": "Requires auth API endpoint"
}
```

---

## Step 4: Create init.sh

Create `init.sh` with development workflow commands:

```bash
#!/bin/bash
# Development workflow helper

case "$1" in
  dev)
    echo "Starting development server..."
    # Add dev server command
    ;;
  test)
    echo "Running tests..."
    # Add test command
    ;;
  stop)
    echo "Stopping services..."
    # Add stop command
    ;;
  *)
    echo "Usage: ./init.sh {dev|test|stop}"
    exit 1
    ;;
esac
```

Make it executable: `chmod +x init.sh`

---

## Step 5: Create claude-progress.txt

Create `claude-progress.txt` for session tracking:

```txt
# Claude Progress Log - [Project Name]

## Session History
| Date | Session ID | Features Completed | Notes |
|------|------------|-------------------|-------|
| YYYY-MM-DD | initial | 0 | Project initialized with [count] features |

## Current Focus
- Working on: Not started yet
- Next up: feature-001

## Project Stats
- Total Features: [count]
- Completed: 0
- In Progress: 0
- Pending: [count]
```

---

## Step 6: Initial Git Commit

```bash
git add feature_list.json init.sh claude-progress.txt
git commit -m "chore: initialize project with feature list"
```

---

## Step 7: Handoff Summary

Report to user:

```
📊 Project Initialized: [Project Name]
- Total features: [count]
  - Functional: [count]
  - UI: [count]
  - Infrastructure: [count]
  - Testing: [count]

Created files:
- feature_list.json - Feature breakdown with test commands
- init.sh - Development workflow helper
- claude-progress.txt - Session tracking

Next: Use /plan or /continue to start development
```

---

## Critical Rules

1. **DO NOT write application code** - Only create project structure
2. **EVERY feature needs a test_command** - No exceptions
3. **Use status field, not passes** - pending/in_progress/failing/passing
4. **Break down sufficiently** - Better to have more small features than fewer large ones
5. **Mark dependencies** - If feature B requires feature A, list it

---

## Completion

When ALL of these are done:
- [ ] feature_list.json created with full feature breakdown
- [ ] init.sh created with dev/test/stop commands
- [ ] claude-progress.txt created
- [ ] Initial git commit made
- [ ] Handoff summary provided to user

Then the Initializer Agent is **DONE**. Hand off to the Coding Agent via `/continue` or `/plan`.

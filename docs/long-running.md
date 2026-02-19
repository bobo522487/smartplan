# Long-Running Projects

This guide covers the **feature-based workflow** for projects that span multiple AI sessions.

## When to Use This Mode

Use the long-running mode when:
- Your project has **20+ source files** or **5000+ lines of code**
- You expect to work across **multiple days or sessions**
- The project requires **10-200 distinct features** (scales with project size)
- You need **incremental progress tracking** with testing

## Quick Start

### 1. Initialize Your Project

```
/plan
```

For new large projects, `/plan` automatically routes to the **Initializer Agent** which will:
- Ask about project requirements
- Create `feature_list.json` with all project features
- Create `init.sh` for running the project
- Create `claude-progress.txt` for session tracking
- Make an initial git commit

### 2. Start Coding

```
/plan
```

On subsequent runs (when `feature_list.json` exists), `/plan` automatically routes to the **Coding Agent** which will:
- Run the context recovery sequence (pwd, git log, progress)
- Start development server
- Run smoke tests
- Work on ONE feature at a time
- Test each feature before marking complete
- Commit after each feature

## Dual-Agent Architecture

SmartPlan v3.0+ uses two specialized agents for better focus:

```
┌─────────────────┐
│      /plan      │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Does feature_list.json exist?  │
└────────┬────────────────────────┘
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    │         ▼
    │    ┌─────────────────┐
    │    │ Analyze task    │
    │    │ size/complexity │
    │    └────────┬────────┘
    │             │
    │      ┌──────┴──────┐
    │      │             │
    │   Large         Small
    │      │             │
    ▼      ▼             ▼
┌────────┐ ┌────────┐ ┌──────────┐
│Coding  │ │Initial │ │ Session  │
│Agent   │ │  izer  │ │  Plan    │
└────────┘ └────────┘ └──────────┘
```

### Initializer Agent
**Purpose:** Project setup only (no application code)
- Gathers requirements
- Creates feature list with test commands
- Sets up project files
- Makes initial commit

### Coding Agent
**Purpose:** Incremental feature implementation
- Recovers context from previous sessions
- Implements ONE feature at a time
- Tests before marking complete
- Commits after each feature

## File Structure

```
your-project/
├── feature_list.json      # All features with pass/fail status
├── init.sh                 # Project management script
├── claude-progress.txt     # Session history and progress
└── [your project files]
```

## Feature List Format

```json
{
  "project": "My Project",
  "version": "1.0.0",
  "created": "2026-02-19",
  "description": "Project description",
  "features": [
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
      "notes": ""
    }
  ]
}
```

### Field Changes (v3.0+)

| Old Field | New Field | Values |
|-----------|-----------|--------|
| `passes` (boolean) | `status` (string) | `pending`, `in_progress`, `failing`, `passing` |
| N/A | `test_command` | Test command to verify the feature |
| N/A | `dependencies` | Array of feature IDs this feature depends on |
| N/A | `version` | Project version in metadata |

## Workflow

### Initialization Phase (First Session)

1. Run `/plan` with your project description
2. The **Initializer Agent** will:
   - Ask clarifying questions about requirements
   - Determine appropriate feature count (small: 10-30, medium: 30-100, large: 100-200)
   - Generate `feature_list.json` with test commands
   - Create `init.sh` and `claude-progress.txt`
   - Make initial git commit
3. Review generated `feature_list.json`
4. Test `./init.sh dev` to verify it works

### Coding Phase (Subsequent Sessions)

Each session:
1. Run `/plan` (or `/continue`)
2. The **Coding Agent** automatically:
   - Runs context recovery sequence
   - Reads progress from last session
   - Checks git history
   - Starts development server
   - Runs smoke tests
3. Agent works on ONE feature:
   - Marks `status: "in_progress"`
   - Implements the feature
   - Tests it end-to-end
   - Marks `status: "passing"` only after testing
   - Commits to git
   - Updates progress log

### Context Recovery Sequence

The Coding Agent always starts with this sequence to restore context:

```bash
=== Context Recovery ===
Working directory: [current path]

=== Recent Git History ===
[5 most recent commits]

=== Current Progress ===
Mode: Feature-based planning
Project: [Project Name]
Features: [completed]/[total] completed
  - In Progress: [count]
  - Failing: [count]
  - Pending: [count]
Next high-priority: [feature-id] - [description]

=== Recent Progress Log ===
[last 20 lines of claude-progress.txt]
```

## Critical Rules

### 1. One Feature at a Time
Never work on multiple features simultaneously. Complete one feature fully before starting the next.

### 2. Test Before Marking Complete
The `status: "passing"` means TESTED and VERIFIED. Never mark a feature as passing without running tests.
- Run the `test_command` if provided
- Verify all steps in the `steps` array
- Only mark as "passing" when all checks pass

### 3. Clean Git State
Every completed feature gets its own commit. This makes it easy to revert if needed.

### 4. Don't Remove Features
If a feature is no longer needed, mark it as passing with a note explaining why. Don't delete it from the list.

## Commands Reference

| Command | Description |
|---------|-------------|
| `/plan` | Universal command - routes to appropriate agent based on project state |
| `/continue` | Explicitly invoke Coding Agent (same as `/plan` on existing projects) |

**Note:** The Initializer Agent is invoked automatically by `/plan` for new large projects.

## Helper Scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `recover-context.sh` | Auto-run by PreToolUse hook | Displays context recovery information |
| `verify-feature.sh` | `./verify-feature.sh feature-001` | Check feature status and show verification steps |
| `generate-e2e-test.sh` | `./generate-e2e-test.sh feature-001` | Generate Puppeteer test steps for a feature |
| `detect-project-size.sh` | `./detect-project-size.sh` | Check if project qualifies for long-running mode |

## Session Recovery

The Coding Agent's context recovery sequence runs automatically via the PreToolUse hook before any write/edit/bash operations.

After `/clear` or context loss:
1. Run `/plan` or `/continue`
2. Agent automatically runs recovery sequence:
   - Shows current working directory
   - Displays recent git history
   - Shows feature completion stats
   - Displays recent progress log
3. Agent continues with next incomplete feature

## Best Practices

### Feature Breakdown
- Break features into small, testable units
- Each feature should take 30 minutes to 2 hours
- Include clear verification steps
- Use descriptive IDs (e.g., "auth-login" not "feature-001")

### Priority Levels
- **high**: Core functionality, blocks other features
- **medium**: Important but not blocking
- **low**: Nice-to-have, polish

### Testing
- Write verification steps that can be automated
- Include edge cases in steps
- Test both positive and negative scenarios
- Use Puppeteer MCP for UI testing when available

### Git Hygiene
- Commit messages should reference feature IDs
- Each feature should be one atomic commit
- Use conventional commit format (feat:, fix:, chore:)
- Tag releases when milestones are reached

## Example: Complete Workflow

```bash
# Day 1: Initialize
/initialize
# Answer questions about project
# Review feature_list.json (150 features)
# Test ./init.sh dev
# Check git commit

# Day 1-3: Implementation
/coding-agent
# Agent completes features 1-25 over multiple sessions
# Each session: startup, work on 3-5 features, commit

# Day 4: After context reset
/clear
/coding-agent
# Agent recovers from claude-progress.txt
# Continues with feature 26
```

## Troubleshooting

### Feature list not found
- Run `/initialize` first to set up the project

### Init.sh doesn't work
- Edit the script manually with correct commands
- Test each command before committing

### Agent tries to do too much
- The agent should work on ONE feature at a time
- If it tries to batch features, remind it of the rule

### Tests failing
- Fix tests before marking feature as passing
- Update verification steps if they're incorrect

## Migration from 3-File Pattern

If you started with the 3-file pattern (task_plan.md, findings.md, progress.md):

1. Run `/plan` - the Initializer Agent will create feature_list.json
2. Copy completed phases from task_plan.md to feature_list.json
3. Mark completed features as `status: "passing"`
4. Continue with `/plan` (now routes to Coding Agent)

## Comparison: 3-File vs Feature-Based

| Aspect | 3-File Pattern | Feature-Based |
|--------|----------------|---------------|
| Best for | Small tasks, research | Large applications |
| Duration | Single session | Multiple sessions |
| Tracking | Phases | Individual features |
| Testing | Manual | Test commands per feature |
| Recovery | Session catchup | Progress log + git + context recovery |
| Granularity | 3-7 phases | 10-200 features (scales) |
| Agent Type | Single agent | Dual-agent (Initializer + Coding) |

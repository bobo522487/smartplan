# Long-Running Projects

This guide covers the **feature-based workflow** for projects that span multiple AI sessions.

## When to Use This Mode

Use the long-running mode when:
- Your project has **20+ source files** or **5000+ lines of code**
- You expect to work across **multiple days or sessions**
- The project requires **50-200 distinct features**
- You need **incremental progress tracking** with testing

## Quick Start

### 1. Initialize Your Project

```
/initialize
```

This will:
- Create `feature_list.json` with all project features
- Create `init.sh` for running the project
- Create `claude-progress.txt` for session tracking
- Make an initial git commit

### 2. Start Coding

```
/coding-agent
```

This will:
- Run the startup sequence (check progress, start server, smoke tests)
- Work on ONE feature at a time
- Test each feature before marking complete
- Commit after each feature

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
      "passes": false,
      "priority": "high",
      "notes": ""
    }
  ]
}
```

## Workflow

### Initialization Phase (First Session)

1. Run `/initialize`
2. Provide project description when asked
3. Review generated `feature_list.json`
4. Test `./init.sh dev` to verify it works
5. Check initial git commit was made

### Coding Phase (Subsequent Sessions)

Each session:
1. Run `/coding-agent`
2. Agent automatically:
   - Reads progress from last session
   - Checks git history
   - Starts development server
   - Runs smoke tests
3. Agent works on ONE feature:
   - Implements the feature
   - Tests it end-to-end
   - Marks `passes: true` only after testing
   - Commits to git
   - Updates progress log

## Critical Rules

### 1. One Feature at a Time
Never work on multiple features simultaneously. Complete one feature fully before starting the next.

### 2. Test Before Marking Complete
The `passes` field means TESTED and VERIFIED. Never mark a feature as passing without running tests.

### 3. Clean Git State
Every completed feature gets its own commit. This makes it easy to revert if needed.

### 4. Don't Remove Features
If a feature is no longer needed, mark it as passing with a note explaining why. Don't delete it from the list.

## Commands Reference

| Command | Description |
|---------|-------------|
| `/initialize` | Set up feature_list.json, init.sh, and progress tracking |
| `/coding-agent` | Continue work on next feature with startup sequence |

## Helper Scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `verify-feature.sh` | `./verify-feature.sh feature-001` | Check feature status and show verification steps |
| `generate-e2e-test.sh` | `./generate-e2e-test.sh feature-001` | Generate Puppeteer test steps for a feature |
| `detect-project-size.sh` | `./detect-project-size.sh` | Check if project qualifies for long-running mode |

## Session Recovery

After `/clear` or context loss:
1. Run `/coding-agent`
2. Agent reads `claude-progress.txt` to see what was done
3. Agent checks git commits to verify
4. Agent continues with next incomplete feature

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

1. Run `/initialize` to create feature_list.json
2. Copy completed phases from task_plan.md to feature_list.json
3. Mark completed features as `passes: true`
4. Continue with `/coding-agent`

## Comparison: 3-File vs Feature-Based

| Aspect | 3-File Pattern | Feature-Based |
|--------|----------------|---------------|
| Best for | Small tasks, research | Large applications |
| Duration | Single session | Multiple sessions |
| Tracking | Phases | Individual features |
| Testing | Manual | Automated per feature |
| Recovery | Session catchup | Progress log + git |
| Granularity | 3-7 phases | 50-200 features |

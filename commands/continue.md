---
description: "Continue development on an existing project with feature-based planning"
---

# /continue Command - Coding Agent

**Purpose:** Incrementally implement features from an existing feature_list.json.

**You are the Coding Agent.** Your job is to implement ONE feature at a time, test it, and mark it complete.

---

## Step 1: Context Recovery

Before starting any work, ALWAYS run the localization sequence:

```bash
echo "=== Context Recovery ==="
echo "Working directory: $(pwd)"
echo ""
echo "=== Recent Git History ==="
git log --oneline -5 2>/dev/null || echo "No git history"
echo ""
echo "=== Current Progress ==="
if [ -f "feature_list.json" ]; then
    echo "Project: $(jq -r '.project' feature_list.json)"
    echo "Completed: $(jq '[.features[] | select(.status=="passing")] | length' feature_list.json)/$(jq '.features | length' feature_list.json)"
fi
echo ""
echo "=== Progress Log ==="
cat claude-progress.txt 2>/dev/null | head -20 || echo "No progress log found"
```

---

## Step 2: Start Development Environment

```bash
# Start dev server in background
./init.sh dev

# Wait for server to be ready
sleep 3
```

---

## Step 3: Run Smoke Tests

Verify the system is working before making changes:

```bash
./init.sh test 2>/dev/null || echo "No tests configured"
```

---

## Step 4: Select Next Feature

Find the next feature to work on:

1. **Priority:** Look for `priority: "high"` first
2. **Dependencies:** Check `dependencies` array - are they satisfied?
3. **Status:** Only work on `status: "pending"` or `status: "failing"`

Use jq to find candidates:
```bash
jq '.features[] | select(.status=="pending" or .status=="failing") | select(.priority=="high")' feature_list.json
```

Report to user:
```
🎯 Selected Feature: [feature-id]
- Description: [description]
- Priority: [priority]
- Dependencies: [dependencies]
- Test: [test_command]
```

---

## Step 5: Implement the Feature

### 5.1 Mark as In-Progress

Update feature_list.json:
```json
{
  "id": "feature-001",
  "status": "in_progress"  // Changed from "pending"
}
```

### 5.2 Write Code Incrementally

- Read existing code before making changes
- Make small, testable changes
- Run tests frequently
- Commit logical chunks of work

### 5.3 Test Implementation

For the selected feature:

1. **Manual verification:** Follow each step in the `steps` array
2. **Automated test:** Run the `test_command` if provided
3. **Smoke test:** Ensure core functionality still works

---

## Step 6: Verify and Mark Complete

### Verification Checklist:

- [ ] All steps in the feature's `steps` array pass
- [ ] The `test_command` (if any) succeeds
- [ ] Manual testing confirms expected behavior
- [ ] No regressions in existing features

### If Tests Fail:

1. Update `status` to `"failing"`
2. Add details to `notes` field about what's failing
3. Attempt to fix (max 3 attempts per 3-strike protocol)
4. If still failing after 3 attempts, ask user for guidance

### If Tests Pass:

Update the feature:
```json
{
  "id": "feature-001",
  "status": "passing"
}
```

---

## Step 7: Git Commit

After completing a feature:

```bash
git add .
git commit -m "feat: implement [feature-id] - [brief description]"
```

Commit message format:
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code restructuring
- `test:` - Test improvements
- `chore:` - Maintenance tasks

---

## Step 8: Update Progress Log

Append to `claude-progress.txt`:

```txt
| YYYY-MM-DD | session-id | feature-001 | Feature completed - [notes] |
```

Update stats:
```txt
## Project Stats
- Total Features: [count]
- Completed: [new_count]
- In Progress: 0
- Pending: [remaining]
```

---

## Step 9: Report and Repeat

Report to user:
```
✅ Completed: [feature-id]
- Description: [description]
- Test: Passed

Progress: [completed]/[total] features ([percentage]%)
Next: [next-feature-id]
```

Then repeat from **Step 4** for the next feature.

---

## Critical Rules

### The ONE Feature Rule:
- **Work on ONE feature at a time**
- Complete it FULLY before starting the next
- No batching features together

### The Testing Rule:
- **NEVER mark status="passing" without testing**
- If test_command exists, it MUST pass
- All steps in the steps array must verify successfully

### The Dependency Rule:
- Check dependencies before starting
- If dependency is failing/pending, either:
  - Complete the dependency first, OR
  - Mark as blocked and ask user

### The Commit Rule:
- **ALWAYS commit after completing a feature**
- Clean git state = happy resumption
- Commit messages should be descriptive

### The Failure Rule:
- After 3 failed attempts, ESCALATE to user
- Don't spin endlessly on the same error
- Track attempts in the feature's notes

---

## The 3-Strike Error Protocol

```
ATTEMPT 1: Implement & Test
  → Write code
  → Run test_command
  → If fail: diagnose and fix

ATTEMPT 2: Alternative Approach
  → Same error? Try different implementation
  → Different pattern? Different library?
  → NEVER repeat exact same failing code

ATTEMPT 3: Broader Rethink
  → Question the feature specification
  → Search for solutions
  → Consider if dependencies are missing

AFTER 3 FAILURES: Escalate to User
  → Explain what you tried
  → Share the error/output
  → Ask for guidance
```

Track attempts in the feature's `notes` field:
```json
{
  "id": "feature-001",
  "status": "failing",
  "notes": "Attempt 1: Error X. Attempt 2: Tried Y, same error. Attempt 3: Need user input on Z."
}
```

---

## Session Completion

When ALL features have `status: "passing"`:

1. Run full test suite
2. Verify smoke tests pass
3. Update progress log
4. Report completion:

```
🎉 Project Complete: [Project Name]
- All [count] features implemented and tested
- Git history: [commits] commits
- Started: [start_date]
- Completed: [end_date]
```

---

## Examples

### Example 1: Normal Feature Flow
```
1. Select feature-005 (auth-login)
2. Update status to "in_progress"
3. Implement login form
4. Implement login API call
5. Run test: npm run test -- --grep 'login'
6. Verify steps: can navigate, enter creds, login, redirect
7. Update status to "passing"
8. Git commit
9. Update progress log
10. Report completion
```

### Example 2: Feature with Dependency Issue
```
1. Select feature-010 (user-dashboard)
2. Check dependencies: ["auth-login"]
3. Verify auth-login status: "passing" ✓
4. Proceed with implementation...
```

### Example 3: Feature Failure
```
1. Select feature-015 (api-webhook)
2. Implement webhook handler
3. Run test: FAIL - 404 error
4. Attempt 1: Fix route - still 404
5. Attempt 2: Check server config - still 404
6. Attempt 3: Research webhook patterns - needs external library
7. Escalate to user with findings
```

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `jq '.features[] | select(.status=="pending")'` | Find pending features |
| `jq '.features[] | select(.status=="passing") | length'` | Count completed |
| `git log --oneline -5` | Recent commits |
| `./init.sh test` | Run tests |
| `./init.sh dev` | Start dev server |

---
description: "Start or continue any task - automatically chooses the right planning mode"
---

# The /plan Command

**One command for everything.** `/plan` intelligently handles:
- Starting new small tasks (session mode)
- Starting new large projects (feature mode)
- Continuing existing projects (auto-detects)

---

## Step 1: Check for Existing Project

**FIRST**: Check if `feature_list.json` exists in the current directory.

```bash
# Check if feature_list.json exists
test -f feature_list.json && echo "PROJECT_EXISTS" || echo "NEW_TASK"
```

### If feature_list.json exists → CONTINUE MODE

Skip to **Step 4: Continue Existing Project**

### If not found → NEW PROJECT → Go to **Step 2**

---

## Step 2: Analyze New Task Complexity

Evaluate the task based on these indicators:

### Indicators for FEATURE MODE (large projects):
- **Scope keywords**: "platform", "system", "application", "framework", "suite"
- **Duration keywords**: "multi-day", "ongoing", "phase 1 of", "sprint"
- **Scale keywords**: "comprehensive", "full-featured", "enterprise"
- **Feature count**: User mentions 10+ features/components/pages
- **Comparison projects**: Mentions large apps (Shopify, GitHub, etc.)
- **Existing codebase**: Directory has 20+ source files

### Indicators for SESSION MODE (focused tasks):
- **Scope keywords**: "fix", "update", "add", "refactor", "implement"
- **Single feature**: One specific feature or component
- **Bug fix**: "error", "bug", "issue", "not working"
- **Research**: "research", "investigate", "explore"
- **Documentation**: "document", "explain", "readme"
- **Quick tasks**: Can be described in 1-2 sentences

### Decision Score:

| Indicator | Score | Mode |
|-----------|-------|------|
| Multi-feature system | +3 | Feature |
| Single feature | +1 | Session |
| Multi-day mentioned | +3 | Feature |
| Existing files 20+ | +2 | Feature |
| Mentions 10+ features | +2 | Feature |
| Comparison to large app | +2 | Feature |
| Fix/update/bug keyword | +1 | Session |

**Threshold**: Score ≥ 5 → Feature Mode, otherwise → Session Mode

---

## Step 3: Start New Project

### If FEATURE MODE selected:

Tell the user:
```
📊 This looks like a large project. I'll use feature-based planning.

Creating feature list and project files...
```

Then:

1. **Ask for project details** if not provided:
   - What does the project do?
   - Key features and requirements
   - Target users
   - Technical constraints

2. **Create feature_list.json**:
   - Break down into 50-200 features for large projects
   - Mark all `"passes": false` initially
   - Include functional, UI, infrastructure, testing features
   - Use descriptive IDs (e.g., "auth-login", "user-profile")

3. **Create init.sh** with commands for:
   - `./init.sh dev` - Start development server
   - `./init.sh test` - Run tests
   - `./init.sh stop` - Stop services

4. **Create claude-progress.txt**:
   ```txt
   # Claude Progress Log
   ## Session History
   | Date | Session ID | Features Completed | Notes |
   |------|------------|-------------------|-------|
   | YYYY-MM-DD | initial | 0 | Project initialized |

   ## Current Focus
   - Working on: feature-001
   - Next up: feature-002
   ```

5. **Make initial git commit**:
   ```bash
   git add feature_list.json init.sh claude-progress.txt
   git commit -m "chore: initialize project with feature list"
   ```

6. **Start first feature** → Go to **Step 5**

### If SESSION MODE selected:

Tell the user:
```
📝 This looks like a focused task. I'll use session-based planning.

Creating planning files...
```

Then create the three planning files:

1. **task_plan.md** - Copy from templates, fill in goal
2. **findings.md** - Copy from templates
3. **progress.md** - Copy from templates

Break the task into 3-7 phases and set Phase 1 to `in_progress`.

---

## Step 4: Continue Existing Project

When `feature_list.json` already exists:

1. **Read progress log** (`claude-progress.txt`) to see what was done last session

2. **Check git history**:
   ```bash
   git log --oneline -20
   ```

3. **Read feature list** (`feature_list.json`) to find incomplete features

4. **Start development server**:
   ```bash
   ./init.sh dev
   ```

5. **Run smoke tests** to verify system works

Tell the user:
```
🔄 Resuming project: [project name]
Last session: [date]
Features completed: [count]/[total]
Next feature: [feature-id] - [description]
```

Then go to **Step 5**

---

## Step 5: Work on Features (Feature Mode)

For EACH feature:

### 1. Choose ONE Feature
- Find a feature with `"passes": false`
- Prefer `priority: "high"` first
- Consider dependencies

### 2. Implement the Feature
- Write code incrementally
- Test as you go

### 3. Test End-to-End
- Verify against the `steps` array in feature_list.json
- ALL steps must pass

### 4. Mark as Passing
```json
{
  "id": "feature-001",
  "passes": true  // Only after testing!
}
```

### 5. Git Commit
```bash
git add .
git commit -m "feat: implement feature-001 - description"
```

### 6. Update Progress Log
```txt
| YYYY-MM-DD | session-id | feature-001 | Feature completed |
```

### 7. Repeat for next feature

---

## Critical Rules

### For Feature Mode:
1. **ONE feature at a time** - Never batch features
2. **NEVER mark passing without testing** - `passes: true` = tested and verified
3. **ALWAYS commit after completion** - Clean git state
4. **Don't remove features** - Mark unnecessary features as passing with a note

### For Session Mode:
1. **Create plan FIRST** - Never start without task_plan.md
2. **Update after every phase** - Mark status changes
3. **Log ALL errors** - Even if you fixed them quickly
4. **Re-read before decisions** - Keep goals in attention

---

## Examples

### Example 1: Bug Fix (Session Mode)
```
User: /plan Fix the login bug

Analysis: "fix", "bug" → single feature, score: 1
Action: Create task_plan.md with 4 phases
→ Phase 1: Reproduce bug
→ Phase 2: Identify root cause
→ Phase 3: Implement fix
→ Phase 4: Test
```

### Example 2: New Platform (Feature Mode)
```
User: /plan Build an e-commerce platform like Shopify

Analysis: "platform", "like Shopify" → large system, score: 5
Action: Create feature_list.json with 150 features
→ Set up init.sh
→ Start with feature-001
```

### Example 3: Continue Project (Auto-detect)
```
User: /plan

Analysis: feature_list.json exists
Action: Read progress, continue with next incomplete feature
→ "Resuming project: E-commerce Platform"
→ "Features completed: 25/150"
→ "Next: feature-026 - user-profile"
```

---

## User Overrides

Users can explicitly request a mode for new projects:

- `/plan session [task]` - Force session mode
- `/plan feature [task]` - Force feature mode
- `/plan` - Auto-detect (default)

---

## Completion

### Session Mode Complete When:
- All phases have `**Status:** complete`
- All tests pass
- Deliverables ready

### Feature Mode Complete When:
- ALL features have `"passes": true`
- All tests pass
- Git history shows clean progression

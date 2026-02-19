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

### If feature_list.json exists → USE CODING AGENT

**STOP.** Do NOT proceed with this file.

Instead, read and follow `commands/continue.md` (the Coding Agent prompt).

The Coding Agent will:
1. Recover context using the localization sequence
2. Start development environment
3. Select and implement ONE feature at a time
4. Test, commit, and repeat

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

**STOP.** Do NOT proceed with this file.

Instead, read and follow `commands/initialize.md` (the Initializer Agent prompt).

The Initializer Agent will:
1. Gather project requirements
2. Determine appropriate feature count based on project scale
3. Create `feature_list.json` with enhanced structure
4. Create `init.sh` and `claude-progress.txt`
5. Make initial git commit
6. Hand off to Coding Agent

After initialization is complete, the user will run `/plan` again (which will route to `/continue.md`).

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

**This section is no longer used.** When `feature_list.json` exists, the `/plan` command now routes directly to `commands/continue.md`.

See the **Coding Agent** in `commands/continue.md` for:
- Context recovery sequence
- Feature selection logic
- Implementation workflow
- Testing and verification
- Progress tracking

---

## Legacy Session Mode (for small tasks)

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

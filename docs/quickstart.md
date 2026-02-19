# Quick Start Guide

Just use `/plan` — it handles everything automatically.

---

## How /plan Works

```
/plan
   │
   ├─→ No existing project?
   │     └─→ Analyzes your task
   │          ├─→ Small task? → Creates 3-file plan
   │          └─→ Large project? → Creates feature list
   │
   └─→ Existing project found?
         └─→ Continues where you left off
```

---

## Step 1: Run /plan

Simply type:

```
/plan Your task description here
```

The AI will automatically:
1. Check if you have an existing project (`feature_list.json`)
2. If not, analyze your task complexity
3. Create the appropriate planning files

### Examples:

```bash
# Small task → automatically uses session mode
/plan Fix the login bug

# Large project → automatically uses feature mode
/plan Build an e-commerce platform

# Continue existing project → auto-detects
/plan
```

---

## Step 2: Follow Your Plan

### For Session Mode (3 files)

The AI creates:
- `task_plan.md` — Your phases and progress
- `findings.md` — Research and discoveries
- `progress.md` — Session log

Work through your phases, updating status as you go.

### For Feature Mode (feature list)

The AI creates:
- `feature_list.json` — All features with pass/fail
- `init.sh` — Project management commands
- `claude-progress.txt` — Session history

Work on ONE feature at a time. The AI will:
1. Pick the next high-priority feature
2. Implement and test it
3. Mark it as passing
4. Commit to git
5. Move to the next feature

---

## Step 3: Continue Next Session

Just run `/plan` again.

If `feature_list.json` exists, the AI will:
- Read your progress log
- Check git history
- Start where you left off

---

## Override Automatic Mode

You can force a specific mode:

```bash
/plan session Research topic          # Force session mode
/plan feature Build full application  # Force feature mode
/plan                                  # Auto-detect (default)
```

---

## When to Use Each Mode

| Use Session Mode for | Use Feature Mode for |
|---------------------|---------------------|
| Bug fixes | Full applications |
| Single features | Platforms/systems |
| Research tasks | Projects with 10+ features |
| < 1 hour tasks | Multi-day projects |
| Quick edits | Team projects |

---

## Tips

1. **Let /plan decide** — It's usually right
2. **You can switch modes** — If a task grows, suggest switching to feature mode
3. **Always commit** — Feature mode commits after each feature
4. **Update as you go** — Keep planning files current

---

## Need More Detail?

- [Long-Running Projects](long-running.md) — Feature mode deep dive
- [Installation](installation.md) — Setup instructions

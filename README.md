# SmartPlan

> **One command for intelligent planning** — automatically chooses the right mode for your task.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-green)](https://code.claude.com/docs/en/skills)

## Quick Install

In Claude Code, run:

```
/plugin marketplace add bobo522487/smartplan
/plugin install smartplan@smartplan
```

Or copy the skill locally:

```bash
cp -r skills/smartplan ~/.claude/skills/
```

## Why SmartPlan?

Most AI tasks fall into two categories:

| Task Type | Old Way | SmartPlan |
|-----------|---------|-----------|
| Fix a bug | Start coding, get lost in context | Auto-creates 3-file plan |
| Build a platform | Overwhelmed by scope | Auto-creates feature list |

**SmartPlan detects which mode you need** and sets up the right tracking system automatically.

## One Command for Everything

```
/plan
```

That's it. SmartPlan intelligently handles:

| Situation | What SmartPlan Does |
|-----------|---------------------|
| **New small task** | Creates 3-file plan |
| **New large project** | Creates feature list with 50-200 items |
| **Existing project** | Auto-detects and continues work |

### How It Works

```
┌─────────────────┐
│   /plan         │
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
│Resume  │ │Feature │ │  Session │
│project │ │  list  │ │   plan   │
└────────┘ └────────┘ └──────────┘
```

## Two Planning Modes (Auto-Selected)

### Session Mode → For focused tasks

When: Bug fixes, single features, research, quick tasks

Creates:
- `task_plan.md` — Track phases and progress
- `findings.md` — Store research and discoveries
- `progress.md` — Session log and test results

### Feature Mode → For large projects

When: Multi-file applications, platforms, 10+ features

Creates:
- `feature_list.json` — Track all features with pass/fail status
- `init.sh` — Project management (dev/test/stop)
- `claude-progress.txt` — Session history and progress

## The Core Principle

```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)

→ Anything important gets written to disk.
```

## Usage Examples

```bash
# Start a bug fix → automatically uses session mode
/plan Fix the login bug

# Start a large project → automatically uses feature mode
/plan Build an e-commerce platform

# Continue existing project → auto-detects
/plan

# Force a specific mode
/plan session Research best practices
/plan feature Create a full CMS
```

## Project Structure

```
smartplan/
├── skills/
│   └── smartplan/                 # Main skill
│       ├── SKILL.md               # Skill documentation
│       ├── templates/             # Planning file templates
│       └── scripts/               # Helper scripts
├── commands/                      # Plugin commands
│   └── plan.md                    # The one command you need
├── docs/                          # Documentation
│   ├── quickstart.md
│   └── long-running.md
├── .claude-plugin/                # Plugin manifest
└── README.md
```

## Documentation

- [Quick Start](docs/quickstart.md) — 5-step guide
- [Long-Running Projects](docs/long-running.md) — Feature-based workflow
- [Installation](docs/installation.md) — All installation methods

## License

MIT License — feel free to use, modify, and distribute.

---

**Author:** [bobo](https://github.com/bobo522487)

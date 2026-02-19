# Installation Guide

Complete installation instructions for SmartPlan.

## Quick Install (Recommended)

```bash
/plugin marketplace add bobo522487/smartplan
/plugin install smartplan@smartplan
```

That's it! The skill is now active.

---

## Installation Methods

### 1. Claude Code Plugin (Recommended)

Install directly using the Claude Code CLI:

```bash
/plugin marketplace add bobo522487/smartplan
/plugin install smartplan@smartplan
```

**Advantages:**
- Automatic updates
- Proper hook integration
- Full feature support

---

### 2. Manual Installation

Clone or copy this repository into your project's `.claude/plugins/` directory:

#### Option A: Clone into plugins directory

```bash
mkdir -p .claude/plugins
git clone https://github.com/bobo522487/smartplan.git .claude/plugins/smartplan
```

#### Option B: Add as git submodule

```bash
git submodule add https://github.com/bobo522487/smartplan.git .claude/plugins/smartplan
```

#### Option C: Use --plugin-dir flag

```bash
git clone https://github.com/bobo522487/smartplan.git
claude --plugin-dir ./smartplan
```

---

### 3. Legacy Installation (Skills Only)

If you only want the skill without the full plugin structure:

```bash
git clone https://github.com/bobo522487/smartplan.git
cp -r smartplan/skills/* ~/.claude/skills/
```

---

### 4. One-Line Installer (Skills Only)

Extract just the skill directly into your current directory:

```bash
curl -L https://github.com/bobo522487/smartplan/archive/master.tar.gz | tar -xzv --strip-components=2 "smartplan-master/skills/smartplan"
```

Then move `smartplan/` to `~/.claude/skills/`.

---

## Verifying Installation

After installation, verify the skill is loaded:

1. Start a new Claude Code session
2. Type `/plan` with a task description
3. The AI should create planning files automatically

---

## Updating

### Plugin Installation

```bash
/plugin update smartplan@smartplan
```

### Manual Installation

```bash
cd .claude/plugins/smartplan
git pull origin master
```

### Skills Only

```bash
cd ~/.claude/skills/smartplan
git pull origin master
```

---

## Uninstalling

### Plugin

```bash
/plugin uninstall smartplan@smartplan
```

### Manual

```bash
rm -rf .claude/plugins/smartplan
```

### Skills Only

```bash
rm -rf ~/.claude/skills/smartplan
```

---

## Requirements

- **Claude Code:** v2.1.0 or later (for full hook support)
- **Older versions:** Core functionality works, but hooks may not fire

---

## Platform-Specific Notes

### Windows

The skill works on Windows using PowerShell or Git Bash. The Stop hook automatically detects your environment and uses the appropriate script (`.ps1` or `.sh`).

### Other AI Assistants

SmartPlan is designed for Claude Code but the file-based planning patterns can be used with any AI coding assistant.

---

## Need Help?

If installation fails, open an issue at [github.com/bobo522487/smartplan/issues](https://github.com/bobo522487/smartplan/issues).

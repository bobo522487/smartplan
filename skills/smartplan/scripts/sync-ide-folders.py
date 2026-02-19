#!/usr/bin/env python3
"""
sync-ide-folders.py — Syncs shared files from the canonical source
(skills/planning-with-files/) to IDE-specific folders.

NOTE: This project has been simplified. Only the canonical source in skills/planning-with-files/
is maintained. IDE-specific integration should be done by users as needed.

Run this from the repo root:
    python skills/planning-with-files/scripts/sync-ide-folders.py
"""

import os
import shutil
import sys
import hashlib
from pathlib import Path

# ─── Canonical source ──────────────────────────────────────────────
CANONICAL = Path("skills/planning-with-files")

# ─── Shared source files (relative to CANONICAL) ──────────────────
TEMPLATES = [
    "templates/findings.md",
    "templates/progress.md",
    "templates/task_plan.md",
    "templates/feature_list.json",
    "templates/init.sh",
    "templates/claude-progress.txt",
]

REFERENCES = [
    "examples.md",
    "reference.md",
]

SCRIPTS = [
    "scripts/check-complete.sh",
    "scripts/check-complete.ps1",
    "scripts/init-session.sh",
    "scripts/init-session.ps1",
    "scripts/session-catchup.py",
    "scripts/detect-project-size.sh",
    "scripts/verify-feature.sh",
    "scripts/generate-e2e-test.sh",
]

# ─── Utility functions ─────────────────────────────────────────────

def file_hash(path):
    """Return SHA-256 hash of a file, or None if it doesn't exist."""
    try:
        return hashlib.sha256(Path(path).read_bytes()).hexdigest()
    except FileNotFoundError:
        return None


def main():
    print("Project simplified - no IDE folders to sync.")
    print("Canonical source: skills/planning-with-files/")
    print("\nTo integrate with your IDE, copy files from:")
    print("  - Templates: skills/planning-with-files/templates/")
    print("  - Scripts: skills/planning-with-files/scripts/")
    print("  - SKILL.md: skills/planning-with-files/SKILL.md")


if __name__ == "__main__":
    main()

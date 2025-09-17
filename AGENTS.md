# Agent Instructions - otr-docs

## Purpose

- Keep these notes handy when working on `otr-docs`; each task should tie back to the guidelines below.
- Default to cautious edits: understand existing docs before rewriting, and confirm the impact after changes.
- Prefer incremental commits and clear explanations so other contributors can follow the reasoning.

## Repository Layout

- `docs/`: Source of all published content, organized by topic (e.g., `Development/`, `Rating Framework/`).
- `AGENTS.md`: Agent-facing expectations. Update when processes change.
- `README.md`: Contributor overview and entry points for project context.

## Local Preview

- The published site is generated with Quartz. To preview docs locally, run:

  ```bash
  cd quartz && npx quartz build --serve -d ../docs
  ```

  Visit `http://localhost:8080` while the command is running.

## Editing Workflow

- Start by scanning related pages and backlinks; use `rg` to trace references and keep terminology consistent.
- Keep diffs small and purposeful. When updating navigation or cross-links, apply the change across all affected files.
- Capture rationale for structural edits in commit messages or PR notes so reviewers understand the intent.
- When adjusting generated outputs or data snapshots, note the source command so others can reproduce it.

## Markdown Standards

- Use Obsidian-style links (`[[Page Name]]`), ensuring referenced pages exist or adding a stub.
- Headings use sentence case unless referencing a proper noun. Avoid trailing punctuation in headings.
- Callouts follow Quartz/Obsidian format (`> [!NOTE]`, `> [!WARNING]`, etc.) with four-space indentation for nested content.
- Wrap lines around 100 characters when it aids readability; keep tables tidy and aligned.
- Prefer concise prose and active voice. Eliminate redundant phrasing and keep sections focused.
- Ensure all rules in the "Style Guide.md" file are followed.

## Verification Checklist

- Run `markdownlint-cli2 "docs/**/*.md"` after meaningful documentation edits.
- For link-heavy updates, re-run the local preview and click through new or modified links.
- Before handoff, check `git status` to confirm only intended files are staged or modified.

## Communication

- Surface assumptions, open questions, or skipped verifications in your task response to shorten review cycles.
- Highlight actionable follow-ups when needed; otherwise, close the loop with the information you have.

## Quick Reference

- Preview docs: `cd quartz && npx quartz build --serve -d ../docs`
- Lint markdown: `markdownlint-cli2 "docs/**/*.md"`
- Search project: `rg "term" docs/`
- Check status: `git status -sb`

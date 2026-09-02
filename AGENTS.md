# otr-docs agent guidance

Run commands from the repository root.

- `docs/` is the documentation source of truth; Quartz renders it. Never edit
  under `quartz/` or update the submodule gitlink unless the task is a Quartz
  change.
- Do not commit Obsidian workspace state or editor settings.
- Do not duplicate information another o!TR repository maintains; link to it.

## Commands

- `markdownlint-cli2 <changed files>` matches CI (`.markdownlint-cli2.yaml`).
- `docker build -t otr-docs:local . && docker run --rm -p 8080:8080 otr-docs:local`
  serves the site at `http://localhost:8080`. Check rendered links, callouts,
  headings, code blocks, and navigation when a change affects presentation.

## Authoring

- Read the surrounding document and `docs/Development/Docs/Style Guide.md`
  before broad style changes.
- Third person, concise, searchable, focused on what the reader needs to act.
- Extend the document that owns a topic; create a new one only for a distinct
  navigation destination.
- Preserve `[[wikilinks]]` and callouts such as `[!note]`.
- Changelog entries go under `## Unreleased` in `docs/Changelogs/`, in the
  format of the `2026.08.16` release in `Website Changelog.md`. Never add a
  version or a date.
- A changelog branch is named `changelog/<repo>-<pr>`.

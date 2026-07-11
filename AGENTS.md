# AGENTS.md

## Repository purpose

This repository contains the public documentation for the osu! Tournament
Rating platform. Source documents are Obsidian-compatible Markdown under
`docs/`; Quartz renders them for the documentation site.

## Ownership boundary

- Treat `docs/` as the documentation source of truth. Add or edit content there,
  never under `quartz/docs` or another Quartz path.
- `quartz/` is a Git submodule used only to render and deploy the site. Do not
  modify the submodule or update its gitlink unless the task explicitly requests
  a Quartz change.
- Do not commit personal Obsidian workspace state or editor settings.

## Authoring

- Read the surrounding document and `docs/Development/Contribution Guide.md`
  before making broad style changes.
- Write in the third person and keep prose concise, informative, searchable, and
  focused on what the reader needs to act.
- Prefer extending an existing document when it already owns the topic. Create a
  new document only when the subject needs a distinct navigation destination.
- Preserve the repository's Obsidian conventions, including `[[wikilinks]]` and
  callouts such as `[!note]`, when editing nearby content.
- Keep headings descriptive, fenced examples readable, and links valid. Do not
  duplicate information that is maintained by another o!TR repository; link to
  the authoritative source when practical.

## Validation

- Run Markdown lint for changed documents. CI uses `markdownlint-cli2` with
  `.markdownlint-cli2.yaml` and checks changed Markdown files in pull requests.
- For content or navigation changes, build and serve the site from the repository
  root: `docker build -t otr-docs:local .` followed by
  `docker run --rm -p 8080:8080 otr-docs:local`.
- Inspect rendered links, callouts, headings, code blocks, and navigation at
  `http://localhost:8080` when the presentation could have changed.

## Git conventions

```text
Branch: <short-kebab-case-description>

Commit:
<Imperative verb> <specific outcome>

<Optional explanation of why, compatibility impact, or validation details>

Refs #<issue>  # optional
```

- Branch names use two to five meaningful lowercase kebab-case terms, such as
  `agent-skills-refactor`, `rating-decay-window`, or `player-layout-fix`.
- Do not require `feature/`, `fix/`, `hotfix/`, `chore/`, usernames, vendors, or
  issue numbers.
- Tool-generated, Dependabot, upstream-sync, and scratch-worktree branches are
  exceptions.
- Commit subjects use sentence case and imperative mood, preferably at most 72
  characters, without a trailing period or Conventional Commit prefix.
- Avoid opaque subjects such as `fmt`, `prettier`, `cleanup`, or `(wip)`.
- Let GitHub add pull request numbers and merge metadata.

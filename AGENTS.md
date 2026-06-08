# AGENTS.md

The otr-docs repository contains documentation for the osu! Tournament Rating platform. Documents are written in obsidian-compatible markdown files and are rendered using quartz.

## Scripts

- Build and serve through docker: `docker build -t otr-docs:local . && docker run -p 8080:8080 otr-docs:local`

## Style guide

- Search for our style guide and follow it when authoring new docs.
- Format with markdown lint.

## Rules

- Write in the third person.
- Avoid explaining too much, prefer terse language.
- For technical documents, stick to what is most important for the end user.
- Documents must always be informative, easy to search for, and easy to digest.
- Prefer expanding existing documents instead of creating new ones, unless the content truly belongs in a new file.

## Notes

- Do not modify the quartz directory unless explicitly told to do so.
- Docs live in ./docs, not ./quartz/docs.


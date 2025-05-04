---
tags:
  - internal
  - application
---

The o!TR team maintains auto-generated wrappers which enable connectivity to the [[Applications/API/Overview|o!TR API]].

These clients are hosted on GitHub [here](https://github.com/osu-tournament-rating/otr-api-clients).

# Languages

The following languages are supported:

- TypeScript

# Regenerate and Deploy

> [!note]
> This is non-sensitive internal documentation meant for use by the [[Team|o!TR Team]].

This document outlines the process for regenerating and deploying API clients for the o!TR API. Currently, deployments are handled manually.

## Prerequisites

- A working [[Applications/API/Overview|o!TR API]] instance running locally.
- [npm](https://www.npmjs.com/)
- [NSwag](https://github.com/RicoSuter/NSwag) (`npm install nswag -g` recommended)

1. Launch the [[Applications/API/Overview|o!TR API]].

> [!note]
> Ensure that `ASPNETCORE_ENVIRONMENT=Development` is configured to launch swagger.
> See the [[Applications/API/Getting Started#Environment variables|setup documentation]] for more information.

2. From the Swagger UI, download the `swagger.json` file and replace the existing file in the root directory of the repository.

3. In the root directory of the repository, run `nswag run`.

## npm

Run and build:

```
cd ./src/ts
npm i
npm run build
npm run format
```

Publish:

```
npm login
npm version patch
npm publish
```

After these steps, commit and push any changes to the `master` branch.

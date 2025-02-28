# Regenerate & Deploy

This document outlines the process for regenerating and deploying API clients for the o!TR API. Currently, deployments are handled manually.

## Prerequisites

* A working [o!TR API](o-TR-API.md) instance running locally.
* [npm](https://www.npmjs.com/)
* [NSwag](https://github.com/RicoSuter/NSwag) (`npm install nswag -g` recommended)

<procedure>
<step>
Launch the <a href="o-TR-API.md">o!TR API</a> (ensure <code>Development</code> environment is configured)
</step>
<step>
From the Swagger UI, download the <code>swagger.json</code> file and replace the existing file in the root directory of the repository.
</step>
<step>
In the root directory of the repository, run <code>nswag run</code>.
</step>
</procedure>

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
git push
```
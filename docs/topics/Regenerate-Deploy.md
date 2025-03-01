# Regenerate & Deploy

> This is non-sensitive internal documentation meant for use by the [o!TR Team](Team.md).

This document outlines the process for regenerating and deploying API clients for the o!TR API. Currently, deployments are handled manually.

## Prerequisites

* A working [](o-TR-API.md) instance running locally.
* [npm](https://www.npmjs.com/)
* [NSwag](https://github.com/RicoSuter/NSwag) (`npm install nswag -g` recommended)

<procedure>
<step>
Launch the <a href="o-TR-API.md"/>

<tip>
Ensure that <code>ASPNETCORE_ENVIRONMENT=Development</code> is configured to launch swagger.
See the <a href="Development.md">setup documentation</a> for more information.
</tip>
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
```

After these steps, commit and push any changes to the `master` branch.
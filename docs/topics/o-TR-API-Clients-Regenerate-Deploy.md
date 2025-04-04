# Regenerate & Deploy

> [!note]
>  This is non-sensitive internal documentation meant for use by the [[Team | o!TR Team]].

This document outlines the process for regenerating and deploying API clients for the o!TR API. Currently, deployments are handled manually.

## Prerequisites

* A working [[o-TR-API | o!TR API]] instance running locally.
* [npm](https://www.npmjs.com/)
* [NSwag](https://github.com/RicoSuter/NSwag) (`npm install nswag -g` recommended)

1. Launch the [[o-TR-API | o!TR API]]

   > [!note] 
   > Ensure that `ASPNETCORE_ENVIRONMENT=Development` is configured to launch swagger.
   > See the [[o-TR-API-Development | setup documentation]] for more information.

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
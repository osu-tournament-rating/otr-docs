o!TR Web is a [NextJS](https://nextjs.org/) frontend where end users can interact with data provided by the [[Applications/API/Overview|API]].

The `otr-web` repository can be viewed [here](https://github.com/osu-tournament-rating/otr-web).

## Prerequisites

o!TR Web depends on the API for all web requests. By extension, the database will need to be configured as well. Ensure these processes are running in the background before running o!TR Web:

- [[Applications/API/Overview|o!TR API]]
- [Node.js](https://nodejs.org/en) (v21 or later)

## Environment configuration

o!TR Web comes with a `.env.example` file. This file configures variables that the program needs in order to run.

Configure the `.env` file:

1. Rename `.env.example` to `.env`. It should now be identical to [this file](https://github.com/osu-tournament-rating/otr-web/blob/master/.env.example). By default, this configuration will work in development.

> [!note]
> The `IS_RESTRICTED_ENV` flag is used to determine whether the environment should be accessible by users without the `whitelist` role. This is used so end users cannot access our staging environment.

Once the `.env` file is made, install all packages:

- `npm i --legacy-peer-deps`

Then start the application:

- `npm run dev`

The website should now be accessible at `http://localhost:3000`. Ensure the [[Applications/API/Overview|API]] is configured and running in the background in order to serve data, sign in, and so on.

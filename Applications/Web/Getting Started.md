o!TR Web is a [NextJS](https://nextjs.org/) application that serves as a website for users to interact with.

The repository can be viewed [here](https://github.com/osu-tournament-rating/otr-web).

# Prerequisites

o!TR Web depends on the API for all web requests. By extension, the database will need to be configured as well. Ensure these processes are running in the background before running o!TR Web:

* [[Applications/API/Overview|o!TR API]]
* [Node.js](https://nodejs.org/en) (v21 or later)

## Environment configuration

o!TR Web comes with a `.env.example` file. This file configures variables that the program needs in order to run.

Configure the `.env` file:
  
1. Rename `.env.example` to `.env`. It should now look like this:

   ```
   OSU_CLIENT_ID=
   AUTH_SECRET=
   OTR_API_ROOT=
   ```

2. Copy your osu! oAuth client ID and set `OSU_CLIENT_ID` equal to that value.

   > [!note] 
> The API instance must also be using the same client ID.
> 
> This must be the same client used in your running instance of the API.

3. Set `AUTH_SECRET` to any string that is at least 32 characters in length.

   > [!warning]
> This should be a secure string in production. This is the encryption key for session cookies.

4. Set `OTR_API_ROOT` to `http://localhost:5075`. The API runs on port `5075` by default.

Once these values are configured, install the npm packages and run the application:

* `npm i`
* `npm run dev`

The website should now be accessible at `http://localhost:3000`.

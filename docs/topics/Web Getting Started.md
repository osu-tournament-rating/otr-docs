# Prerequisites

o!TR Web depends on the API for all web requests. By extension, the database will need to be configured as well. Ensure these processes are running in the background before running o!TR Web:

* [[o-TR-API|o!TR API]]
* [Node.js](https://nodejs.org/en) (v21 or later)

## Environment configuration

o!TR Web comes with a `.env.example` file. This file configures variables that the program needs in order to run.

Configure the `.env` file:
  
1. Rename `.env.example` to `.env`. It should now look like this:
   
```   
REACT_APP_OSU_CLIENT_ID=
REACT_APP_OSU_CALLBACK_URL=
REACT_APP_API_URL=
REACT_APP_ORIGIN_URL=
SESSION_SECRET=
NODE_ENV= 
```

2. Copy your osu! API v2 client id and set `REACT_APP_OSU_CLIENT_ID` equal to that value.

> [!note] 
> The API instance must also be using the same client id.
> 
> This must be the same client used in your running instance of the API.

3. Set `REACT_APP_OSU_CALLBACK_URL` to `http://localhost:3000/auth`. The web server runs on port `3000` by default.

   > [!note] 
> Ensure this value is included as a callback URL on the osu! API client.

4. Set `REACT_APP_API_URL` to `http://localhost:5075/api/v1`. The API runs on port `5075` by default.

5. Set `REACT_APP_ORIGIN_URL` to `http://localhost:3000`.

6. Set `SESSION_SECRET` to any string that is at least 32 characters in length.

> [!warning]
> This should be a secure string in production. This is the encryption key for session cookies.

7. Set `NODE_ENV` to `development`.

Once these values are configured, install the npm packages and run the application:

* `npm i`
* `npm run dev`

The website should now be accessible at `http://localhost:3000`.

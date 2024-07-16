# Getting Started

## Prerequisites

o!TR Web depends on the API for all web requests. By extension, the database will need to be configured as well. Ensure these processes are running in the background before running o!TR Web:

* [o!TR API](o-TR-API.md)
* [Node.js](https://nodejs.org/en) (v21 or later)

## Environment configuration

o!TR Web comes with a `.env.example` file. This file configures variables that the program needs in order to run.

Configure the `.env` file:

<procedure>
<step>
Rename <code>.env.example</code> to <code>.env</code>. It should now look like this:
<code-block>
REACT_APP_OSU_CLIENT_ID=
REACT_APP_OSU_CALLBACK_URL=
REACT_APP_API_URL=
REACT_APP_ORIGIN_URL=
SESSION_SECRET=
NODE_ENV=
</code-block>
</step>
<step>
Copy your osu! API v2 client id and set <code>REACT_APP_OSU_CLIENT_ID</code> equal to that value.
</step>
<note>
This must be the same client used in your running instance of the API.
</note>
<step>
Set <code>REACT_APP_OSU_CALLBACK_URL</code> to <code>http://localhost:3000/auth</code>. The web server runs on port <code>3000</code> by default.
<tip>
Ensure this value is included as a callback URL on the osu! API client.
</tip>
</step>
<step>
Set <code>REACT_APP_API_URL</code> to <code>http://localhost:5075/api/v1</code>. The API runs on port <code>5075</code> by default.
</step>
<step>
Set <code>REACT_APP_ORIGIN_URL</code> to <code>http://localhost:3000</code>.
</step>
<step>
Set <code>SESSION_SECRET</code> to any string that is at least 32 characters in length.
<tip>
This should be a secure string in production. This is the encryption key for session cookies.
</tip>
</step>
<step>
Set <code>NODE_ENV</code> to <code>development</code>.
</step>
</procedure>

Once these values are configured, install the npm packages and run the application:

* `npm i`
* `npm run dev`

The website should now be accessible at `http://localhost:3000`.
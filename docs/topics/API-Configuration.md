# API Configuration

Configure the o!TR API with configuration files.

## Configuration file

Duplicate the `example.appsettings.json` file and rename to `appsettings.Development.json`. Configure the fields as described below.

> Ensure the file is located in the `API` project folder (the same folder which contains `API.csproj`).
>

## Configuration Sections

### Connection Strings

1. `DefaultConnection`
    - The `DefaultConnection` connection string format is as follows:
        - `"Server=<domain>;Port=<port>;User Id=<postgres_user>;Password=<postgres_password>;Include Error Detail=true;"`.
        - Note that this is for a PostgreSQL database instance.
    - An example connection string for local development would look like:
      `"Server=localhost;Port=5432;User Id=postgres;Password=otrdev;Include Error Detail=true;"`
    - If running via docker compose, the connection string is written as follows:
      `"Server=<container_name>;Port=<host_port>;User Id=<username>;Password=<password>;"`
2. `CollectorConnection`
    - This connection string is only used in production. However, a URL must be specified regardless. It is fine to use a dummy value, such as `"http://localhost:1234"` for this value (even if nothing is running on it).
3. `Redis`
    - The Redis connection string must be written exactly as follows, assuming Redis is running on port `6379`: `"localhost:6379"`.

If running via docker compose, replace `localhost` with the Redis container name.

### Osu

> If you have not already done so, you must [create an osu! account](https://osu.ppy.sh/wiki/en/Registration) and create an API v2 client.
>
> - [Documentation](https://osu.ppy.sh/wiki/en/osu%21api)
> - [Reference](https://osu.ppy.sh/docs/index.html)

1. `ClientId`
    - The ID of your osu! API v2 client.
2. `ClientSecret`
    - The secret of your API v2 client.

<procedure collapsible="true" default-state="collapsed" title="Further osu! API setup instructions">
   <step>
      Create the client (found in the <a href="https://osu.ppy.sh/home/account/edit">osu! account settings page</a>) <img src="new-oauth-app.png" alt="New OAuth app setup"/>
   </step> 
   <step>
      Set the fields
      <tip>This callback URL is used for otr-web setup</tip>
      <img src="new-oauth-app-fields.png" alt="New OAuth app fields"/>
   </step>
   <step>
      Sample fields <img src="sample-oauth-app.png" alt="Sample OAuth app with fields"/>
   </step>
</procedure>

### JWT

1. `Key`
    - The secret the API uses to encode and decode JSON Web Tokens. This can be set to any string in development, but must be a randomized secret in production.

2. `Audience`
    - The intended recipient of the JWT. This can be set to any string for development purposes, but in production should be the intended resource server, such as `https://some.production.api.url`.

3. `Issuer`
   - Defines who issues the JWT. This can be any string in development, but should be set to a proper resource in production.

### Auth

1. `EnforceWhitelist`
   - Whether to restrict web access to `User`s with the `whitelist` scope. Will be obsolete after the public beta is released.

### Rate Limit

1. `PermitLimit`
   - The `PermitLimit` field is the default number of requests allotted to each authenticated user or client. Default is `60`.
2. Window
   - The `Window` field represents the default rate limit refresh period (in seconds). Default is `60`.
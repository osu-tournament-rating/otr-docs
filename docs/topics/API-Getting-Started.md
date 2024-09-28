# Getting Started

## Prerequisites

* Install [.NET 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
* Install [Docker](https://www.docker.com/)

## Setup

### Clone

```Shell
git clone https://github.com/osu-tournament-rating/otr-api.git
```

### Install Entity Framework

```
dotnet tool install --global dotnet-ef
```

### Set up a PostgreSQL Database

Follow [this guide](Database-Setup-Backup-and-Recovery.md) to set up your local database.

> The database container must be running for the API to function.

### Set up Redis

Run the following command:

`docker run -d -p 6379:6379 --name otr-redis redis`

> The redis container must be running for the API to function.

## Run the API

With a fresh PostgreSQL database instance and other required frameworks installed, the API can now be built and configured.

### Test

Run the following in the root directory of the repository:

```Shell
dotnet test
```

You should see that all tests have passed. Report any build errors or test failures to the project maintainers (assuming you have not modified anything locally and are testing against the `master` branch).

![tests_passing.png](tests_passing.png)

### Environment variables

Ensure the `ASPNETCORE_ENVIRONMENT=Development` environment variable is set while developing/debugging. Most IDEs / run configurations will do this for you.

### Recommended IDE

We prefer [Jetbrains Rider](https://www.jetbrains.com/rider/) as the IDE of choice for developing this project, though [Visual Studio Code](https://code.visualstudio.com/) and [Visual Studio](https://visualstudio.microsoft.com/) will work fine.

### Configuration file

Your configuration file should look like [this](https://github.com/osu-tournament-rating/otr-api/blob/master/API/example.appsettings.json). Rename the file to `appsettings.Development.json` and fill in the empty values as defined in the [configuration fields](#configuration-fields) section.

> Ensure the file is located in the `API` project folder (the same folder which contains `API.csproj`).
> 

## Configuration fields

### Rate Limit

1. `PermitLimit`
   - The `PermitLimit` field is the default number of requests allotted to each authenticated user or client. Default is `60`.
2. Window
   - The `Window` field represents the default rate limit refresh period (in seconds). Default is `60`.

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
   - Set the `ClientId` field to the ID of your osu! API v2 client.
2. `ClientSecret`
   - Set the `ClientSecret` field to the secret of your API v2 client.

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

### Jwt

1. `Key`
   - The `Key` field is the secret the API uses to encode and decode JSON Web Tokens. This can be set to any string in development, but must be a randomized secret in production.

2. `Audience`
   - The `Audience` field refers to the intended recipient of the JWT. This can be set to any string for development purposes, but in production should be the intended resource server, such as `https://some.production.api.url`.
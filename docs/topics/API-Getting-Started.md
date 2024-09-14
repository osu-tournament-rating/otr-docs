# Getting Started

## Prerequisites

* [.NET 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
* [Docker](https://www.docker.com/)

## Setup

### Clone

```Shell
git clone https://github.com/osu-tournament-rating/otr-api.git
```

### Install Entity Framework

```
dotnet tool install --global dotnet-ef
```

### Setting up a PostgreSQL Database

Follow [this guide](Database-Setup-Backup-and-Recovery.md) to setup your local database. Make sure this docker container is always running before you launch the API.

### Setting up Redis

Run the following command:

`docker run -d -p 6379:6379 --name otr-redis redis`

### Configuring the API

With a fresh PostgreSQL database instance and other required frameworks installed, the API can now be built and configured.

Create a config file at `otr-api/API/appsettings.Development.json`. Fill in the values from the `example.appsettings.json` template (a reference is included below). This will serve as your configuration file for development (so long as )

### Configuration file

Your configuration file should look like [this](https://github.com/osu-tournament-rating/otr-api/blob/master/API/example.appsettings.json). Fill in the empty values as defined in the next section.

### Configuration fields

#### Rate Limit

The `PermitLimit` field is the default number of requests allotted to each authenticated user or client.

The `Window` field represents the default rate limit refresh period (in seconds).

#### Connection Strings

**DefaultConnection:**

The `DefaultConnection` connection string format is as follows:\
`"Server=<domain>;Port=<port>;User Id=<postgres_user>;Password=<postgres_password>;Include Error Detail=true;"`. Note that this is for a PostgreSQL database instance.

An example connection string for local development would look like:\
`"Server=localhost;Port=5432;User Id=postgres;Password=otrdev;Include Error Detail=true;"`

**CollectorConnection:**

* This connection string is only used in production. However, a URL must be specified regardless. It is fine to use a dummy value, such as `"http://localhost1234"` for this value.

**Redis:**

* The Redis connection string must be written exactly as follows, assuming Redis is running on port `6379`: `"localhost:6379"`.

#### Osu

Currently the configuration requires both an osu! API v1 key and v2 OAuth2 credentials, however the use of the v1 API will be phased out very soon. When creating the OAuth2 client, the redirect URL is optional. If testing alongside `otr-web`, set the redirect URL to `http://localhost:3000/auth`.

#### Jwt

The `Key` field is the secret the API uses to encode and decode JSON Web Tokens. This can be set to any string.

The `Audience` field refers to the intended recipient of the JWT. This can be set to any string for development purposes, but in production should be the intended resource server, such as `https://some.production.api.url`.

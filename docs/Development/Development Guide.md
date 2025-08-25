Want to setup the o!TR tools for development? You're in the right place!

## Overview

This document covers:

- Setting up all codebases locally for all core projects (`otr-api/API` ("API"), `otr-api/DWS` ("Data Worker Service", "DWS"), `otr-web` ("web", "website"), `otr-processor` ("processor"))
- What these applications do, at a high level
- Configuring all necessary environment variables
- Working with background services conveniently (database, redis, RabbitMQ)
- Tips from the maintainers

By the end of this guide, you will be able to run and debug all of our software. The author of this guide is also the lead maintainer and it details exactly how to replicate the same setup. If you haven't already done so, read through [[Platform Architecture]] to understand how each application is designed and how the data flows between applications.

While it is recommended to setup everything, you can skip some application setup depending on your use case:

- If you are only interested in web development, you will still need to run everything besides the processor.
- If you are only interested in generating rating outputs to the database directly, you can run the processor without RabbitMQ, though stats will not be generated.

## Local Development

This section covers each step required to get started with running and debugging platform code. Here's a high level overview of what needs to be done to get started with local development:

- Install all prerequisites
- Clone relevant repositories
- Setup necessary configuration files
- Use `docker compose` to conveniently manage the database, redis, and RabbitMQ

### Prerequisites

- Install [git](https://git-scm.com/downloads)
- Install [Docker](https://www.docker.com/)
- Install [.NET 9](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
- Install the latest LTS version of [Node](https://nodejs.org/en/download)
- Download the latest available [public replica](https://data.otr.stagec.xyz/)

To get started with local development, start by cloning each repository. It's recommended to make an `otr/` folder for organization of these projects:

> [!important]
> If you are a maintainer, you can clone and commit to the main repositories (using branches). **If you are not a maintainer, you must create a fork** of each repository before cloning.

Clone the `otr-api`,  `otr-web` and `otr-processor` repositories.

```
mkdir -p (your-directory)/otr
cd (your-directory)/otr

git clone https://github.com/osu-tournament-rating/otr-api.git
git clone https://github.com/osu-tournament-rating/otr-web.git
git clone https://github.com/osu-tournament-rating/otr-processor.git
```

### Database, Redis, and RabbitMQ

The easiest part to setup is each of these three tools. They will run in the background and will be kept alive so long as Docker is running on the host machine.

#### Configuration

Navigate to the `otr-api/cfg` directory and copy the template `.env` files:

```
cp db.env.example db.env
cp rabbitmq.env.example rabbitmq.env
```

Replace the content of `db.env` with `POSTGRES_PASSWORD=password`. No modifications to `rabbitmq.env` are necessary, and redis does not have any configuration.

#### Run

Run these three tools by running `docker compose --profile staging up db redis rabbitmq -d`. You should see something like this screenshot. If you don't, follow these steps again carefully, or [[Contact|contact us]] in Discord for assistance.

![[Screenshot_20250824_134335.png]]

>[!note]
> This is a PostgreSQL database, please ensure your database browser supports this.

#### Database Import

Once the `db` container is running, import the downloaded database dump with the following command:

```shell
gunzip -c /path/to/replica.gz | docker exec -i db bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

### API Configuration

Next up is the API. Dotnet uses the `appsettings.json` file format, the `.env` format is reserved for production use, so feel free to ignore it.

Create an `appsettings.json` file under `otr-api/API` with the following content, replacing `Osu.ClientId` and `Osu.ClientSecret` with your actual [osu! API v2](https://osu.ppy.sh/docs/index.html) client:

```json
"Logging": {
    "LogLevel": {
        "Default": "Trace",
        "Microsoft.AspNetCore": "Warning"
    }
},
"ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Port=5432;User Id=postgres;Password=password;Include Error Detail=true;",
    "CollectorConnection": "http://localhost:1234",
    "RedisConnection": "localhost:6379",
    "LokiConnection": "test"
},
"Osu": {
    "ClientId": "your-client-id",
    "ClientSecret": "your-client-secret"
},
"Jwt": {
    "Audience": "http://localhost:3000",
    "Issuer": "http://localhost:5075",
    "Key": "7a960b94-ae48-4591-92f2-bd9c1a300cd8"
},
"Auth": {
    "AllowedHosts": ["http://localhost:3000", "https://www.foobar.xyz"],
    "AuthorizationApiKey": "abcdefgh",
    "EnforceWhitelist": false,
    "PersistDataProtectionKeys": true
},
"RateLimit": {
    "PermitLimit": 100,
    "Window": 60
},
"RabbitMq": {
    "Host": "localhost",
    "Username": "admin",
    "Password": "admin"
}
```

### DWS Configuration

Create a configuration file under `otr-api/DWS` called `appsettings.Development.json` with the following content, again replacing the `Osu.ClientId` and `Osu.ClientSecret` fields with your actual [osu! API v2](https://osu.ppy.sh/docs/index.html) client credentials:

```json
{
    "Logging": {
        "LogLevel": {
            "Default": "Information",
            "Microsoft.Hosting.Lifetime": "Information"
        }
    },
    "Serilog": {
        "MinimumLevel": {
            "Default": "Information",
            "Override": {
                "Microsoft": "Warning",
                "Microsoft.Hosting.Lifetime": "Information",
                "Microsoft.EntityFrameworkCore": "Warning",
                "MassTransit": "Information",
                "MassTransit.Messages": "Warning"
            }
        }
    },
    "ConnectionStrings": {
        "DefaultConnection": "Host=localhost;Port=5432;Database=postgres;Username=postgres;Password=password",
        "CollectorConnection": "Host=localhost;Port=5432;Database=postgres;Username=postgres;Password=password",
        "RedisConnection": "localhost:6379",
        "LokiConnection": "http://localhost:3100"
    },
    "RabbitMq": {
        "Host": "localhost",
        "Username": "admin",
        "Password": "admin"
    },
    "Osu": {
        "ClientId": "your-client-id",
        "ClientSecret": "your-client-secret",
        "RedirectUrl": "http://localhost:5075/api/v1/auth/callback",
        "OsuRateLimit": 120,
        "OsuTrackRateLimit": 100
    },
    "PlayerUpdateService": {
        "Enabled": false,
        "OutdatedAfterDays": 14,
        "BatchSize": 100,
        "CheckIntervalSeconds": 3600,
        "MaxMessagesPerCycle": 50,
        "MessagePriority": 0
    },
    "PlayerOsuTrackUpdateService": {
        "Enabled": false,
        "OutdatedAfterDays": 14,
        "CheckIntervalSeconds": 30,
        "MaxMessagesPerCycle": 30,
        "MessagePriority": 0
    },
    "ConsumerConcurrency": {
        "BeatmapFetchConsumers": 1,
        "MatchFetchConsumers": 1,
        "PlayerFetchConsumers": 1,
        "PlayerOsuTrackFetchConsumers": 1,
        "TournamentAutomationCheckConsumers": 1,
        "TournamentStatsConsumers": 10
    }
}
```

### Processor Configuration

Create a `.env` file in the root of the `otr-processor/` directory with the following content:

```
CONNECTION_STRING=postgresql://postgres:password@localhost:5432/postgres
RUST_LOG=info
IGNORE_CONSTRAINTS=false
RABBITMQ_URL=amqp://admin:admin@localhost:5672
RABBITMQ_ROUTING_KEY=processing.stats.tournaments
```

### Web Configuration

Create a `.env` file in the root of the `otr-web/` directory with the following content:

```
NEXT_PUBLIC_API_BASE_URL="http://localhost:5075"
NEXT_PUBLIC_APP_BASE_URL="http://localhost:3000"
IS_RESTRICTED_ENV=false
API_KEY=abcdefgh
```

Next, install the packages with `npm i --legacy-peer-deps`.

## Verify Setup

To verify everything is setup correctly:

- Navigate to `otr-api/` and run `dotnet test`
- Navigate to `otr-processor/` and run `cargo test`

If both of those succeed without any issues, we can run everything in tandem:

- Open up a few terminal windows under the directory where all repositories are cloned.
- In one terminal, run `cd otr-api/API && dotnet run`
- In a second terminal, run `cd otr-api/DWS && dotnet run`
- In a third terminal, run `cd otr-web && npm run dev`

At this point, everything should be good to go. You can navigate to `http://localhost:3000` to use the website (signing in with osu! should work normally), and `http://localhost:5075/swagger` to interact with the API.

## Tips

### Swagger

To use swagger for endpoint testing, first, sign into the website to ensure a `user` entity is created for you in the database.

After signing in locally, query for your user id with this command:

```sql
SELECT u.id FROM users u JOIN players p ON p.user_id = u.id WHERE p.osu_id = <your_osu_id>;
```

Then, run this command to generate a JWT which can be used in swagger:

```
dotnet run --project (your-directory)/otr-api/API.Utils.Jwt -- --subject your-user-id-here -k 7a960b94-ae48-4591-92f2-bd9c1a300cd8 -a  
http://localhost:3000 -i http://localhost:5075 --roles admin
```

The last bit, `--roles admin` will allow you to simulate being an admin (how neat)! Most features are locked behind admin-only permissions. If you want to simulate being a normal user, just remove the `--roles` flag entirely.

>[!Author's note]
>I store the above JWT command as a shell alias called `jwt`. Whenever I need a JWT for testing (which is everytime I have to refresh swagger), I just type `jwt`.

### VSCode Workspaces

Having a single folder with all of the `otr` repositories is quite convenient, as a workspace file can then be created. If you convert the parent folder into a git repository, this enables VSCode to see all of the subdirectory git statuses simultaneously.

Workspaces also enable custom run configurations which can debug the API, DWS and Website in one click.

![[Screenshot_20250824_143926.png]]

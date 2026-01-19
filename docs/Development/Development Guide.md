## Overview

This article details how to clone and configure the website, data worker, and processor projects.

### Prerequisites

> [!warning]
> Windows users may encounter difficulty installing Docker and Rust as they behave differently. Docker requires virtualization settings to be enabled while Rust may require editing the system PATH variable manually.

- Install [git](https://git-scm.com/downloads)
- Install [Docker Desktop](https://www.docker.com/) or another Docker distribution with `docker compose`
- Install [Bun](https://bun.sh/) 1.1 or later (used for the web app and data worker)
- Instlal [Rust](https://rust-lang.org/tools/install/) (for the processor)
- Download the latest [public replica](https://data.otr.stagec.xyz/) (`.gz` file)
- Create an [osu! API v2 client](https://osu.ppy.sh/home/account/edit) and set the `Application Callback URLs` field to `http://localhost:3000/api/auth/oauth2/callback/osu`.

### Clone repositories

> [!important]
> Outside contributors need to first fork the repositories on [GitHub](https://github.com/osu-tournament-rating). This is only necessary for those who intend to author code contributions.

Optionally organize the projects under a single `otr/` directory and clone:

```
mkdir otr && cd otr
git clone https://github.com/osu-tournament-rating/otr-web.git
git clone https://github.com/osu-tournament-rating/otr-processor.git
```

### Environment files

In `otr-web`, copy the `.env.example` file into `.env` :

```
cd otr-web
cp .env.example .env
```

Populate the `WEB_OSU_CLIENT_ID` and `WEB_OSU_CLIENT_SECRET` variables using the information from your osu! API v2 client. The same client ID and client secret can be used in the `DATA_WORKER_OSU_CLIENT_ID` and `DATA_WORKER_OSU_CLIENT_SECRET` variables. It is not necessary to change any other defaults.

### Start Postgres and RabbitMQ

From the `otr-web/` directory, start the database and queue manager:

```
docker compose up -d db rabbitmq
```

This starts Postgres 17 and RabbitMQ 4. The RabbitMQ management UI is viewable at `http://localhost:15672/` (default user `admin`, password `admin`).

> [!important]
> The database and queue manager will run so long as Docker is running, even after rebooting. To stop the programs indefinitely, run `docker compose down` in the `otr-web` directory.

#### Database import

> [!note]
> Windows users should run this command in git bash or some other terminal that supports `gunzip` natively. If using git bash, the path `C:\Users\Foo\Downloads` translates to `/c/Users/Foo/Downloads`.

Import the replica downloaded from earlier, changing `/path/to/replica.gz` to the path of the `.gz` database dump.

```shell
gunzip -c /path/to/replica.gz | docker exec -i db bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

##### Troubleshooting

If this error occurs:

```
ERROR:  database "postgres" is being accessed by other users
DETAIL:  There are 2 other sessions using the database.
```

Run `docker stop db && docker start db`, then try the import again.

### Install dependencies

```
bun i --frozen-lockfile
```

#### Run migrations

Apply the latest database migrations so the web app and data worker match production:

```
bunx drizzle-kit migrate
```

### Run the web app and data worker

> [!important]
> `bun run dev` fails in git bash. Run the below `bun run --filter ...` commands in separate terminal instances instead.

Use the combined development script to start both applications:

```
bun run dev
```

To run one application at a time, run these commands in separate terminal windows:

```
bun run --filter web dev
bun run --filter data-worker dev
```

The web app listens on `http://localhost:3000`. The data worker runs in the background and connects to the RabbitMQ instance.

### Verify the setup

Visit `http://localhost:3000` and sign in with osu! to confirm BetterAuth is configured correctly. RabbitMQ queues and message activity are visible at `http://localhost:15672/`.

Note that ratings will not appear until the processor is run successfully.

### Processor configuration

In the `otr-processor` directory, copy the `.env.example` file into `.env`:

```
cp .env.example .env
```

### Run the processor

Use these commands to test and run the processor:

- `cargo test`- run tests.
- `cargo run -r` - run the processor.

After running the processor and revisiting the website locally, ratings should be present and the leaderboard will be established.
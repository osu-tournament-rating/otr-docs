Want to set up the o!TR tools for development? You're in the right place!

## Overview

This document covers:

- Setting up the `otr-web` monorepo locally (web application + data worker)
- Preparing `otr-processor` if you intend to publish ratings
- Configuring environment variables shared across services
- Running Postgres and RabbitMQ with `docker compose`
- Tips from the maintainers

By the end of this guide, you will be able to run and debug the software that powers the platform the same way the lead maintainer does. If you have not already done so, read through [[Platform Architecture]] to understand how each application is designed and how the data flows between components.

While it is recommended to set everything up, you may skip pieces depending on your focus:

- Web-only contributions still require everything besides the processor.
- If you only intend to generate rating outputs directly, you can run the processor alongside Postgres and RabbitMQ while skipping the web stack.

## Local development

This section covers the steps required to get started with local development:

- Install prerequisites
- Clone the repositories you will work in
- Configure environment files
- Start supporting services with Docker
- Install dependencies and run the applications

### Prerequisites

- Install [git](https://git-scm.com/downloads)
- Install [Docker Desktop](https://www.docker.com/) or another Docker distribution with `docker compose`
- Install [Bun](https://bun.sh/) 1.1 or later (used for the web app and data worker)
- Download the latest [public replica](https://data.otr.stagec.xyz/)

### Clone repositories

Maintainers may clone the main repositories directly. External contributors should fork each repository first and clone their fork. Organise the projects under a single `otr/` directory if you have not already done so:

```
mkdir -p (your-directory)/otr
cd (your-directory)/otr

git clone https://github.com/osu-tournament-rating/otr-web.git
git clone https://github.com/osu-tournament-rating/otr-processor.git
```

### Environment files

Navigate to `otr-web/` and copy the example environment file:

```
cd (your-directory)/otr/otr-web
cp .env.example .env
```

Populate the `WEB_OSU_CLIENT_ID` and `WEB_OSU_CLIENT_SECRET` variables. The same client ID and client secret can be used in the `DATA_WORKER_OSU_CLIENT_ID` and `DATA_WORKER_OSU_CLIENT_SECRET` variables as well.

Don't modify any other defaults.

### Start Postgres and RabbitMQ

From the `otr-web/` directory, run:

```
docker compose up -d db rabbitmq
```

This starts Postgres 17 and RabbitMQ 4 with the management UI enabled at `http://localhost:15672/` (default user `admin`, password `admin`).

#### Database import

Import the replica downloaded from earlier as follows:

```shell
gunzip -c /path/to/replica.gz | docker exec -i db bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

To test the system without importing a dump, uncomment the SQL in `apps/web/drizzle/0000_brave_hex.sql` (SQL starts at line 5) before running the migrations. Keep in mind that there will be no data and all IDs & permissions will be reset.

#### Run migrations

Apply the latest database migrations so the web app and data worker match production:

```
docker compose --profile migrate run --rm migrate
```

The `migrate` profile builds the web image and executes `scripts/run-migrations.sh`, which installs dependencies if needed and runs pending Drizzle migrations.

### Install dependencies

With Postgres and RabbitMQ running, install workspace dependencies once:

```
bun install --frozen-lockfile
```

### Run the web app and data worker

> [!important]
> Windows users who are not using [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) need to run
> the two `bun run --filter ...` commands in separate terminals.

Use the combined development script to start both applications:

```
bun run dev
```

The script traps `SIGINT`/`SIGTERM` and stops both processes when you press `Ctrl+C`. If you only need one side:

```
bun run --filter web dev
bun run --filter data-worker dev
```

The web app listens on `http://localhost:3000`. The data worker runs in the background and connects to the RabbitMQ instance.

### Verify the setup

Visit `http://localhost:3000` and sign in with osu! to confirm BetterAuth is configured correctly. RabbitMQ queues and message activity are visible at `http://localhost:15672/`.

### Processor configuration (optional)

If you plan to run the processor locally, create a `.env` file in the `otr-processor/` directory with the following content:

```
CONNECTION_STRING=postgresql://postgres:password@localhost:5432/postgres
RUST_LOG=info
IGNORE_CONSTRAINTS=true
RABBITMQ_URL=amqp://admin:admin@localhost:5672
RABBITMQ_ROUTING_KEY=processing.stats.tournaments
```

Then run:

- `cargo test` to verify the processor builds and passes its suite
- `cargo run -r -- --help` to review runtime options before generating ratings

The processor uses the same RabbitMQ instance to queue tournament stat regeneration jobs. Its published messages will be consumed by the data worker when it is running.

### Running the full stack

To run the entire pipeline after completing the steps above:

1. Ensure Postgres and RabbitMQ are running via Docker (`docker ps`).
2. Start the web app and data worker with `bun run dev`.
3. Launch the processor when you need fresh rating outputs and/or stats (`cargo run -r`).

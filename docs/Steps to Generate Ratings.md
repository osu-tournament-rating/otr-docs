This guide provides instructions for running the [[Development/Platform Architecture#processor|processor]] locally to generate player ratings from publicly-available datasets. This enables independent verification of tournaments which use our platform for filtering and/or seeding.

> [!important]
> The `otr-processor` version must be the most recent version released **before** the tournament's registration period. The processor uses date-based versioning in `YYYY.MM.DD` format. Different processor versions may produce different results due to algorithm updates.

## Prerequisites

- [Docker](https://www.docker.com/get-started/)
- (Windows only) [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) - required because these commands use Unix-style syntax not supported by Windows Command Prompt or PowerShell.
- Follow the setup instructions in the [[Development/Development Guide|development guide]] so you have the `otr-web` and `otr-processor` repositories available locally.

## Step 1: Start the database

Start Postgres and RabbitMQ from the `otr-web` repository directory:

```bash
# From the `otr-web` repository
docker compose up -d db rabbitmq
```

## Step 2: Import database replica

Public database replicas are published on the [public replicas site](https://data.otr.stagec.xyz). These weekly replicas exclude most data, but provide enough data to verify a tournament's use of o!TR.

Download the most recent replica dated before the tournament closed registrations. If the tournament provides another date by which ratings are taken from, use that date instead.

### Verify the download (optional)

As of November 26, 2025, each replica is accompanied by a `.sha256` checksum file and a `.sig` GPG signature file. These allow you to verify that the data hasn't been tampered with.

**SHA-256 verification (integrity only):**

Download the `.sha256` file for your replica and run:

```bash
sha256sum -c otr-public-replica_YYYY_MM_DD_HH_MM_SS.gz.sha256
```

**GPG signature verification (integrity + origin):**

Download the public key (one-time) and the `.sig` file for your replica:

```bash
curl -O https://storage.googleapis.com/otr-public-replica/otr-public-key.asc
gpg --import otr-public-key.asc
gpg --verify otr-public-replica_YYYY_MM_DD_HH_MM_SS.gz.sig otr-public-replica_YYYY_MM_DD_HH_MM_SS.gz
```

If verification succeeds, the output will contain `Good signature from "o!TR Public Data Signing Key"`. You may also see a warning about the key not being certified with a trusted signature—this is expected and can be ignored.

### Import the replica

```bash
gunzip -c /path/to/replica.gz | docker exec -i db bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

> [!tip]
> Some errors, such as `ERROR: role [...] does not exist`, can be safely ignored.

## Step 3: Run the processor

Browse the [releases page](https://github.com/osu-tournament-rating/otr-processor/releases) to find a processor version to use. Then, take the name of the release and replace the `YYYY.MM.DD` text below with that value.

> [!note]
> The processor publishes queue messages to generate stats for processed tournaments. Its management console lives at `http://localhost:15672/`. Under `Queues and Streams`, you can see the status of all queues.

```bash
docker run --rm \
  --name otr-processor \
  --network host \
  -e CONNECTION_STRING="postgresql://postgres:password@localhost:5432/postgres" \
  -e IGNORE_CONSTRAINTS=true \
  stagecodes/otr-processor:YYYY.MM.DD
```

> [!tip]
> Replace `YYYY.MM.DD` with the processor release version.

> [!tip]
> To run pre-production changes, use the `:staging` tag. To run the latest production version, use the `:latest` tag.
>
> Example: `docker run ... stagecodes/otr-processor:staging`

## Step 4: Export player ratings

Export player ratings for verification. Replace `ruleset` values as follows:

- 0=osu!
- 1=osu!taiko
- 2=osu!catch
- 3=osu!mania (Other) [No ratings are generated for this ruleset]
- 4=osu!mania 4K
- 5=osu!mania 7K

### Export specific game mode (recommended)

```bash
# Export osu! ratings (ruleset = 0)
docker exec -it db psql -U postgres -d postgres -c "\
COPY (
    SELECT
        p.osu_id,
        p.username,
        p.country,
        pr.rating,
        pr.global_rank,
        pr.country_rank
    FROM public.players p
    JOIN public.player_ratings pr ON p.id = pr.player_id
    WHERE pr.ruleset = 0
--                    ^^^ == Edit ruleset here ==
    ORDER BY pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > ratings.csv
```

### Export all ratings

> [!note]
> One player may have multiple ratings, one per ruleset.

```bash
# Export all player ratings to CSV
docker exec -it db psql -U postgres -d postgres -c "\
COPY (
    SELECT
        p.osu_id,
        p.username,
        p.country,
        pr.ruleset,
        pr.rating,
        pr.volatility,
        pr.percentile,
        pr.global_rank,
        pr.country_rank
    FROM public.players p
    JOIN public.player_ratings pr ON p.id = pr.player_id
    ORDER BY pr.ruleset, pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > ratings.csv
```

## Cleanup

Remove the created containers and volumes (to keep the database and other volumes, remove `-v`).

```bash
docker compose down -v
```

## Troubleshooting

- **Database connection refused**: Ensure PostgreSQL container is running with `docker ps`
- **Processor runs but crashes**: Ensure the `IGNORE_CONSTRAINTS=true` environment variable is set (using `-e`). If other unexpected issues occur, please [[Contact|contact us]].
- **Export produces empty files**: Verify the database import completed successfully

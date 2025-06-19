This guide provides instructions for running the otr-processor locally to generate player ratings from publicly-available datasets. This enables independent verification of tournaments which use the platform for filtering and/or seeding.

> [!important]
> The otr-processor version must be the most recent version released before the tournament's registration period. The processor uses date-based versioning in YYYY.MM.DD format. Different processor versions may produce different results due to algorithm updates.

## Prerequisites

- Docker Desktop or Docker Engine

## Step 1: Set Up the Database

```bash
# Create database volume and container
docker volume create otr-db
docker run -d \
  --name otr-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -v otr-db:/var/lib/postgresql/data \
  postgres:17
```

## Step 2: Import Database Dump

Public database dumps are available at [https://data.otr.stagec.xyz](https://data.otr.stagec.xyz). These weekly replicas exclude most data, but provide enough data to verify a tournament's use of o!TR.

Download the most recent dump dated before the tournament's registration period.

### Import the dump

This command will drop, recreate, and import the database in a single operation:

```bash
gunzip -c your-dump.gz | docker exec -i otr-postgres bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

> [!note]
> Any errors during import can be safely ignored

## Step 3: Run the Processor

Browse the [releases page](https://github.com/osu-tournament-rating/otr-processor/releases) to find the most recent processor version released before the day the tournament used o!TR to filter and/or seed participants. This is typically the day registrations end, though the tournament should specify clearly.

```bash
# Pull and run the processor (replace YYYY.MM.DD with the appropriate version)
docker pull stagecodes/otr-processor:YYYY.MM.DD
docker run --rm \
  --name otr-processor \
  --network host \
  -e CONNECTION_STRING="postgresql://postgres:postgres@localhost:5432/postgres" \
  stagecodes/otr-processor:YYYY.MM.DD
```

## Step 4: Export Player Ratings

Export player ratings for verification. Replace `ruleset` values as follows: 0=osu!, 1=taiko, 2=catch, 4=mania 4K, 5=mania 7K.

### Export All Ratings

```bash
# Export all player ratings to CSV
docker exec -it otr-postgres psql -U postgres -d postgres -c "\
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
    WHERE pr.matches_played > 0
    ORDER BY pr.ruleset, pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > all_ratings.csv
```

### Export Specific Game Mode

```bash
# Export osu! standard ratings (ruleset = 0)
docker exec -it otr-postgres psql -U postgres -d postgres -c "\
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
    WHERE pr.ruleset = 0 AND pr.matches_played > 0
    ORDER BY pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > ratings_osu.csv
```

## Cleanup

```bash
# Stop and remove containers and volumes
docker stop otr-postgres
docker rm otr-postgres
docker volume rm otr-db
```

## Troubleshooting

- **Database connection refused**: Ensure PostgreSQL container is running with `docker ps`
- **Processor runs but no ratings generated**: Check processor logs with `docker logs otr-processor`
- **Export produces empty files**: Verify the database import completed successfully

## Example: Tournament Verification

Verifying ratings for a tournament with registrations closing March 1, 2024:

```bash
# 1. Set up database
docker volume create otr-db
docker run -d --name otr-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -v otr-db:/var/lib/postgresql/data postgres:17

# 2. Import database dump from https://data.otr.stagec.xyz (one-line command)
gunzip -c your-dump.gz | docker exec -i otr-postgres bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"

# 4. Run processor (version from before March 1, 2024)
docker pull stagecodes/otr-processor:YYYY.MM.DD
docker run --rm --name otr-processor --network host -e CONNECTION_STRING="postgresql://postgres:postgres@localhost:5432/postgres" stagecodes/otr-processor:YYYY.MM.DD

# 5. Export ratings (ruleset: 0=osu!, 1=taiko, 2=catch, 3=mania)
docker exec -it otr-postgres psql -U postgres -d postgres -c "\
COPY (
    SELECT p.osu_id, p.username, p.country, pr.rating, pr.global_rank
    FROM public.players p
    JOIN public.player_ratings pr ON p.id = pr.player_id
    WHERE pr.ruleset = 0 AND pr.matches_played > 0
    ORDER BY pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > tournament_verification.csv

# 6. Cleanup
docker stop otr-postgres && docker rm otr-postgres && docker volume rm otr-db
```

This guide provides instructions for running the otr-processor locally to generate player ratings from publicly-available datasets. This enables independent verification of tournaments which use the platform for filtering and/or seeding.

> [!important]
> The otr-processor version must be the most recent version released before the tournament's registration period. The processor uses date-based versioning in YYYY.MM.DD format. Different processor versions may produce different results due to algorithm updates.

## Prerequisites

- [Docker](https://www.docker.com/get-started/)
- (Windows only) [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) - required because these commands use Unix-style syntax not supported by Windows Command Prompt or PowerShell.

## Step 1: Set Up the Database

```bash
# Create database volume and container
docker volume create otr-db
docker run -d \
  --name otr-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=password \
  -v otr-db:/var/lib/postgresql/data \
  postgres:17
```

## Step 2: Import Database Dump

Public database dumps are available at [https://data.otr.stagec.xyz](https://data.otr.stagec.xyz). These weekly replicas exclude most data, but provide enough data to verify a tournament's use of o!TR.

Download the most recent dump dated before the tournament's registration period.

### Import the dump

This command will drop, recreate, and import the database in a single operation:

```bash
gunzip -c /path/to/replica.gz | docker exec -i otr-postgres bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

> [!note]
> Any errors during import can be safely ignored

## Step 3: Run the Processor

Browse the [releases page](https://github.com/osu-tournament-rating/otr-processor/releases) to find the most recent processor version released before the day the tournament used o!TR to filter and/or seed participants. This is typically the day registrations end, though the tournament should specify clearly.

```bash
docker run --rm \
  --name otr-processor \
  --network host \
  -e CONNECTION_STRING="postgresql://postgres:password@localhost:5432/postgres" \
  -e IGNORE_CONSTRAINTS=true \
  stagecodes/otr-processor:YYYY.MM.DD
```

## Step 4: Export Player Ratings

Export player ratings for verification. Replace `ruleset` values as follows: 0=osu!, 1=taiko, 2=catch, 4=mania 4K, 5=mania 7K.

> [!tip]
> To validate the ratings of all players in a tournament from this point in time, import the csv files generated using the below steps into a spreadsheet. Then, use the spreadsheet software to filter against the list of osu! IDs

### Export Specific Game Mode (Recommended)

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
    WHERE pr.ruleset = 0
--                    ^^^ == EDIT THIS VALUE ==
    ORDER BY pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > ratings_osu.csv
```

### Export All Ratings

> [!warning]
> Be aware that one player may have multiple ratings, one per ruleset.

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
    ORDER BY pr.ruleset, pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > all_ratings.csv
```

## Step 5: Filter Ratings for Specific Players

After exporting ratings to CSV files, you may want to filter them for specific players. This is useful when verifying ratings for tournament participants.

### Method 1: Filter by Individual osu! IDs

```bash
# Filter for specific osu! IDs (replace 12345|67890 with actual IDs).
# Note, the regex will partially match, meaning "^(11)" will include everyone whose ID starts with 11
head -1 all_ratings.csv > filtered_ratings.csv && grep -E "^(12345|67890|11111)" all_ratings.csv >> filtered_ratings.csv
```

### Method 2: Filter Using a List File

If you have many IDs, create a text file with one osu! ID per line:

```bash
# Create a file with osu! IDs
echo -e "8191845\n11557554\n7823498" > player_ids.txt

# Filter using the ID list
head -1 all_ratings.csv > filtered_ratings.csv && grep -f player_ids.txt all_ratings.csv >> filtered_ratings.csv
```

### Example Output

After filtering, your CSV will contain only the specified players:

```csv
osu_id,username,country,ruleset,rating,volatility,percentile,global_rank,country_rank
11557554,Cytusine,US,0,1471.6847685949424,221.60678571859532,96.70174677226863,608,107
8191845,Stage,US,0,1116.3175053076163,276.7000024131878,82.53770207225777,3219,522
11557554,Cytusine,US,1,963.0656128340958,297.23443168412547,54.097452934662236,829,63
11557554,Cytusine,US,4,483.4417050410036,293.7349217649456,1.2587412587412588,2118,218
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
- **Processor runs but crashes**: Ensure the `IGNORE_CONSTRAINTS=true` environment variable is set (using `-E`). If other unexpected issues occur, please [[contact|contact us]].
- **Export produces empty files**: Verify the database import completed successfully

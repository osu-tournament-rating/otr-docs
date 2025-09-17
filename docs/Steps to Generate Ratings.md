This guide provides instructions for running the [[Development/Platform Architecture#processor|processor]] locally to generate player ratings from publicly-available datasets. This enables independent verification of tournaments which use our platform for filtering and/or seeding.

> [!important]
> The `otr-processor` version must be the most recent version released **before** the tournament's registration period. The processor uses date-based versioning in `YYYY.MM.DD` format. Different processor versions may produce different results due to algorithm updates.

## Prerequisites

- [Docker](https://www.docker.com/get-started/)
- (Windows only) [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) - required because these commands use Unix-style syntax not supported by Windows Command Prompt or PowerShell.

## Step 1: Start the Database

```bash
# Create database volume and container
docker volume create otr-db
docker run -d \
  --name otr-db \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=password \
  -v otr-db:/var/lib/postgresql/data \
  postgres:17
```

## Step 2: Import Database Replica

Public database replicas are published [here](https://data.otr.stagec.xyz). These weekly replicas exclude most data, but provide enough data to verify a tournament's use of o!TR.

Download the most recent replica dated before the tournament closed registrations. If the tournament provides another date by which ratings are taken from, use that date instead.

### Import the replica

Use this command to overwrite your `otr-postgres` volume data.

```bash
gunzip -c /path/to/replica.gz | docker exec -i otr-postgres bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

> [!tip]
> Some errors, such as `ERROR: role [...] does not exist`, can be safely ignored.

## Step 3: Run the Processor

Browse the [releases page](https://github.com/osu-tournament-rating/otr-processor/releases) to find a processor version to use. Then, take the name of the release and replace the `YYYY.MM.DD` text below with that value.

```bash
docker run --rm \
  --name otr-processor \
  --network host \
  -e CONNECTION_STRING="postgresql://postgres:password@localhost:5432/postgres" \
  -e IGNORE_CONSTRAINTS=true \
  stagecodes/otr-processor:YYYY.MM.DD
```

> [!example]
> If the [[Development/Platform Architecture#processor|otr-processor]] version is `2025.06.19`, run using the `otr-processor:2025.06.19` image.

> [!tip]
> To run pre-production changes, use the `:staging` tag. To run the latest production version, use the `:latest` tag.
>
> Example: `docker run ... stagecodes/otr-processor:staging`

## Step 4: Export Player Ratings

Export player ratings for verification. Replace `ruleset` values as follows:

- 0=osu!
- 1=osu!taiko
- 2=osu!catch
- 3=osu!mania (Other) [No ratings are generated for this ruleset]
- 4=osu!mania 4K
- 5=osu!mania 7K

### Export Specific Game Mode (Recommended)

```bash
# Export osu! ratings (ruleset = 0)
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
--                    ^^^ == Edit ruleset here ==
    ORDER BY pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > ratings.csv
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
) TO STDOUT WITH CSV HEADER;" > ratings.csv
```

> [!tip]
> Import this data into a spreadsheet for analysis.

## Step 5: Filter Ratings for Specific Players

After exporting ratings, you may want to filter them for specific players. This is useful verifying the ratings of tournament participants.

### Method 1: Filter Using a List File

If you have many IDs, create a text file called `player_ids.txt` with one osu! ID per line.

Then, filter `ratings.csv` for IDs present in `player_ids.txt`.

```bash
# For each osu! ID in player_ids.txt, print the ratings.csv entry
head -1 ratings.csv > filtered_ratings.csv && grep -f player_ids.txt ratings.csv >> filtered_ratings.csv
```

### Method 2: Filter by Individual osu! IDs

> [!warning]
> This regex will partially match on any **row**, meaning `^(11)` will include every row containing `11`. If full osu! IDs are provided, accurate rows will be returned.

```bash
# Filter for specific osu! IDs (replace 12345|67890 with actual IDs).
head -1 ratings.csv > filtered_ratings.csv && grep -E "^(12345|67890)" ratings.csv >> filtered_ratings.csv
```

### Example Output

After filtering, your CSV will contain only the specified players:

```csv
osu_id,username,country,ruleset,rating,volatility,percentile,global_rank,country_rank
11557554,Cytusine,US,0,1471.6847685949424,221.60678571859532,96.70174677226863,608,107
8191845,Stage,US,0,1116.3175053076163,276.7000024131878,82.53770207225777,3219,522
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
- **Processor runs but crashes**: Ensure the `IGNORE_CONSTRAINTS=true` environment variable is set (using `-e`). If other unexpected issues occur, please [[Contact|contact us]].
- **Export produces empty files**: Verify the database import completed successfully

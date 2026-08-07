This guide explains how to regenerate player ratings from publicly-available datasets as they were at the time of the snapshot. This enables independent verification of tournaments which use the platform for filtering and/or seeding. The `otr-replay` tool performs the entire procedure automatically; the manual steps remain available as a fallback.

## Using otr-replay

`otr-replay` requires [Docker](https://www.docker.com/get-started/) and [uv](https://docs.astral.sh/uv/). No other configuration is necessary.

1. Clone the [otr-replay](https://github.com/osu-tournament-rating/otr-replay) repository.
2. From the repository root, run the program with the UTC timestamp at which the tournament closed registrations. If the tournament provides another date by which ratings are taken from, use that date instead.

```bash
uv run otr-replay --as-of 2026-06-27T23:59Z
```

The program downloads the correct public replica from the [public replicas site](https://data.otr.stagec.net), verifies its checksum, imports it into a temporary database, runs the correct [[Development/Platform Architecture#processor|processor]] release, reconciles decay, and writes two files: a CSV with the columns `osu_id`, `username`, `ruleset`, `rating`, and `volatility`, and a metadata file describing the run.

## Decay Reconciliation

The processor applies a final [[Rating Framework/Rating Calculation/Rating Decay|decay]] pass up to the system's current time and is therefore not aware that it is being run against an older dataset. Replaying an old snapshot therefore incorrectly creates decay adjustments that did not exist at that time and must be reconciled.

The `otr-replay` tool automatically corrects this using the following process:

1. It verifies that only decay adjustments exist after the effective date.
2. It deletes those adjustments and restores the exact rating and volatility values they recorded.
3. It refuses to write any output if anything other than decay follows the instant.

The tool never recomputes any rating mathematics; it only removes adjustments which were not present at the time of the snapshot.

### Example

In this example, the processor release is `2026.05.18`, the database snapshot is for `2026-06-03_23_20_30.gz`, and the effective date is  `2026-06-05T12:00:00`. Without reconciliation, `im a fancy lad`'s decay is generated through the present day, as shown below.

![[fancylad-rating-history-table-2.png]]
![[fancylad-rating-history-table.png]]

With reconciliation, however, the decay now stops at `2026-06-03` - the Wednesday at 12:00UTC immediately prior to the snapshot (in this case, ~11 hours prior).

![[fancylad-rating-history-chart.png]]

Note the odd timestamp of the database snapshot - this is an edge case where the dataset was created late due to a technical issue. Remember, decay is calculated on each Wednesday at 12:00UTC, so this decay adjustment did exist at the time the snapshot was created. Had the snapshot been created as scheduled, this specific adjustment would be dropped.

## Manual Verification

The manual procedure below reproduces what `otr-replay` automates. It requires the setup from the [[Development/Development Guide|development guide]] so the `otr-web` and `otr-processor` repositories are available locally, configured, and (on Windows) [Git Bash](https://git-scm.com/downloads) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).

### Start the database

Start Postgres and RabbitMQ from the `otr-web` repository directory:

```bash
# From the `otr-web` repository
docker compose up -d otr-db rabbitmq
```

### Import a database replica

Public database replicas are published on the [public replicas site](https://data.otr.stagec.net). These weekly replicas exclude most data, but provide enough data to verify a tournament's use of o!TR.

Download the most recent replica dated before the tournament closed registrations, along with its `.sha256` checksum file, and verify the download:

```bash
sha256sum -c otr-public-replica_YYYY-MM-DD_HH_MM_SS.gz.sha256
```

Then import the replica:

```bash
gunzip -c /path/to/replica.gz | docker exec -i otr-db bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

> [!tip]
> Some errors, such as `ERROR: role [...] does not exist`, can be safely ignored.

### Run the processor

Browse the [releases page](https://github.com/osu-tournament-rating/otr-processor/releases) to find the most recent release available at the effective date. Then, take the name of the release and replace the `YYYY.MM.DD` text below with that value.

```bash
docker run --rm \
  --name otr-processor \
  --network host \
  -e CONNECTION_STRING="postgresql://postgres:password@localhost:5432/postgres" \
  -e IGNORE_CONSTRAINTS=true \
  stagecodes/otr-processor:YYYY.MM.DD
```

> [!example]
> If the date of interest is `2026-07-01T23:00:00Z`, the latest release available at that time is `2026.05.18`.

### Reconcile decay

The processor applies decay up to the moment it runs rather than the effective date, so the database now contains decay adjustments that did not exist at the requested time. Remove them by restoring each affected rating and deleting those adjustments. Replace both `YYYY-MM-DD` values with the date of interest ("as-of" date) in the command below:

```bash
docker exec -it otr-db psql -U postgres -d postgres -c "\
BEGIN;
WITH earliest AS (
    SELECT DISTINCT ON (player_id, ruleset)
        player_id, ruleset, rating_before, volatility_before
    FROM rating_adjustments
    WHERE timestamp > 'YYYY-MM-DD 12:00:00+00'
      AND adjustment_type IN (1, 3)
    ORDER BY player_id, ruleset, timestamp, id
)
UPDATE player_ratings pr
SET rating = earliest.rating_before,
    volatility = earliest.volatility_before
FROM earliest
WHERE pr.player_id = earliest.player_id
  AND pr.ruleset = earliest.ruleset;
DELETE FROM rating_adjustments
WHERE timestamp > 'YYYY-MM-DD 12:00:00+00'
  AND adjustment_type IN (1, 3);
COMMIT;"
```

> [!tip]
> Adjustment types `1` and `3` are rating decay and volatility decay. Decay is always timestamped Wednesday 12:00 UTC, so every decay adjustment after the effective date can be safely removed.

### Export player ratings

Export player ratings for verification. Rulesets are mapped as follows:

- 0=osu!
- 1=osu!taiko
- 2=osu!catch
- 3=osu!mania (Other) [No ratings are generated for this ruleset]
- 4=osu!mania 4K
- 5=osu!mania 7K

```bash
# Export all player ratings to CSV
docker exec -it otr-db psql -U postgres -d postgres -c "\
COPY (
    SELECT
        p.osu_id,
        p.username,
        pr.ruleset,
        pr.rating,
        pr.volatility
    FROM public.players p
    JOIN public.player_ratings pr ON p.id = pr.player_id
    ORDER BY pr.ruleset, pr.rating DESC
) TO STDOUT WITH CSV HEADER;" > ratings.csv
```

### Clean up

Remove the created containers and volumes (to keep the database and other volumes, remove `-v`).

```bash
# From otr-web
docker compose down -v
```

## Troubleshooting

- **Database connection refused**: Ensure the PostgreSQL container is running with `docker ps`.
- **Processor warns that RabbitMQ is unreachable**: This can be safely ignored.
- **`otr-replay` reports that adjustments after the instant are not decay**: The snapshot cannot be reconciled to the requested instant; please [[Contact|contact us]].
- **`otr-replay` reports that no checksum is published**: The selected replica predates published checksums; choose a later timestamp or [[Contact|contact us]].
- **Export produces empty files**: Verify the database import completed successfully.

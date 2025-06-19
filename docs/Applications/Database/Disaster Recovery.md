---
tags:
  - internal
---

This article explains how we manage database backups and details a database disaster recovery plan.

## Production Backups

Production backups are automated via a script set to run every six hours. The backups are compressed and uploaded to a Google Cloud Storage bucket. These scripts are part of an internal repository.

## Import the database

> [!note]- Internal disaster recovery process
>
> ### Using the disaster recovery script
>
> For environments with the otr-scripts repository set up, use the automated disaster recovery script:
>
> ```bash
> # From the otr-scripts directory:
> ./src/db/disaster-recovery.sh
> ```

### Manual import

> [!danger]
> These steps will overwrite the current database state.

> [!tip]
> It is safe to ignore any errors displayed in the console during the import process so long as the operation does not fail due to the error.

#### One-line import (recommended)

Drop, recreate, and import the database in a single command:

```bash
gunzip -c /path/to/dump.gz | docker exec -i [container] bash -c "psql -U postgres -d template1 -c 'DROP DATABASE IF EXISTS postgres;' && psql -U postgres -d template1 -c 'CREATE DATABASE postgres;' && psql -U postgres -d postgres"
```

#### Step-by-step import

Alternatively, you can perform the restoration in separate steps:

```bash
# Drop the existing database (if it exists) and create a new one
docker exec -i [container] dropdb -f --if-exists -U postgres postgres
docker exec -i [container] createdb -U postgres postgres

# Import the compressed dump
gunzip -c /path/to/dump.gz | docker exec -i [container] psql -U postgres -d postgres
```

Your database should now contain all of the data from the dump file.

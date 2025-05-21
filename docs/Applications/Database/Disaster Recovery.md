---
tags:
  - internal
---

This article explains how o!TR manages database backups and details a database disaster recovery plan.

## Production Backups

Production backups are automated via a script set to run every six hours. The backups are compressed and uploaded to a Google Cloud storage bucket. At this time, only [Stage](https://osu.ppy.sh/users/8191845) can perform production recovery operations.

### Backup Instructions

Backups are done with `pg_dump` and restores are done with `psql` ([see here](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP)).

#### Backup the database

Backup the database into a compressed archive.

 ```
 docker exec [container] pg_dump \
 -c \
 -U postgres \
 -d postgres | gzip > /my/dir/dump.gz
 ```

#### Restore the database

> [!danger]
> These steps will delete and overwrite your entire database.

##### Clean the database

Remove the `public` schema:

 ```
 docker exec \
 -it [container] psql \
 -U postgres \
 -c "DROP SCHEMA public CASCADE;" \
 -d postgres
 ```

Create the `public` schema:

 ```
 docker exec \
 -it [container] psql \
 -U postgres \
 -c "CREATE SCHEMA public;" \
 -d postgres
 ```

##### Overwrite the database

Overwrite your database with the dump:

 ```
 gunzip \
 -c /my/dir/dump.gz | docker exec \
 -i [container] psql \
 -U postgres \
 -d postgres
 ```

Your database should now contain all of the data from the dump file.

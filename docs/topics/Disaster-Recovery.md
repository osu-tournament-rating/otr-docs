# Disaster Recovery

This article explains how o!TR manages database backups and details a database disaster recovery plan.

> Windows users may need to delete the `\` characters before executing commands.
> 
> {style="note"}

## Production Backups

Production backups are automated via a script set to run every six hours. The backups are compressed and uploaded to a Google Cloud storage bucket. At this time, only [Stage](https://osu.ppy.sh/users/8191845) can perform production recovery operations.

## Backup Instructions

Backups are done with `pg_dump` and restores are done with `psql` ([see here](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP)).

### Backup the database

Backup the database into a zip file.

```Shell
docker exec [container] pg_dump \
-c \
-U postgres \
-d postgres | gzip > /my/dir/dump.gz
```

### Restore the database

> These steps will delete and overwrite your entire database.
>
{style="warning"}

> Cleaning the database is strongly recommended before overwriting it.
>
> 1. Remove the `public` schema:
>
> ```Shell
> docker exec \
> -it [container] psql \
> -U postgres \
> -c "DROP SCHEMA public CASCADE;" \
> -d postgres 
> ```
>
> 2. Create the `public` schema:
>
> ```Shell
> docker exec \
> -it [container] psql \
> -U postgres \
> -c "CREATE SCHEMA public;" \
> -d postgres 
> ```
>
{style="note"}

Overwrite your database with the dump:

```Shell
gunzip \
-c /my/dir/dump.gz | docker exec \
-i [container] psql \
-U postgres \
-d postgres 
```

Your database should now contain all of the data from the dump file.
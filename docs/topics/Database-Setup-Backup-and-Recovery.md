# Database Setup, Backup, and Recovery

## Setup

o!TR relies on a PostgreSQL database instance to function. This page can be used as a reference for first-time database setup as well as for disaster recovery.

It is recommended to run your dev database inside of a docker image.

First, create a docker volume:

```Shell
docker volume create otr-db
```

Then start the database:

```Shell
docker run -d -p 5432:5432 -v otr-db:/var/lib/postgresql/data -e POSTGRES_PASSWORD=password postgres
```

In the above example, this is what you put as your `DefaultConnection` in the `otr-api` `appsettings.Development.json` file:

```
Server=localhost;Port=5432;User Id=postgres;Password=password;Include Error Detail=true;
```

## Data

If you are on the dev team, reach out to [Stage](https://osu.ppy.sh/users/8191845) for a dump. Otherwise, please wait for a public dump to be made available.

If you have a database dump, you can populate your database by following the [restore](#restore-the-database) instructions below.

## Backup & Restore

Production backups are automated via a script set to run every six hours (soon, a hash check will be performed so identical backups won't be created, thus saving resources). The backups are compressed and uploaded to a Google Cloud storage bucket. At this time, only [Stage](https://osu.ppy.sh/users/8191845) can perform and manage these operations, though the procedures are documented publicly as we plan to support distribution of databases for those wanting to develop locally / verify our dataset.

Backups are done with `pg_dump` and restores are done with `psql` as documented [here](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP).

### Backup the database

Backup the database into a zip file.

```Shell
docker exec [container] pg_dump -c -U postgres postgres | gzip > /my/dir/dump.gz
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
> docker exec -it [container] psql -U postgres -c "DROP SCHEMA public CASCADE;" postgres 
> ```
>
> 2. Create the `public` schema:
>
> ```Shell
> docker exec -it [container] psql -U postgres -c "CREATE SCHEMA public;" postgres 
> ```
> 
{style="note"}

Overwrite your database with the dump:

```Shell
gunzip -c /my/dir/dump.gz | docker exec -i [container] psql -U postgres postgres 
```

Your database should now contain all of the data from the dump file.
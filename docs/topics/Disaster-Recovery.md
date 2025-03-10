# Disaster Recovery

This article explains how o!TR manages database backups and details a database disaster recovery plan.

## Production Backups

Production backups are automated via a script set to run every six hours. The backups are compressed and uploaded to a Google Cloud storage bucket. At this time, only [Stage](https://osu.ppy.sh/users/8191845) can perform production recovery operations.

## Backup Instructions

Backups are done with `pg_dump` and restores are done with `psql` ([see here](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP)).

### Backup the database

Backup the database into a compressed archive.

<tabs group="os">
    <tab id="Windows-backup" title="Windows" group-key="Windows">
        <code-block>
        docker exec [container] pg_dump `
        -c `
        -U postgres `
        -d postgres | gzip > /my/dir/dump.gz
        </code-block> 
        <tip>
            gzip needs to be present in the host machine. Alternatively, Windows users can use the Linux/macOS command instructions if executing through the git-bash utility.
        </tip>
    </tab>
    <tab id="Else-backup" title="Linux &amp; macOS" group-key="Else">
        <code-block>
        docker exec [container] pg_dump \
        -c \
        -U postgres \
        -d postgres | gzip > /my/dir/dump.gz
        </code-block>
    </tab>
</tabs>

### Restore the database

> These steps will delete and overwrite your entire database.
>
{style="warning"}

##### Clean the database

Remove the `public` schema:

<tabs group="os">
    <tab id="Windows-Schema-remove" title="Windows" group-key="Windows">
        <code-block>
            docker exec `
            -it [container] psql `
            -U postgres `
            -c "DROP SCHEMA public CASCADE;" `
            -d postgres
        </code-block>
    </tab>
    <tab id="Else-Schema-remove" title="Linux &amp; macOS" group-key="Else">
        <code-block>
            docker exec \
            -it [container] psql \
            -U postgres \
            -c "DROP SCHEMA public CASCADE;" \
            -d postgres
        </code-block>
    </tab>
</tabs>

Create the `public` schema:

<tabs group="os">
    <tab id="Windows-Schema-create" title="Windows" group-key="Windows">
        <code-block>
            docker exec `
            -it [container] psql `
            -U postgres `
            -c "CREATE SCHEMA public;" `
            -d postgres
        </code-block>
    </tab>
    <tab id="Else-Schema-create" title="Linux &amp; macOS" group-key="Else">
        <code-block>
            docker exec \
            -it [container] psql \
            -U postgres \
            -c "CREATE SCHEMA public;" \
            -d postgres
        </code-block>
    </tab>
</tabs>

##### Overwrite the database 

Overwrite your database with the dump:

<tabs group="os">
    <tab id="Windows-overwrite" title="Windows" group-key="Windows">
        <code-block>
        gunzip `
        -c /my/dir/dump.gz | docker exec `
        -i [container] psql `
        -U postgres `
        -d postgres
        </code-block>
        <tip>
            gunzip needs to be present in the host machine. Alternatively, Windows users can use the Linux/macOS command instructions if executing through the git-bash utility.
        </tip>
    </tab>
    <tab id="Else-overwrite" title="Linux &amp; macOS" group-key="Else">
        <code-block>
        gunzip \
        -c /my/dir/dump.gz | docker exec \
        -i [container] psql \
        -U postgres \
        -d postgres
        </code-block>
    </tab>
</tabs>

Your database should now contain all of the data from the dump file.
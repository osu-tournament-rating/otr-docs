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

<tabs group="os">
    <tab id="Windows-backup" title="Windows" group-key="Windows">
        Backup the database into a zip file.<br/>
        <code-block>
        docker exec [container] pg_dump `
        -c `
        -U postgres `
        -d postgres | gzip > /my/dir/dump.gz
        </code-block> 
        <!-- This command requires a way to execute gzip in Windows, either a software package or 
            an alternative command prompt to Windows PowerShell-->
    </tab>
    <tab id="Else-backup" title="Linux &amp; macOS" group-key="Else">
        Backup the database into a compressed archive.<br/>
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

> Cleaning the database is strongly recommended before overwriting it.
>
{style="note"}

##### Cleaning the database

 <tabs group="os">
    <tab id="Windows-Schema" title="Windows" group-key="Windows">
        <ol>
            <li>Remove the <code>public</code> schema:<br/>
                <code-block>
                docker exec `
                -it [container] psql `
                -U postgres `
                -c "DROP SCHEMA public CASCADE;" `
                -d postgres
                </code-block><br/></li>
            <li>Create the <code>public</code> schema:<br/>
                <code-block>
                docker exec `
                > -it [container] psql `
                > -U postgres `
                > -c "CREATE SCHEMA public;" `
                > -d postgres 
                </code-block><br/></li>
        </ol>
    </tab>
    <tab id="Else-Schema" title="Linux &amp; macOS" group-key="Else">
        <ol>
            <li>Remove the <code>public</code> schema:<br/>
                <code-block>
                docker exec \
                -it [container] psql \
                -U postgres \
                -c "DROP SCHEMA public CASCADE;" \
                -d postgres
                </code-block><br/></li>
            <li>Create the <code>public</code> schema:<br/>
                <code-block>
                docker exec \
                > -it [container] psql \
                > -U postgres \
                > -c "CREATE SCHEMA public;" \
                > -d postgres 
                </code-block><br/></li>
        </ol>
    </tab>
</tabs>

##### Overwriting the database 

<tabs group="os">
    <tab id="Windows-overwrite" title="Windows" group-key="Windows">
        Overwrite your database with the dump:<br/>
        <code-block>
        gunzip `
        -c /my/dir/dump.gz | docker exec `
        -i [container] psql `
        -U postgres `
        -d postgres
        </code-block>
        <!-- This command requires a way to execute gunzip in Windows, either a software package or 
    an alternative command prompt to Windows PowerShell-->
    </tab>
    <tab id="Else-overwrite" title="Linux &amp; macOS" group-key="Else">
        Overwrite your database with the dump:<br/>
        <code-block>
        gunzip \
        -c /my/dir/dump.gz | docker exec \
        -i [container] psql \
        -U postgres \
        -d postgres
        </code-block>
    </tab>
</tabs>
<br/>
Your database should now contain all of the data from the dump file.
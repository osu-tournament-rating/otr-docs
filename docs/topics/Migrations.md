# Migrations

Migrations are handled by [Entity Framework](https://learn.microsoft.com/en-us/aspnet/entity-framework). These are auto-generated files and configurations which enable code-first changes to the database.

## Creating / Editing Entities

Migrations must be created and tested when any of the following are modified:

1. Files in `Database/Entities`. These objects directly link to a database table.
    - Only create a migration when the changes modify the entity such that a database change is required. For example, adding a new field requires a migration, but modifying basic comments do not.
2. `OtrContext.cs`, if there are modifications which change entity relationships.

## Creating Migrations

To create a new migration, run the following in the root directory of the repository.

<tabs group="os">
   <tab id="Windows-create" title="Windows" group-key="Windows">
      <code-block>
      dotnet ef migrations add [Entity_ChangesMade] `
      --project Database `
      --startup-project API `
      --context OtrContext
      </code-block>
   </tab>
   <tab id="Else-create" title="Linux &amp; macOS" group-key="Else">
      <code-block>
      dotnet ef migrations add [Entity_ChangesMade] \
      --project Database \
      --startup-project API \
      --context OtrContext
      </code-block>
   </tab>
</tabs>

> `[Entity_ChangesMade]` should be replaced with the name of your migration. Migrations should use PascalCase with underscores separating the entity from the changes made. For example, `Player_ConvertIdToInteger` is a good name for a migration as it describes the change made at a glance.
> 

> When a new migration is created, it will not be tracked by git automatically. Ensure you commit the generated files.
> 
> {style="warning"}

> If using JetBrains Rider, take advantage of the built-in [Entity Framework tools](https://www.jetbrains.com/help/rider/Visual_interface_for_EF_Core_commands.html)!
>
> {style="tip"}
## Removing Migrations

If you need to undo a migration, run the following command to revert the most recent migration.

<tabs group="os">
   <tab id="Windows-remove" title="Windows" group-key="Windows">
      <code-block>
      dotnet ef migrations remove `
      --project Database `
      --startup-project API `
      --context OtrContext
      </code-block>
   </tab>
   <tab id="Else-remove" title="Linux &amp; macOS" group-key="Else">
      <code-block>
      dotnet ef migrations remove \
      --project Database \
      --startup-project API \
      --context OtrContext
      </code-block>
   </tab>
</tabs>

## Applying Migrations

Run the following to apply any pending migrations to the database. In development, ensure the database appears as expected after applying migrations.

<tabs group="os">
   <tab id="Windows-apply" title="Windows" group-key="Windows">
      <code-block>
      dotnet ef migrations update `
      --project Database `
      --startup-project API `
      --context OtrContext
      </code-block>
   </tab>
   <tab id="Else-apply" title="Linux &amp; macOS" group-key="Else">
      <code-block>
      dotnet ef migrations update \
      --project Database \
      --startup-project API \
      --context OtrContext
      </code-block>
   </tab>
</tabs>

## Apply Migrations in Production

The method of applying migrations is different in development than production. This is because the pipeline does not have access to a running database.

First, a migrations script is generated via the entity framework CLI. Then, the script is piped into the docker container which hosts our database. This method can also be used to apply migrations in development.

To generate the migrations script, run the following in the root directory of the repository:

<tabs group="os">
   <tab id="Windows-prod" title="Windows" group-key="Windows">
      <code-block>
      dotnet ef migrations script `
      --idempotent `
      --project Database `
      --startup-project API `
      --context OtrContext `
      -o script.sql
      </code-block>
   </tab>
   <tab id="Else-prod" title="Linux &amp; macOS" group-key="Else">
      <code-block>
      dotnet ef migrations script \
      --idempotent \
      --project Database \
      --startup-project API \
      --context OtrContext \
      -o script.sql
      </code-block>
   </tab>
</tabs>

> The `idempotent` flag tells the script to only apply migrations which have not already been applied.
> If you want to configure a database from scratch (e.g. no tables are in the `public` schema),
> remove this flag.
>
> {style="note"}

Apply the migrations:

<tabs group="os">
   <tab id="Windows-prod-apply" title="Windows" group-key="Windows">
      <code-block>
      cat script.sql | docker exec `
      -i [container] psql `
      -U postgres `
      -d postgres
      </code-block>
   </tab>
   <tab id="Else-prod-apply" title="Linux &amp; macOS" group-key="Else">
      <code-block>
      cat script.sql | docker exec \
      -i [container] psql \
      -U postgres \
      -d postgres
      </code-block>
   </tab>
</tabs>
# Migrations

Migrations are handled by [Entity Framework](https://learn.microsoft.com/en-us/aspnet/entity-framework). These are auto-generated files and configurations which enable code-first changes to the database.

## Creating / Editing Entities

Migrations must be created and tested when any of the following is modified:

1. Files in `Database/Entities`. These objects directly link to a database table.
    - Only create a migration when the changes modify the entity such that a database change is required. For example, adding a new field requires a migration, but modifying basic comments do not.
2. `OtrContext.cs`, if there are modifications which change entity relationships.

## Creating Migrations

To create a new migration, run the following in the root directory of the repository.

```Shell
dotnet ef migrations add [Entity_ChangesMade] \
--project Database \
--startup-project API \
--context OtrContext
```

> `[Entity_ChangesMade]` is the name of your migration. Migrations should use PascalCase with underscores separating the entity from the changes made. For example, `Player_ConvertIdToInteger` is a good name for a migration as it describes the change made at a glance.
> 

> When a new migration is created, it will not be tracked by git automatically. Ensure you commit the generated files.
> 
> {style="warning"}

## Removing Migrations

If you need to undo a migration, run the following command to revert the most recent migration.

```Shell
dotnet ef migrations remove \
--project Database \
--startup-project API \
--context OtrContext
```

## Applying Migrations

Run the following to apply any pending migrations to the database. In development, ensure the database appears as you expect it to after applying migrations.

```Shell
dotnet ef database update \
--project Database \
--startup-project API \
--context OtrContext
```

## Apply Migrations in Production

The method of applying migrations is different in development than production. This is because the pipeline does not have access to a running database.

First, a migrations script is generated via the entity framework CLI. Then, the script is piped into the docker container which hosts our database. This method can also be used to apply migrations in development.

To generate the migrations script, run the following in the root directory of the repository:

```Shell
dotnet ef migrations script \
--idempotent \
--project Database \
--startup-project API \
--context OtrContext \
-o script.sql
```

> The `idempotent` flag tells the script to only apply migrations which have not already been applied.
> If you want to configure a database from scratch (e.g. no tables are in the `public` schema),
> remove this flag.
>
> {style="note"}

Apply the migrations:

```Shell
cat script.sql | docker exec \
-i [container] psql \
-U postgres \
-d postgres
```
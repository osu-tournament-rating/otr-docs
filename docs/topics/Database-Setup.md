# Setup

o!TR relies on a PostgreSQL database instance to function. This page can be used as a reference for first-time database setup.

It is recommended to run your database inside a docker container.

## Volume

First, create the docker volume:

```Shell
docker volume create otr-db
```

## Container

Then, start the database:

```Shell
docker run \
-d \
-p 5432:5432 \
-v otr-db:/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=password postgres
```

## Connection

Your database is accessible at `localhost:5432` with the password `password`. Connect to it using a database browser, such as [DataGrip](https://www.jetbrains.com/datagrip/).

### Connection String

In the above example, the following connection string is valid.

```
Server=localhost;Port=5432;User Id=postgres;Password=password;Include Error Detail=true;
```
# Getting Started

## Prerequisites

* Install [git](https://git-scm.com/downloads)
* Install [.NET 9](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
* Install [Docker](https://www.docker.com/)

## Setup

### Clone

```Shell
git clone https://github.com/osu-tournament-rating/otr-api.git
```

### Entity Framework

```
dotnet tool install --global dotnet-ef
```

### PostgreSQL Database

Follow [[o-TR-Database-Setup | this guide]] to set up your local database.

> [!note] 
> The database container must be running for the API to function.

> [!tip] 
> The connection string at the end of the database setup guide may be used as the `ConnectionStrings.DefaultConnection` value in `appsettings.Development.json`.

### Redis

Run the following command:

`docker run -d -p 6379:6379 --name otr-redis redis`

> [!not] 
> The redis container must be running for the API to function.

### Configuration

See [[o-TR-API-Configuration | API Configuration]] to configure the API.

## Run

With a fresh PostgreSQL database instance and other required frameworks installed, the API can now be built and run.

### Test

Run the following in the root directory of the repository:

```Shell
dotnet test
```

### Start

To start the API, execute `dotnet run` in the `API` directory. Or, execute `dotnet run API/API.csproj` from the root directory.

You should see that all tests have passed. Report any build errors or test failures to the project maintainers (assuming you have not modified anything locally and are testing against the `master` branch).

![tests_passing.png](tests_passing.png)

### Environment variables

Ensure the `ASPNETCORE_ENVIRONMENT=Development` environment variable is set while developing. Most IDEs / run configurations will do this for you.

### Recommended IDE

We prefer [JetBrains Rider](https://www.jetbrains.com/rider/) as the IDE of choice for developing this project, though [Visual Studio Code](https://code.visualstudio.com/) and [Visual Studio](https://visualstudio.microsoft.com/) will work fine.
---
aliases:
  - API.Utils.Jwt
---
The JWT Tool is a command-line interface utility written in [.NET](https://learn.microsoft.com/en-us/dotnet/). It generates JSON Web Tokens (JWTs) for use in [[Applications/API/Overview|API]] development. The tool also decodes JWTs and displays their properties which is useful for debugging JWTs created by the API.

JWTs are decoded API-side to identify who is making the request and authorize access to endpoints based on the roles they have.

# Usage

The tool generates JWTs which function as `Bearer` authorization tokens. A common use case is to pass the JWT into Swagger's authorization dialog. This grants access to protected API endpoints (almost all of which require the `user` scope at a minimum).

![[swagger-bearer-auth-example.png]]

>[!tip]
>It is highly recommended to point to a pre-configured `appsettings.json` file. This utility can read all necessary properties directly from that file.
>
>Note: The file name does not matter so long as the content conforms to the [[Configuration|configuration]].

>[!warning]
>The tool will not work unless a valid user ID is passed as an argument. Ensure the `users` table is populated with at least one user before proceeding.

## Prerequisites

- If you have not already done so, configure the API's `appsettings` file (see [[Configuration]]).

To run, navigate to the `API.Utils.JWT` project folder located in the root of the `otr-api` repository. Then run the following command to generate an admin-level authorization token for a given user:

```shell
dotnet run -- --subject <userID> --roles admin -c /path/to/your/appsettings.json
```

> [!tip]
> Multiple roles can be listed, e.g. `admin,verifier`

## Output

The output will look something like this:

```
...
[23:34:00 INF] Token Created
[23:34:00 INF] ----------------------------------------
[23:34:00 INF] eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbi10eXAiOiJhY2Nlc3MiLCJzdWIiOiIyMCIsInJvbGUiOiJ1c2VyIiwiaW5zdCI6IjM4MWYyY2Y3LWE0MDEtNDdiOC1hZGZlLWY1ODNkZGU3OThiZiIsIm5iZiI6MTc0NTk4NDA0MCwiZXhwIjoxNzQ1OTg3NjQwLCJpYXQiOjE3NDU5ODQwNDAsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTA3NSIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJ9.ZlBfBVakV8IJuggGoGpr-TExJ-mZbIondD6dbRecYCs
[23:34:00 INF] ----------------------------------------
```

The encoded string above is your JWT.

# Reading

To read a JWT and display its properties, run the following, where `token` is a JWT:

```
dotnet run -- read -t <token>
```

# Other options

All program options can be viewed using the below commands.

## Generation options

```
dotnet run -- generate --help
```

# Read options

```
dotnet run -- read --help
```
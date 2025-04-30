---
aliases:
  - API.Utils.Jwt
---
The JWT Tool is a simple CLI utility written in [.NET](https://learn.microsoft.com/en-us/dotnet/) which allows users to generate JSON Web Tokens (JWTs) for use in development of the [[Applications/API/Overview|API]]. This tool also supports reading and decoding JWTs to display their properties, useful for debugging JWTs produced by the API.

# Usage

The JWT this tool outputs can be used as a `Bearer` authorization token when making requests to API endpoints locally. Thus, it can be plugged into Swagger for convenient local authorization during API development.

![[swagger-bearer-auth-example.png]]

>[!tip]
>It is highly recommended to point to a pre-configured `appsettings.json` file. This utility can read all necessary properties directly from that file.

>[!warning]
>There must be a user present in the `users` database table in order for the tool to work. This user's ID is what you will pass as an argument below.
>

If you have not already done so, configure the API's `appsettings.Development.json` file (see [[Configuration|configuration]]).

To run, navigate to the `API.Utils.JWT` project folder located in the root of the `otr-api` repository. Then run the following command to generate an admin-level authorization token for a given user:

```shell
dotnet run -- --subject <userID> --roles admin -c /path/to/your/appsettings.json
```

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

To read (decode) a JWT and display its properties, run the following, where `token` is a JWT:

```
dotnet run -- read -t <token>
```

# Other options

To view all of the program options, see below.

## Generation options

```
dotnet run -- generate --help
```

# Read options

```
dotnet run -- read --help
```
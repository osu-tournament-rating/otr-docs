---
aliases:
  - API.Utils.Jwt
tags:
  - application
---

The JWT Tool is a command-line interface utility written in [.NET](https://learn.microsoft.com/en-us/dotnet/). It generates JSON Web Tokens (JWTs) for use in [[Applications/API/Overview|API]] development. The tool can also decode JWTs and display their properties which is useful for debugging JWTs created by the API.

JWTs are decoded API-side to identify who is making the request and authorize access to endpoints based on the roles they have.

# Usage

The tool generates JWTs which function as `Bearer` authorization tokens. A common use case is to pass the JWT into Swagger's authorization dialog. This grants access to protected API endpoints (almost all of which require the `user` scope at a minimum, which the JWT tool encodes by default).

![[swagger-bearer-auth-example.png]]

> [!tip]
> It is recommended to point the utility to a pre-configured `appsettings.json` file as all arguments can be derived from it. The `appsettings.json` file name is irrelevant if the file content matches the [example configuration](https://github.com/osu-tournament-rating/otr-api/blob/master/API/example.appsettings.json).
>
> Alternatively, all arguments may be specified individually. Pass the `--help` argument to see all possible arguments with descriptions.

## Prerequisites

- If passing an `appsettings.json` file, ensure the file passed conforms to the [[Configuration]].

To run, navigate to the `API.Utils.JWT` project folder located in the root of the `otr-api` repository. Then run the following to generate an admin-level authorization token for a given user:

```shell
dotnet run -- --subject <userID> --roles admin -c /path/to/your/appsettings.json
```

> [!tip]
> Multiple roles can be listed, e.g. `admin,verifier`. These roles can be different from the `scopes` assigned to the user in the database.

> [!danger]
> If the user provided does not exist in the database, the tool will still work, but any API endpoints which depend on a specific user (such as `/me`) will break.
> %% When we have a page for setting up a user in the db, this should link there %%

## Output

The output will look something like this, with the encoded string below serving as the JWT.

```
...
[23:34:00 INF] Token Created
[23:34:00 INF] ----------------------------------------
[23:34:00 INF] eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbi10eXAiOiJhY2Nlc3MiLCJzdWIiOiIyMCIsInJvbGUiOiJ1c2VyIiwiaW5zdCI6IjM4MWYyY2Y3LWE0MDEtNDdiOC1hZGZlLWY1ODNkZGU3OThiZiIsIm5iZiI6MTc0NTk4NDA0MCwiZXhwIjoxNzQ1OTg3NjQwLCJpYXQiOjE3NDU5ODQwNDAsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTA3NSIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJ9.ZlBfBVakV8IJuggGoGpr-TExJ-mZbIondD6dbRecYCs
[23:34:00 INF] ----------------------------------------
```

## Options

To see all options:

```
dotnet run -- generate --help
```

# Reading

To read a JWT and display its properties, run the following, where `token` is a JWT:

```
dotnet run -- read -t <token>
```

## Output

The output will look something like this:

```
[13:07:51 INF] Validating options...
[13:07:51 INF] Reading token...
[13:07:52 INF]
[13:07:52 INF] Header:
[13:07:52 INF]
{
"alg": "HS256",
"typ": "JWT"
}
[13:07:52 INF]
[13:07:52 INF] Payload:
[13:07:52 INF]
{
"token-typ": "access",
"sub": "20",
"role": {
"ValueKind": 2
},
"inst": "fa8475b5-fe2c-4c8d-b717-2898ad74f25d",
"nbf": 1746292064,
"exp": 1746295664,
"iat": 1746292064,
"iss": "http://localhost:5075",
"aud": "http://localhost:3000"
}
[13:07:52 INF]
[13:07:52 INF] Sig: '0KfPH9XiLv-5YXf2THdXVIClvw-Tb52UhiHdXQAkJq4'
```

### Fields

The below table explains each output field.

| Field   | Description                                                                                                                                                                                                                                     |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Header  | Describes the token's algorithm and type. In the above example, the algorithm is `HS256` and the type is `JWT`. The example in section 3.1 of [RFC-7519](https://datatracker.ietf.org/doc/html/rfc7519) goes into more detail about this field. |
| Payload | Contains all other encoded JWT properties. See sections 3 and 4 of [RFC-7519](https://datatracker.ietf.org/doc/html/rfc7519) for a thorough explanation of each field with examples.                                                            |

## Options

To see all options:

```
dotnet run -- read --help
```

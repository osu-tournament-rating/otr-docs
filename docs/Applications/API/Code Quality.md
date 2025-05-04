The `otr-api` project enforces specific formatting rules to ensure code quality. These are enforced via `dotnet format`.

## Formatting

To format code to our standards, simply execute the following from the root folder.

```
dotnet format --severity info
```

There are some enforced rules that will _not_ be automatically fixed by dotnet-format. If experiencing any issues, detailed descriptions of violations can be found by running the following command from the root folder.

```
dotnet format --severity info --verify-no-changes --verbosity detailed
```

## Pre-commit Hooks

The codebase also utilizes [Husky](https://alirezanet.github.io/Husky.Net/guide/#features), a tool to locally run scripts before commits are made. The current setup will automatically run the above command on staged changes before any commit is made. If for any reason Husky should need to be disabled, set an environment variable `HUSKY=0` or include the flag `--no-verify` on any `git commit` command. This assumes any staged changes are already correctly formatted. The CI will fail on code quality checks should the code be improperly formatted after using this flag.

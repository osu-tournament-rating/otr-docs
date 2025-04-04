# Getting Started

The o!TR processor requires a working o!TR API instance to function correctly. These applications talk to each other to accomplish one goal: process tournament data.

## Prerequisites

Install the following tools:

- [Rust](https://www.rust-lang.org/)
- [[o-TR-API | Setup o!TR API]]
- [[o-TR-Database | Setup Database]]

## Environment variables

This project utilizes a `.env` file for configuring environment variables. A `env_example` file is provided for reference. The contents are as follows:

```
CONNECTION_STRING=
```

Setup the environment variables:

1. Rename the `env_example` file provided to `.env`.
2. Set the `CONNECTION_STRING` to the database connection string as described [[o-TR-Database-Setup | here]]

## Processing data

Once the o!TR API and database are running and the environment variables are configured, the processor is ready to run.

Run the processor:

```Rust
cargo run -r
```
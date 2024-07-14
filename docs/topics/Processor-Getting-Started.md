# Getting Started

The o!TR processor requires a working o!TR API instance to function correctly. These applications talk to each other to accomplish one goal: process tournament data.

## Prerequisites

Install the following tools:

- [Rust](https://www.rust-lang.org/)
- [Setup o!TR API](o-TR-API.md)

## Environment variables

This project utilizes a `.env` file for configuring environment variables. A `env_example` file is provided for reference. The contents are as follows:

```
API_ROOT=
CLIENT_ID=
CLIENT_SECRET=
```

Setup the environment variables:

<procedure>
<step>
Rename the <code>env_example</code> file provided to <code>.env</code>.
</step>
<step>
Set the <code>API_ROOT</code> value to where the API is running on your local machine. By default, this is <code>http://localhost:5075/api</code>
</step>
<step>
Set the <code>CLIENT_ID</code> value to your o!TR API client's <code>id</code> value.
</step>
<step>
Set the <code>CLIENT_SECRET</code> value to your o!TR API client's <code>secret</code> value.
</step>
</procedure>

> At this time, the procedure for generating a valid o!TR API client is complicated and undocumented.
> 
{style="warning"}

## Processing data

Once the o!TR API and database are running and the environment variables are configured, the processor is ready to run.

Run the processor:

```Rust
cargo run -r
```
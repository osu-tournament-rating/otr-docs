Want to setup the o!TR platform for development? You're in the right place!

## Overview

This document covers:

- Setting up all codebases locally for all core projects (`otr-api/API` ("API"), `otr-api/DWS` ("Data Worker Service", "DWS"), `otr-web` ("web", "website"), `otr-processor` ("processor"))
- What these applications do, at a high level
- Configuring all necessary environment variables
- Working with background services conveniently (database, redis, RabbitMQ)
- Tips from the maintainers

By the end of this guide, you will be able to run and debug all of our software. The author of this guide is also the lead maintainer and it details exactly how to replicate the same setup. If you haven't already done so, read through [[Software Overview]] to understand how each application is designed and how the data flows between applications.

While it is recommended to setup everything, you can skip some application setup depending on your use case:

- If you are only interested in web development, you will still need to run everything besides the processor.
- If you are only interested in generating rating outputs to the database directly, you will need to setup the processor project and RabbitMQ at a minimum. Even if the queue doesn't have consumers, it still needs to be running for the Processor to function.*

## Local Development

This section covers each step required to get started with running and debugging platform code. Here's a high level overview of what needs to be done to get started with local development:

- Install all prerequisites 
- Clone relevant repositories
- Setup necessary configuration files
- Use `docker compose` to conveniently manage the database, redis, and RabbitMQ

### Prerequisites

- Install [Docker](https://www.docker.com/)
- Install [.NET 9](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
- Install the latest LTS version of [Node](https://nodejs.org/en/download)
- Download the latest available [public replica](https://data.otr.stagec.xyz/)

To get started with local development, start by cloning each repository. It's recommended to make an `otr/` folder for organization of these projects:

Clone `otr-api`,  `otr-web` and `otr-processor`

```
mkdir -p (your-directory)/otr
cd (your-directory)/otr

git clone https://github.com/osu-tournament-rating/otr-api.git
git clone https://github.com/osu-tournament-rating/otr-web.git
git clone https://github.com/osu-tournament-rating/otr-processor.git
```

### Database, Redis, and RabbitMQ

The easiest part to setup is each of these three tools. They will run in the background and will be kept alive so long as Docker is running in the system.

#### Step 1: Configuration

Navigate to the `otr-api/cfg` directory and copy the template `.env` files:

```
cp db.env.example db.env
cp rabbitmq.env.example rabbitmq.env
```

Replace the content of `db.env` with `POSTGRES_PASSWORD=password`. No modifications to `rabbitmq.env` are necessary, and redis does not have any configuration.

#### Step 2: Run

Run these three tools by running `docker compose --profile staging up db redis rabbitmq -d`. 

![[Screenshot_20250824_134335.png]]
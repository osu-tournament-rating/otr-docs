The o!TR platform relies on multiple projects and technologies to function. These projects were recently overhauled to incorporate [queueing](https://en.wikipedia.org/wiki/Message_queue). This is a very important aspect of our architecture to be aware of in order to understand how data flows throughout the system.

This section details the high-level architecture of the platform and each software project. To skip straight to development, jump to [[Development/Development Guide|the development guide]].

### Queueing

Here are a few scenarios that showcase exactly how data flows across applications using a message broker (powered by [RabbitMQ](https://www.rabbitmq.com/)).

#### Tournament Submission

1. Admin submits tournament
2. Web makes API call, API enqueues messages for each osu! beatmap/match ID provided
3. The queues `data.osu.matches` and `data.osu.beatmaps` are now not empty, so DWS activates to empty these queues by fetching data from the osu! API
4. Once all queues are empty, DWS enqueues a message to `processing.checks.tournaments` to run automated checks for that tournament
5. The `processing.checks.tournaments` queue sees a new message and runs automated checks for the tournament

#### Resetting automated checks

1. Admin clicks button to reset automated checks for a tournament
2. Web makes API call, API enqueues a message to reset automated checks for the tournament
3. Automated checks are reset by `processing.checks.tournaments` queue consumer (DWS).

As you can see, there's a pattern here. Usually, the API publishes new queue messages, but the great thing about queues is that anyone can publish a new queue message. This means the processor can publish queue messages to regenerate stats after generating ratings for all tournaments. Another benefit of this architecture is that the queue will always be live, so even if the DWS goes down, it will resume right where it left off when it's started again.

### API

The API, located under `otr-api/API`, is the heart of the platform and enables web and third-party users to read and write data. This is a [.NET](https://dotnet.microsoft.com/en-us/) project which uses [Entity Framework](https://learn.microsoft.com/en-us/aspnet/entity-framework) as the [ORM](https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping).

The API supports metrics and monitoring through [Grafana](https://grafana.com/). All authorization and authentication (i.e. "login with osu!" functionality) is handled by the API. The API also supports [JWT](https://www.jwt.io/) authentication by passing a `Authorization: Bearer <token>` header. A JWT can be created using the JWT Tool, located under `otr-api/API.Utils.Jwt`. This JWT can be used as valid authorization in swagger/postman.

### DWS

The Data Worker Service, or "DWS" for short, is a [.NET](https://dotnet.microsoft.com/en-us/) application which fetches all external API data, generates most statistics, and runs all [[Automated Checks|automated checks]]. This application relies on message queues to know when to fetch data, what data to fetch, and what tournaments need stats or automated checks to be processed.

The DWS natively supports message queue priority, which the platform also relies on. For instance, while the processor enqueues all tournaments for stats processing after running, if an admin wants an immediate stat update for a certain tournament, this can be enqueued at the highest priority, skipping all current stat processing messages.

### Processor

The processor is a [Rust](https://www.rust-lang.org/) project which is designed to be infrequently called by a cron job. This application looks at all verified tournament data and builds a rating network from individual match data by utilizing [OpenSkill](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf), an open-source multiplayer rating algorithm. The Rust processor also generates placements at runtime, which are effectively match standings. These are saved in the database at the score level and are a record of how the processor "ranked" each participant (which directly influences who gains or loses rating).

## Web

Last but not least, the website. This is a [Next.JS](https://nextjs.org/) project which allows anyone to view our tournament data [online](https://otr.stagec.xyz/). [React](https://react.dev/) v19, [Tailwind](https://tailwindcss.com/) CSS v4, and [shadcn-ui](https://ui.shadcn.com/) are utilized in this project.

The website utilizes the `otr-api-clients` project's TypeScript API wrapper for all API calls. Whenever a breaking API change is made, the `otr-api-clients` project is updated, which means a version bump is made to the package in the website. The website and API are expected to be in sync at all times so that unexpected breakages do not occur.

In hindsight, Next.JS isn't the best choice for a frontend with a separated backend. However, we've managed to make it work and won't bother with rewriting in a different framework; *c'est la vie*.

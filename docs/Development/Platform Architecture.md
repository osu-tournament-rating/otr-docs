The o!TR platform relies on multiple projects and technologies to function. These projects were recently overhauled to incorporate [queueing](https://en.wikipedia.org/wiki/Message_queue). This is a very important aspect of our architecture to be aware of in order to understand how data flows throughout the system.

This section details the high-level architecture of the platform and each software project. To skip straight to development, jump to the [[Development/Development Guide|development guide]].

### Queueing

Here are a few scenarios that showcase exactly how data flows across applications using a message broker (powered by [RabbitMQ](https://www.rabbitmq.com/)).

#### Tournament submission

1. Admin submits tournament
2. The web backend enqueues messages for each osu! beatmap/match ID provided
3. The queues `data.osu.matches` and `data.osu.beatmaps` are now not empty, so the data worker activates to empty these queues by fetching data from the osu! API
4. Once all queues are empty, the data worker enqueues a message to `processing.checks.tournaments` to run automated checks for that tournament
5. The `processing.checks.tournaments` queue sees a new message and runs automated checks for the tournament

#### Resetting automated checks

1. Admin clicks button to reset automated checks for a tournament
2. The web backend enqueues a message to reset automated checks for the tournament
3. Automated checks are reset by the `processing.checks.tournaments` queue consumer (data worker).

As you can see, there's a pattern here. Usually, the web backend publishes new queue messages, but the great thing about queues is that anyone can publish a new queue message. This means the processor can publish queue messages to regenerate stats after generating ratings for all tournaments. Another benefit of this architecture is that the queue will always be live, so even if the data worker goes down, it will resume right where it left off when it's started again.

### Web application

The web application, located under `otr-web/apps/web`, is both the public-facing site and our API layer. It runs on [Next.js](https://nextjs.org/) using Bun and features server-side rendered pages, oRPC procedures, and auth management via BetterAuth.

### Data worker

The data worker lives under `otr-web/apps/data-worker`. This Bun-based application consumes and publishes RabbitMQ messages to fetch external osu! data, generate statistics, and run all [[Automated Checks|automated checks]]. The worker relies on queues to know when to fetch data, what data to fetch, and which tournaments need stats or automated checks to be processed.

The data worker natively supports message queue priority, which the platform also relies on. For instance, while the processor enqueues all tournaments for stats processing after running, if an admin wants an immediate stat update for a certain tournament, this can be enqueued at the highest priority, skipping all current stat processing messages.

### Processor

The processor is a [Rust](https://www.rust-lang.org/) project which is designed to be infrequently called by a cron job. This application looks at all verified tournament data and builds a rating network from individual match data by utilizing [OpenSkill](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf), an open-source multiplayer rating algorithm. The Rust processor also generates placements at runtime, which are effectively match standings. These are saved in the database at the score level and are a record of how the processor "ranked" each participant (which directly influences who gains or loses rating).

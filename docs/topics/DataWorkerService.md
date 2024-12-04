# DataWorkerService

The [DataWorkerService](https://github.com/osu-tournament-rating/otr-api/tree/master/DataWorkerService) is a program which is part of
the [](o-TR-API.md) repository. This program is a service which continuously polls the database for items which need to be processed. This includes the following processes:

* Fetching match data from the [osu! API](https://osu.ppy.sh/docs/index.html).
* Fetching historical player data from the [osu!track API](https://github.com/Ameobea/osutrack-api).
* Running [automated checks](Automated-Checks.md) against tournament data.
* Performing stat calculations, such as match cost and forming placements (required by the [](o-TR-Processor.md)).

## Core Principles

This system is designed with the following principals in mind:

1. Human reviewers have authority over whether an entity is `Verified` or `Rejected`. As such, the system will never automatically assign these designations.
2. The automatic application of the `PreRejected` status must be as accurate as possible, based on concrete rules.
3. The process must be as transparent as possible. As such, the system tracks all changes to entities in the `audit` tables. Additionally, all entities have a `RejectionReason` enum which defines a combination of reasons why it was marked as rejected by either the system or human reviewer.
4. Do not include entities which are not `Verified` in the tournament rating algorithm.
    * Even with manually submitted data, humans make mistakes. If unverified data is introduced, users may notice invalid stats or inaccurate rating calculations, and it may be easier for bad actors to influence the algorithm.

## Entities

The following entities are part of this processing pipeline:

* `Tournaments`
* `Matches`
* `Games`
* `GameScores`

## Statuses

Each entity has `VerificationStatus`, `ProcessingStatus`, and `RejectionReason` fields. These fields are referenced and changed by the DataWorkerService as they move through the processing flow.

### `VerificationStatus`

Each entity shares the same `VerificationStatus` type. This type contains the following statuses:

* `None`: The entity has yet to be processed automatically.
* `PreRejected`: Based on the system's rules, this entity should be rejected.
* `PreVerified`: The system did not find anything wrong, awaiting human review.
* `Rejected`: A human marked this entity as rejected.
* `Verified`: A human marked this entity as verified.

### `ProcessingStatus`

Each entity has a unique `ProcessingStatus` type associated with it. This flag is self-explanatory: it indicates how far along an entity is in the processing pipeline.

For example, consider `TournamentProcessingStatus`:

1. `NeedsApproval`: The tournament is submitted but awaiting approval from a verifier.
2. `NeedsMatchData`: Match data needs to be fetched via the osu! API.
3. `NeedsAutomationChecks`: The tournament, and all of its children, are awaiting automation checks.
4. `NeedsVerification`: The tournament has been checked and is awaiting human review.
5. `NeedsStatCalculation`: After human review, process statistics (must be complete before it is eligible for inclusion in the rating system).
6. `Done`: Processing is completed. `Verified` tournaments with this status are eligible for inclusion in the rating system.

### `RejectionReason`

Each entity has a custom `RejectionReason` type with various flags which may cause it to be marked as `PreRejected`. Flags can be combined with each other to form a set of reasons. For example, a `Game` could be marked as `PreRejected` by the system due to `NoScores` and `BeatmapNotPooled`.
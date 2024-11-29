# Automated Checks

The [DataWorkerService](DataWorkerService.md) has numerous responsibilities, one of them being a data processing step known as automated checks. These checks are responsible for processing various portions of data depending on the current processing step for a particular piece of data.

## Core Principals

When designing this system, we did so with the following principles in mind:

1. Human reviewers have authority over whether an entity is `Verified` or `Rejected`. As such, the system will never automatically assign these designations.
2. The automatic application of the `PreRejected` status must be as accurate as possible, based on concrete rules.
3. The process must be as transparent as possible. As such, the system tracks all changes to entities in the `audit` tables. Additionally, all entities have a `RejectionReason` enum which defines a combination of reasons why it was marked as rejected by either the system or human reviewer.
4. Do not include entities which are not `Verified` in the tournament rating algorithm.
    * This provides an added benefit of ensuring all generated statistics are valid. Even with manually submitted data, humans make mistakes. If unverified data is introduced into the rating & statistics systems, users will notice invalid statistics and the rating ladder itself will not be completely accurate.

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

1. `NeedsApproval`: The tournament is submitted but waiting approval from a verifier.
2. `NeedsMatchData`: Match data needs to be fetched via the osu! API.
3. `NeedsAutomationChecks`: The tournament, and all of its children, are awaiting automation checks.
4. `NeedsVerification`: Awaiting human review
5. `NeedsStatCalculation`: After human review, process statistics (must be complete before it is eligible for inclusion in the rating system).
6. `Done`: Processing is completed. `Verified` tournaments with this status are eligible for inclusion in the rating system.

### `RejectionReason`

Each entity has a custom `RejectionReason` type with various flags which may cause it to be marked as `PreRejected`. Flags can be combined with each other to form a set of reasons. For example, a `Game` could be marked as `PreRejected` by the system due to `NoScores` and `BeatmapNotPooled`.

## Flow

### Tournament

```Mermaid
graph TD;
   A[Is the count of PreVerified and/or Verified matches >= 0?]
   B[Apply NoVerifiedMatches flag to RejectionReason]
   C[Is this count >= 80% of the total match count?]
   D[Apply NotEnoughVerifiedMatches flag to RejectionReason]
   End[Change VerificationStatus to PreVerified]
   
   A -- No --> B
   A -- Yes --> C
   C -- No --> D
   C -- Yes --> End
```

### Match

```Mermaid
graph TD;
   A[Is the count of games > 2?]
   B[Do any games besides the first 2 have a 
      RejectionReason of BeatmapNotPooled?]
   C[Apply UnexpectedBeatmapsFound to WarningFlags]
   D[Is the match's EndTime property equal to 
   2007-09-17-00:00:00?]
   E[Apply NoEndTime flag to RejectionReason]
   H[Is the match name structured in a typical 
      format?]
   I[Apply UnexpectedNameFormat to WarningFlags]
   J[Does the match name start with the tournament's 
      abbreviation?]
   K[Apply NamePrefixMismatch flag to RejectionReason]
   L[Is the tournament's lobby size equal to 1?]
   M[Are the games structured in a way which supports 
      conversion to TeamVS?]
   N[Attempt to convert a full set of Head to Head games to TeamVS]
   O[Apply FailedTeamVsConversion flag to RejectionReason, repeat 
      for all child games]
   P[Convert all games to TeamVS, mark all games as PreVerified]
   
   F[Is the count of games equal to 0?]
   G[Apply NoGames flag to RejectionReason]
   Q[What is the count of PreVerified and/or Verified games?]
   Q1[0]
   Q2[1 or 2]
   Q3[4 or 5]
   Q4[&gt;5]
   Q_A[Apply NoValidGames flag to RejectionReason]
   Q_B[Apply UnexpectedGameCount flag to RejectionReason]
   Q_C[Apply LowGameCount to WarningFlags]
   
   PreTerm[Is the RejectionReason null?]
   TermPositive[Change VerificationStatus to PreVerified]
   
   A -- Yes --> B
   B -- Yes --> C --> D
   A -- No --> D
   B -- No --> D
   D -- Yes --> E --> H
   D -- No --> H
   
   H -- No --> I --> J
   H -- Yes --> J
   J -- No --> K --> L
   J -- Yes --> L
   L -- No --> F
   L -- Yes --> M
   M -- Yes --> N
   M -- No --> F
   N -- Fail --> O --> F
   N -- Success --> P --> F
   F -- No --> Q
   F -- Yes --> G
   Q --> Q1
   Q --> Q2
   Q --> Q3
   Q --> Q4
   Q1 --> Q_A
   Q2 --> Q_B
   Q3 --> Q_C
   Q4 --> PreTerm
   PreTerm -- Yes --> TermPositive
```

## FAQ

### How can a human manually mark all entities as `Verified`?

Most of the issues which require manual intervention are at the `Match` and `Game` levels. For example, if a `Match` has too many invalid games, it will be marked as `PreRejected` and require manual intervention. The same is true for `Game`s.

For `GameScore` entities, there are very concrete rules which can easily determine whether it should be `Rejected`, for example if the `Score` value is below the minimum.

We also have a web interface which allows reviewers to mark an entity - and all of its children - as `Verified` or `Rejected`. Generally speaking, if at a glance everything is marked as `PreVerified`, very little effort is required to manually approve these submissions. If the opposite is true, it's likely that the submission contains invalid data.

### In what cases should a human reviewer override a `PreRejected` status?

One example of where this should happen is [Corsace Open 2023](https://osu.ppy.sh/community/forums/topics/1794106?n=1). This tournament has numerous matches marked as `PreRejected` by the system due to not having matches which consistently use the same prefix. This is a case in which the human reviewer should manually override the system's `PreRejected` status (assuming the `RejectionReason`s are of type `MatchRejectionReason.NamePrefixMismatch`).

![CleanShot 2024-11-29 at 09.12.53@2x.png](../images/co23-example.png)
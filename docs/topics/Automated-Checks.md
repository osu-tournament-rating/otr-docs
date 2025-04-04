# Automated Checks

The [[DataWorkerService]] has numerous responsibilities, one of them being a data processing step known as automated checks. These checks are responsible for identifying, flagging, and in some cases fixing various discrepancies found in our data.

## Flow

Automation checks are performed in the following order.

```mermaid
flowchart LR;
    GameScore --> Game --> Match --> Tournament
```

> [!note]
> This allows the parent entities to have the context of how their children fared during the automated checks process.

The following elements contain flowcharts that give detailed information on each step of the automation order. 

> [!info]- Tournament
> ```mermaid
>	graph TD
>	
>	A[Is the count of PreVerified and/or Verified matches > 0?]
>	B[Apply NoVerifiedMatches flag to RejectionReason]
>	C[Is this count at least 80% of the total match count?]
>	D[Apply NotEnoughVerifiedMatches flag to RejectionReason]
>	PreTerm[Is the RejectionReason null?]
>	TermPositive[Change VerificationStatus to PreVerified]
>	TermNegative[Change VerificationStatus to PreRejected]
>	A -- No --> B --> PreTerm
>	A -- Yes --> C
>	C -- No --> D --> PreTerm
>	C -- Yes --> PreTerm
>	PreTerm -- Yes --> TermPositive
>	PreTerm -- No --> TermNegative
> ```

> [!info]- Match
> ```mermaid
> flowchart TD;
> 	A[Is the count of games > 2?]
> 	B[Do any games besides the first 2 have a RejectionReason of BeatmapNotPooled?]
> 	C[Apply UnexpectedBeatmapsFound to WarningFlags]
> 	D[Is the EndTime property equal to 2007-09-17-00:00:00?]
> 	E[Apply NoEndTime flag to RejectionReason]
> 	H[Is the match name structured in a typical format?]
> 	I[Apply UnexpectedNameFormat to WarningFlags]
> 	J[Does the match name start with the tournament's abbreviation?]
> 	K[Apply NamePrefixMismatch flag to RejectionReason]
> 	L[Is the tournament's lobby size equal to 1?]
> 	M[Are the games structured in a way which supports conversion to TeamVS?]
> 	N[Attempt to convert a full set of Head to Head games to TeamVS]
> 	O[Apply FailedTeamVsConversion flag to RejectionReason, repeat for all games]
> 	P[Convert all games to TeamVS, mark all games as PreVerified]
> 	F[Is the count of games equal to 0?]
> 	G[Apply NoGames flag to RejectionReason]
> 	Q[What is the count of PreVerified and/or Verified games?]
> 	Q1[0]
> 	Q2[1 to 3]
> 	Q3[4 or 5]
> 	Q4[5 or more]
> 	Q_A[Apply NoValidGames flag to RejectionReason]
> 	Q_B[Apply UnexpectedGameCount flag to RejectionReason]
> 	Q_C[Apply LowGameCount to WarningFlags]
> 	PreTerm[Is the RejectionReason null?]
> 	TermPositive[Change VerificationStatus to PreVerified]
> 	TermNegative[Change VerificationStatus to PreRejected]
> 	A -- Yes --> B
> 	B -- Yes --> C --> D
> 	A -- No --> D
> 	B -- No --> D
> 	D -- Yes --> E --> H
> 	D -- No --> H
> 	H -- No --> I --> J
> 	H -- Yes --> J
> 	J -- No --> K --> L
> 	J -- Yes --> L
> 	L -- No --> F
> 	L -- Yes --> M
> 	M -- Yes --> N
> 	M -- No --> F
> 	N -- Fail --> O --> F
> 	N -- Success --> P --> F
> 	F -- No --> Q
> 	F -- Yes --> G
> 	Q --> Q1
> 	Q --> Q2
> 	Q --> Q3
> 	Q --> Q4
> 	Q1 --> Q_A --> PreTerm
> 	Q2 --> Q_B --> PreTerm
> 	Q3 --> Q_C --> PreTerm
> 	Q4 --> PreTerm
> 	PreTerm -- Yes --> TermPositive
> 	PreTerm -- No --> TermNegative
> ```

> [!info]- Game
> ```mermaid
> flowchart TD;
> 	A[Is the beatmap null?]
> 	B[Is there a known mappool for the tournament?]
> 	C[Of all games in the tournament, is the beatmapused exactly once?]
> 	D[Apply BeatmapUsedOnce to WarningFlags]
> 	E[Is the beatmap in the known mappool for the tournament?]
> 	F[Apply BeatmapNotPooled flag to RejectionReason]
> 	G[Is the EndTime property equal to2007-09-17-00:00:00?]
> 	H[Apply NoEndTime flag to RejectionReason]
> 	I[Are invalid mods present at the game level?]
> 	J[Apply InvalidMods flag to RejectionReason]
> 	K[Does the ruleset match the tournament's ruleset?]
> 	L[Apply RulesetMismatch flag to RejectionReason]
> 	M[Is the count of scores 0?]
> 	N[Apply NoScores flag to RejectionReason]
> 	O[Is the count of PreVerified and/or Verified scores 0?]
> 	P[Apply NoValidScores flag to RejectionReason]
> 	Q[Is the count of PreVerified and/or Verified scores twice that of the tournament's LobbySize?]
> 	R[Apply LobbySizeMismatch flag to RejectionReason]
> 	S[Is the ScoringType ScoreV2?]
> 	T[Apply InvalidScoringType flag to RejectionReason]
> 	U[Is the TeamType TeamVs?]
> 	V[Apply InvalidTeamType flag to RejectionReason]
>    PreTerm[Is the RejectionReason null?]
>    TermPositive[Change VerificationStatus to PreVerified]
>    TermNegative[Change VerificationStatus to PreRejected]
> 	A -- Yes --> G
> 	A -- No --> B
> 	B -- Yes --> C
> 	B -- No --> G
> 	C -- Yes --> D --> E
> 	C -- No --> E
> 	E -- Yes --> G
> 	E -- No --> F --> G
> 	G -- Yes --> H --> I
> 	G -- No --> I
> 	I -- Yes --> J --> K
> 	I -- No --> K
> 	K -- Yes --> M
> 	K -- No --> L --> M
> 	M -- Yes --> N --> S
> 	M -- No --> O
> 	O -- Yes --> P --> S
> 	O -- No --> Q
> 	Q -- Yes --> S
> 	Q -- No --> R --> S
> 	S -- No --> T --> U
> 	S -- Yes --> U
> 	U -- No --> V --> PreTerm
> 	U -- Yes --> PreTerm
> 	PreTerm -- Yes --> TermPositive
> 	PreTerm -- No --> TermNegative
> ```

> [!info]- GameScore
> ```mermaid
> flowchart TD;
> 	A[Is the score value > 1,000?]
> 	B[Apply ScoreBelowMinimum flag to RejectionReason]
> 	C[Does the score contain invalid mods?]
> 	D[Apply InvalidMods flag to RejectionReason]
> 	E[Does the ruleset match the tournament's ruleset?]
> 	F[Apply RulesetMismatch flag to RejectionReason]
> 	PreTerm[Is the RejectionReason null?]
> 	TermPositive[Change VerificationStatus to PreVerified]
> 	TermNegative[Change VerificationStatus to PreRejected]
> 	A -- No --> B --> C
> 	A -- Yes --> C
> 	C -- Yes --> D --> E
> 	C -- No --> E
> 	E -- Yes --> PreTerm
> 	E -- No --> F --> PreTerm
> 	PreTerm -- Yes --> TermPositive
> 	PreTerm -- No --> TermNegative
> ```

## FAQ

### How can a human manually mark all entities as `Verified`?

Most of the manual review process occurs at the `Match` and `Game` levels. For example, if a `Match` has too many invalid games, it will be marked as `PreRejected` and require manual intervention. The same is true for `Game`s.

For `GameScore` entities, there are concrete rules which determine whether it should be `PreRejected`, for example if the `Score` value is below the minimum (and thus very likely comes from a referee in the lobby or other anomaly). It is rare for a `GameScore`'s `PreRejected` flag to be manually overturned.

Additionally, a web interface exists which allows reviewers to mark an entity - and all of its children - as `Verified` or `Rejected`. Generally speaking, if at a glance everything is marked as `PreVerified`, little effort is required to manually approve these submissions as they can be approved in one click.

### In what cases should a human reviewer override a `PreRejected` status?

One example of where this should happen is [Corsace Open 2023](https://osu.ppy.sh/community/forums/topics/1794106?n=1). This tournament has numerous matches marked as `PreRejected` by the system due to not having matches which consistently use the same prefix. This is a case in which the human reviewer should manually override the system's `PreRejected` status (assuming the `RejectionReason`s are of type `MatchRejectionReason.NamePrefixMismatch`).

![](co23-example.png)

More comprehensive considerations for various rejection reasons are documented on the [[Data-Verification|Data Verification]] page.
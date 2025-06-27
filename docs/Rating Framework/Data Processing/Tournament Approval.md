The o!TR team requires tournaments meet the criteria below before being accepted into our rating system. Please note that the team reserves the final say on whether a specific tournament is deemed fair for acceptance into our system.

> [!note]
> A comprehensive page of all submitted tournaments and their respective approval status can be seen [here](https://otr.stagec.xyz/tournaments)
> For more details on the verification review process, see [[Data Verification|this page]].

The following is a reference on what constitutes an acceptable tournament and how to submit new data.

## Acceptance criteria

In order for a tournament to be accepted into the o!TR system for rating calculation, it must generally abide by the following guidelines. The o!TR team may make exceptions to the criteria below, but any such cases will be clearly documented with admin notes explaining the circumstances.

> [!note]
> Badge eligibility is **not** a requirement for acceptance.

1. Feature a bracket size of at least Round of 8 double elimination.

2. Publicly document all match links to an acceptable standard, such as through a public Google sheet.

3. Not have significant lapses in data, such as missing a full round of matches or a large amount of forfeits.
    - Exceptions are made for older tournaments for the sake of preservation

4. Not present any signs of serious foul play or rigging.

5. Target an acceptable skill range of players[^1].
    - For osu!, the minimum rank restriction is `#150,000+` (`#75,000+` for regional tournaments).
    - For osu!taiko, osu!catch, and osu!mania, there is no restriction on rank range.

6. Have a forum post or wiki page hosted on the osu! website.

7. Use the [ScoreV2](https://osu.ppy.sh/wiki/en/Gameplay/Game_modifier/ScoreV2) win condition throughout the tournament.

8. Avoid using unconventional mods such as Sudden Death, Perfect, Relax, etc.

9. Not use variable lobby sizes or [game modes](https://osu.ppy.sh/wiki/en/Game_mode). Examples include:
    - "Battle Royale" tournaments.
    - Multi-mode tournaments.
    - Free For All tournaments.

10. Feature a format that allows players to play at their full competitive strength throughout the whole match.

11. Feature a minimal amount of asynchronous matches.

> [!example]
>
> - [BATBALL's Gimmick Emporium](https://osu.ppy.sh/community/forums/topics/1767170?n=1) is considered barely acceptable despite restrictions on how many maps each player may win for their team.
> - [Pokémon Battle Tournament](https://osu.ppy.sh/community/forums/topics/1790791?n=1) is considered barely unacceptable due to the special HP / targeting rules.

### osu!mania

In addition to the above criteria, osu!mania tournaments must:

1. Be of the 4-key or 7-key variants.
2. Not feature a format where multiple key counts are played simultaneously.

## Submission

When submitting a tournament, follow these steps:

1. Ensure the tournament is finished.
2. Gather all match links from bracket stages (and group stages if applicable).
    - Exclude links from qualifiers, tryouts, or show matches.

3. Gather all beatmap IDs pooled in the tournament, _including qualifiers_ and group stages[^2].
    - Note that we are asking for the _beatmap_ ID and not the _beatmapset_ ID. For example, enter 75 rather than 1 for [this beatmap](https://osu.ppy.sh/beatmapsets/1#osu/75)

4. Enter the above data along with requested general tournament information on the [website submission form](https://otr.stagec.xyz/submit).

Additionally, keep the following in mind for tiered tournaments or tournaments that feature multiple divisions:

> [!warning]
> Carefully check how the tournament defines the word "tier". The o!TR team considers "tiered" tournaments to be **tournaments where multiple rank ranges are participating within the same bracket** (usually on the same team). In cases where multiple brackets are used, we use the term **division**.

1. Tiered tournaments must be submitted as a single tournament. In this case, for the rank range field, denote the rank as the top-end rank restriction for the tournament.
    - [Here's](https://otr.stagec.xyz/tournaments/525) an example of a tiered tournament.

2. For divisional tournaments, submit them as separate tournaments - **one submission per bracket**. Append "Division 1", "Division 2", etc. to the tournament's title when submitting.
    - [Here](https://otr.stagec.xyz/tournaments/2349) [are](https://otr.stagec.xyz/tournaments/2350) [examples](https://otr.stagec.xyz/tournaments/2351) of multiple divisions of the same tournament.

## FAQ

### How far back can submissions be from?

Any tournament may be submitted from any time period. Make sure to do quality checks against our [[Tournament Approval#Acceptance criteria|acceptance criteria]].

### What if the tournament I want to submit is missing matches?

If the tournament is not yet finished, do not submit it. If a very old tournament is missing some rounds of data, it is okay to submit it anyway as we do care about data preservation. If a recent (~2021 onwards) tournament is missing rounds, or you're not sure, please ask in our [[Contact#Quick links|Discord Server]].

### Is it okay for two tournaments to share the same abbreviation?

Yes, this is fine.

### What about weird abbreviations?

If a tournament uses inconsistent abbreviations, please inform an o!TR team member after submitting. When submitting, in the abbreviation field, write the most consistent portion. For example, if a tournament has a scheme like so: `IGTS RO16`, `IGTS QF`, only write `IGTS` in the submission field.

### What's the best way to gather match links?

We know how time-consuming it is to gather links. There's a few methods we use for this:

- Contact the tournament host, spreadsheet owner, referee, or anyone else who may have access to that tournament's match data. Kindly ask them for a list of links or match ids.
- Assuming the data may be on a Google sheet, an alternative is to use the `=IMPORTRANGE()` function on the cells with the match links to import them to a new sheet. You can then extract the links in the new sheet with a script detailed in [here](https://stackoverflow.com/a/67206954).
- When in doubt, have the tournament's spreadsheet maintainers [[Contact|Contact us]].

### How can invalid data be flagged for review?

Invalid data, such as warmups, show matches, or any other data that should not be in our system are mostly being detected via [[Automated Checks|automated checks]] and will also be reportable in the future. For now, know that this data does not significantly affect rating values, but please note it down so you can let us know later!

[^1]: This restriction exists in order to avoid “farming” of rating in isolated pockets of newer tournament players.
[^2]: This data is used as part of our [[Automated Checks|automated checks]] to filter out warmups and generate additional tournament statistics.

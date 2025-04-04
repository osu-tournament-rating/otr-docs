# Tournament Approval

The o!TR team requires tournaments meet the criteria below before being accepted into our rating system. Please note that the team reserves the final say on whether a specific tournament is deemed fair for acceptance into our system.

> [!note] 
> A list of all reviewed tournaments may be viewed [here](https://docs.google.com/spreadsheets/d/1F6yBKfVQqkusVxoIEEBP9j4l0h52D0tPHODGXQqCau8/edit?usp=sharing). More details will be accessible on the website during the beta phase.
> For more details on the verification review process, see [[Data-Verification | this page]].


The following is a reference on what constitutes an acceptable tournament and how to submit new data.

## Acceptance criteria

In order for a tournament to be accepted into the o!TR system for rating calculation, it must generally abide by the following rules. The o!TR team may make exceptions to the criteria below, but any such cases will be clearly documented with admin notes explaining the circumstances.
<br>

1. Feature a bracket size of at least Round of 8 double elimination.
2. Publicly document all match links to an acceptable standard, such as through a public Google sheet.
3. Not have significant lapses in data, such as missing a full round of matches.
> [!note]
> Exceptions are made for very old tournaments for the sake of preservation.

4. Be organized to an acceptable standard.
> [!example]
> Tournaments that have been rigged or have serious foul play issues will not be included.

5. Target an acceptable skill range of players.  
   - For osu!, the minimum rank restriction is `#150,000+` (`#75,000+` for regional tournaments).
   - For osu!taiko, osu!catch, and osu!mania, there is no restriction on rank range
   
   > [!note] 
> This restriction is present to avoid "farming" of rating in isolated pockets of newer players in the tournament community.

6. Have a forum post or wiki page hosted on the osu! website.

7. Use the [ScoreV2](https://osu.ppy.sh/wiki/en/Gameplay/Game_modifier/ScoreV2) win condition throughout the tournament.

8. Not use variable lobby sizes or [game modes](https://osu.ppy.sh/wiki/en/Game_mode); in particular, battle-royale tournaments are excluded.

9. Feature a format that allows players to play at their full competitive strength throughout the whole match.

10. Not feature asynchronous matches.


11. Not stray too far from traditional competitive standards.
> [!example]
> - [BATBALL's Gimmick Emporium](https://osu.ppy.sh/community/forums/topics/1767170?n=1) is considered barely acceptable despite restrictions on how many maps each player may win for their team.
> - [Pokémon Battle Tournament](https://osu.ppy.sh/community/forums/topics/1790791?n=1) is considered barely unacceptable due to the special HP / targeting rules.

> [!note]
> Tournaments do not need to be badge-eligible in order to be accepted.

### osu!mania

In addition to the above criteria, osu!mania tournaments must:
<br>
1. Be of the 4-key or 7-key variants.
2. Not feature a format where multiple key counts are played simultaneously.


## Submission

When submitting a tournament, follow these steps:

1. Ensure the tournament is finished.
2. Gather all match links from bracket stages (and group stages if applicable).
> [!danger] 
> Never submit links from qualifiers, tryouts, show matches, or asynchronous matches.

   > [!note]
   > There is no need to worry about warmups or other erroneous data in otherwise valid matches during the initial submission.

3. Gather all beatmap IDs pooled in the tournament, *including qualifiers* and group stages.
> [!warning] 
> Remember to use the beatmap ID rather than the beatmapset ID. For example, enter 75 rather than 1 for [this beatmap](https://osu.ppy.sh/beatmapsets/1#osu/75). 

   > [!note] 
   > Beatmap IDs are used as part of automated checks to filter out warmups from match data.

4. Enter the above data along with requested general tournament information on the [website submission form](https://otr.stagec.xyz/submit).

<br>
Additionally, keep the following in mind for tiered tournaments or tournaments that feature multiple divisions:

> [!warning]
>  Carefully check how the tournament defines the word "tier". The o!TR team considers "tiered" tournaments to be **tournaments where multiple rank ranges are participating within the same bracket** (usually on the same team). In cases where multiple brackets are used, we use the term **division**.

1. Tiered tournaments must be submitted as a single tournament. In this case, for the rank range field, denote the rank as the top-end rank restriction for the tournament.
2. For divisional tournaments, submit them as separate tournaments - **one submission per bracket**. Append "Division 1", "Division 2", etc. to the tournament's title when submitting.

> [!example] 
> For example, say "Test Tournament" has 2 divisions, one that is open rank and one that is for players #1,000+.
> - The first submission would be titled "Test Tournament Division 1" with a rank of "1" on the submission form.
> - The second division would be titled "Test Tournament Division 2" with a rank range of "1000" on the submission form.

<br>

## FAQ

### How far back can submissions be from?

Any tournament may be submitted from any time period. Make sure to do quality checks against our [[Tournament-Approval#Acceptance criteria | acceptance criteria]].

### What if the tournament I want to submit is missing matches?

If the tournament is not yet finished, do not submit it. If a very old tournament is missing some rounds of data, it is okay to submit it anyway as we do care about data preservation. If a recent (~last 2 years or so) tournament is missing rounds, or you're not sure, please ask in our [[Contact#Quick links | Discord Server]].

### Is it okay for two tournaments to share the same abbreviation?

Yes, this is fine.

### What about weird abbreviations?

If a tournament uses inconsistent abbreviations, please inform an o!TR team member after submitting. When submitting, in the abbreviation field, write the most consistent portion. For example, if a tournament has a scheme like so: `IGTS RO16`, `IGTS QF`, only write `IGTS` in the submission field.

### What's the best way to gather match links?

We know how time-consuming it is to gather links. There's a few methods we use for this:

* Contact the tournament host, spreadsheet owner, referee, or anyone else who may have access to that tournament's match data. Kindly ask them for a list of links or match ids.
* Assuming the data may be on a Google sheet, an alternative is to use the `=IMPORTRANGE()` function on the cells with the match links to import them to a new sheet.
   > [!info] 
   > You'll then have a list of cells which each include a hyperlink. From here, you can extract the links with a script detailed in this [Stack Overflow answer](https://stackoverflow.com/a/67206954).

> [!tip] 
> When in doubt, have the tournament's spreadsheet maintainers contact us or ask in our [[Contact#Quick links | Discord Server]].

### How can invalid data be flagged for review?

Invalid data, such as warmups, show matches, or any other data that should not be in our system are mostly being detected via automated checks and will also be reportable in the future. For now, know that this data does not significantly affect rating values, but please note it down so you can let us know later!
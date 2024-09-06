# Tournament Approval

The o!TR team requires tournaments meet the criteria below before being accepted into our rating system. Please note that the team reserves the final say on whether a specific tournament is deemed fair for acceptance into our system.

> A list of all reviewed tournaments may be viewed on [this spreadsheet](https://docs.google.com/spreadsheets/d/1F6yBKfVQqkusVxoIEEBP9j4l0h52D0tPHODGXQqCau8/edit?gid=817877375#gid=817877375).
> 
> *This will be migrated to a web interface at a later date.*
>
{style="note"}

The following is a reference on what constitutes an acceptable tournament and how to submit new data.

## Acceptance criteria

In order for a tournament to be accepted into the o!TR system, it must:

<procedure>
<step>
Feature a bracket size of at least Round of 8 double elimination.
</step>
<step>
Publicly document all match links to an acceptable standard, such as through a public Google sheet.
</step>
<step>
Not have significant lapses in data, such as missing a full round of matches.
<tip>
Exceptions are made for very old tournaments for the sake of preservation.
</tip>
</step>
<step>
Be organized to an acceptable standard.
<tip>
For example, tournaments that have been rigged or have serious foul play issues will not be included.
</tip>
</step>
<step>
Target an acceptable skill range of players.

<list>
<li>For osu!, the minimum rank restriction is <code>#150,000+</code> (<code>#75,000+</code> for regional tournaments).</li>
<li>For osu!taiko, osu!catch, and osu!mania, there is no restriction on rank range.</li>
</list>
> This restriction is present to avoid "farming" of rating in isolated pockets of newer players in the tournament community.
>
{style="note"}
</step>
<step>
Have a forum post or wiki page hosted on the osu! website.
</step>
<step>
Use the <a href="https://osu.ppy.sh/wiki/en/Gameplay/Game_modifier/ScoreV2">ScoreV2</a> win condition throughout the tournament.
</step>
<step>
Not use variable lobby sizes or <a href="https://osu.ppy.sh/wiki/en/Game_mode">game modes</a>; in particular, battle-royale tournaments are excluded.
</step>
<step>
Feature a format that allows players to play at their full competitive strength throughout the whole match.
</step>
<step>
Not feature asynchronous matches.
</step>
<step>
Not stray too far from traditional competitive standards.
<tip>
For example:
<list>
<li><a href="https://osu.ppy.sh/community/forums/topics/1767170?n=1">BATBALL's Gimmick Emporium</a> is considered barely acceptable despite restrictions on how many maps each player may win for their team.</li>
<li><a href="https://osu.ppy.sh/community/forums/topics/1790791?n=1">Pokémon Battle Tournament</a> is considered barely unacceptable due to the special HP / targeting rules.</li>
</list>
</tip>
</step>
</procedure>

> Tournaments do not need to be badge-eligible in order to be accepted.
> 
{style="note"}

### osu!mania

In addition to the above criteria, osu!mania tournaments must:

<procedure>
<step>
Be of the 4-key or 7-key variants.
</step>
<step>
Not feature a format where multiple key counts are played simultaneously.
</step>
</procedure>

## Submission

When submitting a tournament, follow these steps:
<procedure>
<step>
Ensure the tournament is finished.
</step>
<step>
Gather all match links from bracket stages (and group stages if applicable).
<warning>
Never submit links from qualifiers, tryouts, show matches, or asynchronous matches.
</warning>
<tip>
There is no need to worry about warmups or other erroneous data in otherwise valid matches during the initial submission.
</tip>
</step>
</procedure>

Additionally, keep the following in mind for tiered tournaments or tournaments that feature multiple divisions:

> Carefully check how the tournament defines the word "tier". The o!TR team considers "tiered" tournaments to be **tournaments where multiple rank ranges are participating within the same bracket** (usually on the same team). In cases where multiple brackets are used, we use the term **division**.
> 
{style="warning"}

<procedure>
<step>
Tiered tournaments must be submitted as a single tournament. In this case, for the rank range field, denote the rank as the top-end rank restriction for the tournament.
</step>
<step>
For divisional tournaments, submit them as separate tournaments - <b>one submission per bracket</b>. Append "Division 1", "Division 2", etc. to the tournament's title when submitting.
<tip>
For example, say "Test Tournament" has 2 divisions, one that is open rank and one that is for players #1,000+.
<list>
<li>The first submission would be titled "Test Tournament Division 1" with a rank of "1" on the submission form.</li>
<li>The second division would be titled "Test Tournament Division 2" with a rank range of "1000" on the submission form.</li>
</list>
</tip>
</step>
</procedure>

## FAQ

### How far back can submissions be from?

Any tournament may be submitted from any time period. Make sure to do quality checks against our [acceptance criteria](Tournament-Approval.md#acceptance-criteria).

### What if the tournament I want to submit is missing matches?

If the tournament is not yet finished, do not submit it. If a very old tournament is missing some rounds of data, it is okay to submit it anyway as we do care about data preservation. If a recent (~last 2 years or so) tournament is missing rounds, or you're not sure, please ask in our [Discord server](Contact.md).

### Is it okay for two tournaments to share the same abbreviation?

Yes, this is fine.

### What about weird abbreviations?

If a tournament uses inconsistent abbreviations, please inform an o!TR team member after submitting. When submitting, in the abbreviation field, write the most consistent portion. For example, if a tournament has a scheme like so: `IGTS RO16`, `IGTS QF`, only write `IGTS` in the submission field.

### What's the best way to gather match links?

We know how time-consuming it is to gather links. There's a few methods we use for this:

* Contact the tournament host, spreadsheet owner, referee, or anyone else who may have access to that tournament's match data. Kindly ask them for a list of links or match ids.
* Assuming the data may be on a Google sheet, an alternative is to use the `=IMPORTRANGE()` function on the cells with the match links to import them to a new sheet.
> You'll then have a list of cells which each include a hyperlink. From here, you can extract the links with a script detailed in this [Stack Overflow answer](https://stackoverflow.com/a/67206954).

> When in doubt, have the tournament's spreadsheet maintainers contact us or ask in our [Discord server](Contact.md).
> 
{style="note"}

### How can invalid data be flagged for review?

Invalid data, such as warmups, show matches, or any other data that should not be in our system will be reportable in the future on our website. For now, know that this data does not significantly affect rating values, but please note it down so you can let us know later!
# Data Verification

Submitted tournaments run through a series of manual and automated checks before they may be processed for rating calculations. The [](DataWorkerService.md) and [](Automated-Checks.md) pages describe most of the automatic flow, while this page details the manual flow for verifying tournament data and provides more transparency on various conditions. 

## Verifying or rejecting data

Once data finishes running through automated checks, each game score, game, match, and tournament will be marked as either `PreVerified` or `PreRejected`. Typically, `PreVerified` data will end up `Verified` and `PreRejected` data will end up `Rejected` after manual review, and the steps below explain how the o!TR team interprets or modifies these statuses.

<procedure>
<step>
First, general information about the tournament (rank limit, lobby size, any gimmick) is cross-checked against the tournament's wiki page or forum post. If the tournament does not meet the <a href="Tournament-Approval.md#acceptance">acceptance criteria</a>, it will be rejected, meaning that none of the match data will factor into ratings.
<tip>
There is currently no strict numerical cutoff for allowed forfeits or minimum match count per tournament. If there is a particularly small bracket or high percentage of FFs, an admin note will detail the reason for verification or rejection (which will reflect whether the tournament was played in a reasonably competitive environment).
</tip>
</step>
<step>
Next, matches that have been <code>PreRejected</code> or otherwise flagged are considered. If the data is valid but there is a mismatched acronym or other improper formatting (e.g. improper conversion of a head-to-head match to Team VS), those issues may be overridden. If there are an usually small number of games (4 or fewer), verification depends on whether the match was forfeited early. 

<tip>
There may be some ambiguity with partial matches, since they may come from the loser conceding early (in which case the match should be generally verified) or complications due to technical issues or missing players (in which case it may be generally rejected). When in doubt, the original sources of truth -- the tournament bracket or main sheet -- are consulted.
</tip>

<warning>
Pre-rejections due to lobby size mismatches (e.g. async matches or matches where the teams agreed to play 2v2 or 2v3 in a 3v3 tournament) will not be overridden, since they usually indicate extenuating circumstances and hence inaccurate performance prediction.
</warning>
</step>
<step>
After that, reasons for rejection in any <code>PreRejected</code> games in verified matches are looked at more closely. One of the two most common reasons is a lobby size mismatch due to a mid-game disconnect or a "showmap" played at the end of the match for fun; in both cases, since we do not have full information on the true performance of the players, we do indeed reject the game from data.
<tip>
A minimum score check excludes players who were not playing during a game, so that in-lobby referees do not cause a lobby size mismatch. If this causes any legitimate plays to be discarded, then a closer look is taken at the performance of the player overall and whether they were playing legitimately.
</tip>

The other common reason is that the beatmap was detected not to be in the list of beatmap IDs provided at submission. This almost always means a game was played at the beginning or end of the match for fun (and this automation process catches almost all such cases), but if this error is detected for a game in the middle of the match, we double-check whether the list of mappool IDs for the tournament is missing data and add to it if necessary.
<note>
We do not ask for beatmap IDs to be separated by round during submission, since this would require much more manual work and round names are often not standardized between tournaments. This means that a warmup game may very rarely be counted as a verified game if it was played on a map from a different round in the same tournament; if you notice this, please submit a ticket to the o!TR team. 
</note>
</step>
<step>
Finally, any remaining <code>PreVerified</code> data is marked as <code>Verified</code>, and any remaining <code>PreRejected</code> data is marked as <code>Rejected</code>.
</step>
</procedure>

<tip>
Match data involving players who were restricted, including those who were tournament banned for foul play, is handled by the system just like any other match data. However, restricted players will not appear on any rating leaderboards. Depending on the influence of such players on the match, the o!TR team may include or exclude such games or matches from verification on a case-by-case basis.
</tip>

## Modifying submitted data

The o!TR admins have the ability to modify match data in the database, including game scores, tournament names, and match win records. (Note that this is different from simply changing the verification status of a game score, game, match, or tournament.) Any such events will always be clearly documented in admin notes and made publicly available. Below is a list of example cases where this may be done:

* Renaming a tournament for consistency with past or future iterations,
* Correcting the EZ (or other mod) multipliers specified in a particular tournament's ruleset by manually changing the appropriate scores,
* Adding a game score to correct a lobby size mismatch if (1) the player disconnected mid-game but provided a local replay or records of an on-stream score and (2) that data was actually used as the source of truth for tournament proceedings.
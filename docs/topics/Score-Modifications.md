# Data Processing

The o!TR suite of tools processes various amounts of data in various ways.

## Tournament Data

We process data from osu! multiplayer lobbies. This data comes from tournament data. Any osu! player who has participated in any of the lobbies submitted to o!TR will have some of their account information stored in our system.

This data includes:

* Tournament performance data
  * Scores
  * Games participated
  > From this information we can build references such as teammate & opponent information
* osu! profile information (id, username, country, global ranks for all rulesets)
* osu!track information
  * Closest known global rank for all rulesets (with timestamp)
  > This is for players who have tournament data for a given ruleset. The closest known rank is the closest available rank from osu!track compared to the date of the first tournament match a player participated in.

## Data manipulation

The o!TR team manipulates raw match data in the following ways:

* Multiplies all score values that have the [`EZ` modifier](https://osu.ppy.sh/wiki/en/Gameplay/Game_modifier/Easy) by **1.75x**.

## Removal of user information

At this time, the o!TR team does not provide a mechanism for removing a user's information. Users who close or [delete their osu! account](https://osu.ppy.sh/wiki/en/Help_centre/Account#account-deletion) may have their data automatically removed or anonymized from our systems without any formal request to us.
---
tags:
  - internal
---

The o!TR team maintains a publicly accessible archive of database replicas to support two key objectives:

1. Facilitating development and contributions to the official [o!TR repositories](https://github.com/osu-tournament-rating/).
2. Ensuring that interested parties may verify a tournament using o!TR to seed or filter registrants did so legitimately.

## Public Replicas

Database replicas are published every Wednesday at 00:00 UTC and are stored in a Google Cloud Storage bucket. **The public may browse and download replicas [here](https://data.otr.stagec.xyz/).**

>[!important]
>Users who download a replica must abide by the [[Terms of Use#Database Terms of Use|Database Terms of Use]].

1. `players`
2. `player_osu_ruleset_data`
3. `tournaments`
4. `matches`
5. `games`
6. `game_scores`

Refer to the [[Disaster Recovery|disaster recovery]] guide for instructions on importing a replica locally.

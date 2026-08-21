This page records changes to the [otr-web](https://github.com/osu-tournament-rating/otr-web) project. Changelog format is based on [keep a changelog](https://keepachangelog.com/en/1.1.0/).

## [2026.08.16](https://github.com/osu-tournament-rating/otr-web/compare/2026.06.16...2026.08.16)

### Breaking API Changes

- Removed `GET /beatmaps/{beatmapId}/tournaments/{tournamentId}/matches`.

### Added

- Complete overhaul of all beatmap pages and cards.
    - Redesigned beatmap overview / core information display.
    - Redesigned mod distribution, tournament activity, and tournament usage charts.
    - Redesigned beatmap score leaderboard, now shows top 25 instead of top 10.
    - Added charts to display distributions for grades, rank ranges, freemod-specific mod choices.
    - Added charts to display scores earned by tier and rank range.
    - Added chart to display accuracy earned by tier.
    - Added histogram to display how close games usually are compared to other beatmaps of the same ruleset and team size.
    - Added miss count histogram.
- Added the ability for users to view data reports they've created.
- Added "Awaiting review" pill on the tournaments landing page for unverified tournaments.
- Added a mechanism for audit logs to precisely know which entities were edited through the same admin action.
- Redesigned the beatmap audio preview panel.
- Redesigned tournament landing page.
- Redesigned the data report experience for tournaments, matches, games, and scores.
- Redesigned the match page's stats tab.
- Updated the site-wide rating distribution chart design.
- Updated API spec implementation.
- Updated Grafana monitoring dashboards.
- Updated audit logging logic to automatically handle changes in data models.
- Updated the weekly maintenance window to end automatically once new ratings for the week are detected.
- Improved tournament and beatmap search/filter interfaces.
- Improved handling of sparse keywords in site-wide search.
- Improved beatmap search ranking.
- Replaced ruleset icons with official designs, except for Mania 4K and 7K. The latter were updated to be more in-line with the official icons.
- Disabled registrant filtering during the weekly maintenance window to guarantee auditability.

### Fixed

- Restored missing submitter data for 285 tournaments.
- Fixed bugs with site-wide search that caused some results, like [w/WWW](https://otr.stagec.net/beatmaps/2855311), to not show up.
- Fixed a bug where lazer-specific fields were missing from audit logs.

### Other

- Updated packages.
- Updated the `.env` format to accept port overrides for the website and Grafana.
- Dusted cobwebs throughout the codebase.

## Full Changelogs

- [2026.08.16](https://github.com/osu-tournament-rating/otr-web/compare/2026.06.16...2026.08.16)

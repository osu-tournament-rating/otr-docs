This page records changes to the [otr-web](https://github.com/osu-tournament-rating/otr-web) project. Changelog format is based on [keep a changelog](https://keepachangelog.com/en/1.1.0/).

> [!note]
> This changelog began tracking releases on 2026.08.16. Changes made before that date are not recorded on this page.

## Unreleased

### Breaking API Changes

- Changed `GET /players/{id}/beatmaps` to return `beatmapsetId` as `null` for manually configured beatmaps.

### Added

- Added child audit logs to tournament, match, game, and score audit pages, showing changes recorded against an entity's children.
    - Added `GET /audit/descendants` and `GET /audit/descendant-counts`.
- Added the ability for admins to fill in data for beatmaps the osu! API no longer serves.
    - Editable fields:
        - Difficulty name, artist, and title.
        - Set owner and mappers.
        - Ruleset, star rating, BPM, length, and drain length.
        - CS, HP, OD, and AR. CS represents key count in osu!mania.
        - Circle, slider, and spinner counts, and max combo.
    - When a beatmap is edited in this way, it is permanently marked as unable to be fetched by the osu! API from that point.
    - Audits are recorded at `/audit/beatmaps/{id}`.
- Added support for tracing oRPC procedures through to database queries using Tempo.
- Updated the leaderboard first-visit notice to a single sentence that can be dismissed immediately.
- Added sticky column headers to the leaderboard, tournaments list, beatmap list, player rating history, and filter report results tables.

### Fixed

- Fixed the profile avatar's report notification dot not clearing after an admin viewed [`/admin/reports`](https://otr.stagec.net/admin/reports).
- Fixed audit logs labeling automated verifications and rejections as pre-verified and pre-rejected.
- Fixed tooltip text contrast in the light theme.
- Fixed manually configured beatmaps not appearing in search, the beatmap list, match pages, tournament pools, the beatmapset difficulty list, and the player beatmaps tab.

### Other

- Added per-pull-request preview deployments served on private tailnet URLs.
- Added `OTEL_EXPORTER_OTLP_ENDPOINT` to the `.env` format.

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

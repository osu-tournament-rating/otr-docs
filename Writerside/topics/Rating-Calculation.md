# Rating Calculation

o!TR primarily uses the [OpenSkill algorithm](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf), specifically using the Plackett-Luce ranking model. The implementation source code can be found [here](https://crates.io/crates/openskill/0.0.1). In short, OpenSkill is a system similar to the [Elo](https://en.wikipedia.org/wiki/Elo_rating_system) or [Glicko/Glicko-2](https://en.wikipedia.org/wiki/Glicko_rating_system) rating systems used in games like chess. It assigns each player an approximate rating and rating deviation with a higher rating deviation meaning more opportunity for the rating to increase or decrease. Rating updates are performed based on the relative performance of each player in the match.

# FAQ

The o!TR team has prepared this FAQ for users' convenience. If your questions still are not answered, please [contact us](Contact.md).

## How are matches selected and filtered?

Tournaments are approved manually by a member of the o!TR team if they are fair and played in a valid competitive environment. This means that most tournaments adhering to badging criteria are accepted, with qualifiers and tryouts excluded. Please see tournament submission** for more details.

Anyone is permitted to submit tournaments for approval, but we ask that a list of all bracket match links be provided for consistency. We do some filtering for warmups, but anyone is permitted to submit a case-by-case request to exclude a map or player.

See [Tournament Approval](Tournament-Approval.md) for more information.

## How are initial ratings determined?

Starting ratings are based on the closest-known rank according to [osu!track](https://github.com/Ameobea/osutrack-api), or your most recent global rank if none is known. The initial placement is based on the closest point in time relative to when you started playing tournaments.

> For a rough reference, players ranked near #10,000 will receive a typical starting rating.

> The accuracy of one's rating will sharply improve when they begin playing tournaments.
>
{style="note"}

## How are match scores interpreted?

OpenSkill updates ratings of players based only on **relative ranking**, and these relative rankings are decided by a [formula](Rating-Calculation.md#ranking-calculation) that evaluates your match performance.

> The [star ratings](https://osu.ppy.sh/wiki/en/Beatmap/Star_rating) of any maps played are intentionally not considered.

### Ranking calculation

[formula for above ranking]
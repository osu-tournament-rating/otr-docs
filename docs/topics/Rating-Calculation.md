# Rating Calculation

o!TR primarily uses the [OpenSkill algorithm](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf), specifically using the Plackett-Luce ranking model. The implementation source code can be found [here](https://crates.io/crates/openskill/0.0.1). In short, OpenSkill is a system similar to the [Elo](https://en.wikipedia.org/wiki/Elo_rating_system) or [Glicko/Glicko-2](https://en.wikipedia.org/wiki/Glicko_rating_system) rating systems used in games like chess. It assigns each player an approximate rating and rating deviation with a higher rating deviation meaning more opportunity for the rating to increase or decrease. Rating updates are performed based on the relative performance of each player in the match.

## Rating

Rating, (a.k.a Tournament Rating or TR), is the number used to quantify an individual's tournament performance. This number, combined with [Volatility](#volatility), is used by the OpenSkill model to determine how likely someone is to come out ahead against someone else in a tournament match. Should an upset occur, a more drastic change in rating for all involved parties may occur.

The [initial rating](#how-are-initial-ratings-determined) is not nearly as important as the resulting adjustments from tournament performance. Like other games with competitive ladders, players will see very high fluctuations in their rating initially as the system becomes more confident in their abilities. Players should not worry about being stuck at a certain range; a better rating will follow better match performance.

## Volatility

Volatility is the number that determines how confident the model is in one's [Rating](#rating). The higher this value, the less confident the model is in one's rating. It essentially translates to a 99% confidence interval, where the model is 99% sure a player's "true" rating is somewhere within `rating +/- volatility`.

> Consider the following:
> 
> * Rating is 2000.0
> * Volatility is 150.0
>
> The model is 99% sure that this player's true rating is between 1850.0 and 2150.0, based on their performance throughout the system thus far. This will continue to increase in accuracy as they play more matches.
> 

Players start off with a very high volatility value which gradually decreases as a player competes in more tournaments.

## Ranking & rating calculation

Rankings, which are fed into the OpenSkill model, are calculated on a game-by-game basis. The per-game rankings simply use score to rank players. This is not the whole story with respect to *rating* calculation.

The rating calculation algorithm - the function responsible for changing a player's TR - is a little confusing, so let's break it down.

For all participants of a match, on a per-game basis:
<procedure>
<step>
Store a snapshot of each player's rating before the match.
</step>
<step>
Identify the ranking of each player for this game.
</step>
<step>
Feed the rankings & rating snapshots into the model.
</step>
<step>
Store the results (new changes in rating & volatility) for lookup later.
</step>
<step>
Multiply the baseline rating and volatility changes by the frequency of play throughout the match.
<code-block lang="tex">
    \begin{equation}
    {f} = \frac{g\_played}{g\_total}
    \end{equation}
</code-block>
</step>
</procedure>

At the end of the match processing loop, if any players have a negative change in rating from before the match, we apply a second negative performance scaling to their new rating. This is to make poor performance penalties less harsh than they otherwise would be.

<list>
<li><code>r</code> is the new rating result</li>
<li><code>p</code> is the player's prior rating.</li>
<li><code>s</code> is the scaling factor (used to mitigate the loss in rating from a single poor performance).</li>
<li><code>d</code> is the change in rating (delta) from the rating evaluated in the previous step to the result in the above step.</li>
<li><code>f</code> is the frequency of play from the above step.</li>
</list>
<code-block lang="tex">
    \begin{equation}
    {r} = {p} - ({s} * (\lvert d \rvert * f))
    \end{equation}
</code-block>
<tip>
Volatility is not affected by this scaling.
</tip>

## FAQ

Please read the following FAQ before asking questions. If your questions still are not answered, please [contact us](Contact.md).

### How are matches selected and filtered?

Tournaments are approved manually by a member of the o!TR team if they are fair and played in a valid competitive environment. This means that most tournaments adhering to badging criteria are accepted, with qualifiers and tryouts excluded. Please see tournament submission** for more details.

Anyone is permitted to submit tournaments for approval, but we ask that a list of all bracket match links be provided for consistency. We do some filtering for warmups, but anyone is permitted to submit a case-by-case request to exclude a map or player.

See [Tournament Approval](Tournament-Approval.md) for more information.

### How are initial ratings determined?

Starting ratings are based on the closest-known rank according to [osu!track](https://github.com/Ameobea/osutrack-api), or your most recent global rank if none is known. The initial placement is based on the closest point in time relative to when you started playing tournaments.

> For a rough reference, players ranked near #10,000 will receive a typical starting rating.

> The accuracy of one's rating will sharply improve when they begin playing tournaments.
>
{style="note"}

### How are match scores interpreted?

OpenSkill updates ratings of players based only on **relative ranking**. These rankings are determined on a per-game basis using player score values.

> Whether a map is won or lost by a team is not considered.
> 

> The [star ratings](https://osu.ppy.sh/wiki/en/Beatmap/Star_rating) of any maps played are intentionally not considered.
>

### When will ratings update?

Ratings will be recalculated and updated once weekly at 12:00UTC.
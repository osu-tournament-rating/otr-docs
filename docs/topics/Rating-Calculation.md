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

## Further details

### Rating change formulas

The rating system itself is based on OpenSkill, which is a Bayesian approximation algorithm. Without going too deep into any formulas, these Bayesian rating algorithms assign each player a rating μ and volatility σ, which together describe a distribution of predicted actual skill levels for that player. 

When players compete against each other in a match, a formula is used to calculate the probability of various outcomes / rankings of that match. The players' μ and σ values are then adjusted based on how "surprising" the match outcome was. In o!TR's case, the formula comes from the Plackett-Luce model, whose fundamental assumption is "irrelevance of alternatives".

Specifically, Plackett-Luce is based on the idea that player A outperforms player B with the same probability, no matter who else is in the lobby. This assumption is not fully correct because teammates do affect how often one participates, but Plackett-Luce is still a model used in real-world ranking systems like horse racing or poker standings.

Quoting from the [paper](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf), these adjustments are calculated via "the average of the relative rate of change of [a player's] winning probability with respect to [their] strength," where the average is taken over the prior distribution. The actual Bayesian inference calculations for these types of models are computationally intensive, and OpenSkill is actually only an **approximation** of the full calculation (in the paper, they discuss why the simplifications are reasonable).

### Choosing model parameters

There are various parameters that can be adjusted when setting up the model (see [here](https://github.com/injae/openskill-rs/blob/main/src/model/plackett_luce.rs#L12) or read the paper for more detailed calculations). In words, μ and σ are the rating and volatility mentioned above, β is an "extra volatility" term for calculating head-to-head matchup probabilities, κ is used as part of a check that volatility stays positive, and τ adds a small amount to variance (squared volatility) after each match. Finally, the function γ is a dampening factor which causes volatility to decrease less significantly when matchups are large. Intuitively, this can be thought of as not treating a match with 10 players in it as counting as much as 9 separate 1v1s against each opponent.

The Plackett-Luce model allows for arbitrary scalings of parameters, though the OpenSkill documentation recommends that σ starts out as 1/3 of μ. We choose a scaling here so that the highest ratings look somewhat similar to chess (solely for aesthetic appeal), though we do choose varying initial ratings based on rank. While we keep the default values of γ and κ, we currently initialize σ, β, and τ to a smaller fraction of μ than the default to make it more difficult to farm rating from low-rated players.

Remember that different players specialize in different skillsets and have skillcaps at different levels, so please interpret TR not as an absolute skill comparison between two players. Remember that o!TR identifies when people **frequently win** relative to others in their rank range or skill level, so if you see a player with what seems like an unusually high rating, we recommend that you look at their tournament history and check if they're consistently the top performer in their matches.

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
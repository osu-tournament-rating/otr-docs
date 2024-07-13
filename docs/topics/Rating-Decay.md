# Rating Decay

Rating decay is the process by which we handle inactivity in o!TR. The o!TR team does not believe in letting players keep their rating values forever, even without further tournament activity.

Every player is assigned a [rating](Rating-Calculation.md#rating) and [volatility](Rating-Calculation.md#volatility). Players [decay](#decay) if there is a prolonged period of inactivity. Decay retroactively applies for the entire inactivity period once a user begins to decay.

## Decay

If a player does not play in any tournaments in our dataset for a period of **four months**, they will begin to decay.

While a player is decaying, the following occurs every week:

<procedure>
<step>
The player's rating decreases by a small constant, down to a predetermined minimum.
</step>
<step>
The player's volatility increases by a small constant, up to a predetermined maximum.
</step>
</procedure>

## Concerns

One common concern the o!TR team recognizes is that players may be incentivized to use rating decay or induce poor tournament performance to artificially reduce their TR, defeating the purpose of the system. However, the 4 month period is long enough and the rating decay is small enough that the effects would not be noticeable unless players are trying to only play the same rating-restricted tournament annually, at which point they would be isolating themselves from all other tournaments over the course of a year.

Additionally, calculable metrics such as player decay status and player volatility will be made available through an API should hosts wish to [filter](https://osu.ppy.sh/wiki/en/Tournaments/Official_support#registrant-filtering-and-seeding) highly volatile players. Furthermore, matches can be manually flagged by the o!TR team to not be included if foul play has been detected, such as players teaming up and under performing to reduce rating. This is a primary advantage of the tournament and match approval system we have in place.
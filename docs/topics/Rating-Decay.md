# Rating Decay

Rating decay is the process by which we handle inactivity in o!TR. The o!TR team does not believe in letting players keep their rating values forever, even without further tournament activity.

Every player is assigned a [[Rating-Calculation#Rating|rating]] and [[Rating-Calculation#Volatility|volatility]]. Players [[#Decay|decay]] if there is a prolonged period of inactivity. Decay retroactively applies for the entire inactivity period once a user begins to decay.

## Decay

If a player does not play in any tournaments in our dataset for a period of **four months**, they will begin to decay.

While a player is decaying, the following occurs every week:

1. The player's rating decreases by a small constant, down to a predetermined minimum. This minimum is set higher for players with higher peak ratings.

2. The player's volatility increases by a small amount, up to a predetermined maximum (the starting volatility for a new player).

Such players will also be marked inactive and not appear on any rating leaderboards until their next match.

## Concerns

One common concern the o!TR team recognizes is that players may be incentivized to use rating decay or induce poor tournament performance to artificially reduce their TR, defeating the purpose of the system. However, the 4 month period is long enough and the rating decay rate is small enough that this would only make a noticeable difference for players who only participate in one or maybe two tournaments per year, which means isolating from all other tournament play during that period.

Calculable metrics such as player decay status and player volatility will be made available through an API should hosts wish to [filter](https://osu.ppy.sh/wiki/en/Tournaments/Official_support#registrant-filtering-and-seeding) highly volatile players. Furthermore, matches can be manually flagged by the o!TR team to not be included if foul play has been detected, such as players teaming up and underperforming to reduce rating. This is a key advantage of the tournament and match approval system we have in place.
---
tags:
  - math
---

Starting ratings are based on the closest-known rank according to [osu!track](https://github.com/Ameobea/osutrack-api), or your most recent global rank if none is known. The initial placement is based on the closest point in time relative to when you started playing tournaments.

These initial ratings follow roughly a bell curve and are roughly linearly dependent on log(rank). Specifically, the following quantity, called the "rank z-score," is first calculated for each player:

$$
\begin{equation}
    z_{\text{rank}} = \frac{\text{avg}(\ln(\text{rank})) - \ln(\text{rank})}{\text{stddev}(\ln(\text{rank}))}.
\end{equation}
$$

This rank z-score will be a number typically between -3 and 3, with better-ranked players having a higher z-score. A player's initial rating is then determined via the formula

$$
\begin{equation}
    \text{initial rating} =
        \begin{cases}
            1080 + 180 \cdot z_{\text{rank}} & z_{\text{rank}} \ge 0, \\
            1080 - 240 \cdot z_{\text{rank}} & \text{otherwise},
        \end{cases}
\end{equation}
$$

with an enforced minimum and maximum rating of 600 and 1800. The reason for the asymmetrical dependence is due to a skew in the rank distribution of tournament players.

> [!info]
> For a rough reference, players ranked near #20,000 in osu! will have a rank z-score around 0 and receive an "average" starting rating around 1080.

Any players whose rank data cannot be recovered from either osu!track or the osu! API are given a default initial rating of 900. This may occur because they are restricted, have no plays for that ruleset, or are inactive and have no osu!track data.

> [!note]
> Please note that the formula for initial ratings is still tentative. In particular, any discussions surrounding how to account for historical "rank drift" are welcome.
>
> Regardless of initial assignment, the accuracy of one's rating will sharply improve after playing a few tournaments.

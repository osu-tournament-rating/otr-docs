---
tags:
  - math
---

Starting ratings are based on the closest-known rank according to [osu!track](https://github.com/Ameobea/osutrack-api), or the most recent global rank if none is known. The initial placement is based on the closest point in time relative to when the player started playing tournament matches.

These initial ratings roughly follow a bell curve and are piecewise linearly dependent on $\log(\text{rank})$. Specifically, the following quantity, called the "rank z-score," is first calculated for each player:

$$
\begin{equation}
    z_{\text{rank}} = \frac{\text{avg}(\ln(\text{rank})) - \ln(\text{rank})}{\text{stddev}(\ln(\text{rank}))}.
\end{equation}
$$

This rank z-score will be a real number typically between $-3$ and $3$, with better-ranked players having a higher z-score.

>[!info]
>Instead of constantly recomputing the values of $\text{avg}(\ln(\text{rank})$ and $\text{stddev}(\ln(\text{rank}))$ for every rating recalculation, a snapshot of those values was stored during the beta phase of o!TR and is used for all calculations. The constants are found in [the code](https://github.com/osu-tournament-rating/otr-processor/blob/master/src/model/rating_utils.rs#L151) and are also listed in the table below.

|  Game mode   | $\text{avg}(\ln(\text{rank})$ | $\text{stddev}(\ln(\text{rank}))$ |
| :----------: | :---------------------------: | :-------------------------------: |
|     osu!     |            $9.99$             |              $1.77$               |
|  osu!taiko   |            $7.28$             |              $1.60$               |
|  osu!catch   |            $6.85$             |              $1.62$               |
| osu!mania 4K |            $8.02$             |              $1.54$               |
| osu!mania 7K |            $6.11$             |              $1.59$               |

A player's initial rating is then determined via the formula

$$
\begin{equation}
    \text{initial rating} =
        \begin{cases}
            1200 + 200 \cdot z_{\text{rank}}, & \text{if }z_{\text{rank}} \ge 0, \\
            1200 + 250 \cdot z_{\text{rank}}, & \text{otherwise},
        \end{cases}
\end{equation}
$$

with an enforced minimum and maximum rating of $500$ and $2000$. The reason for the asymmetrical dependence is due to a skew in the rank distribution of tournament players.

> [!info]
> For reference, players ranked near $\#22,000$ in osu! will have a rank z-score around $0$ and receive an initial rating of approximately $1200$.

While this formula does not account for historical rank drift [^1], this approximation is still good enough for our purposes especially because [[Rating Decay|rating decay]] applies to inactive players.

Any players whose rank data cannot be recovered from either osu!track or the osu! API are given a default initial rating of $1000$. This may occur because they are restricted, have no plays for that ruleset, or are inactive and have no osu!track data.

> [!note]
> Regardless of initial assignment, the accuracy of one's rating will improve after playing a few tournaments.

## Initial Ratings for Filtering and Seeding

Tournaments may use o!TR's built-in [[Registrant Filtering|filtering tool]] to filter or seed players. However, players who have never played a non-qualifiers match in a verified tournament (which we call "provisional players") will not have an assigned TR. Here are some best practices for how to account for this situation:

1. Using the formula above, an *estimated initial rating* can be calculated from a player's current rank. If players' ranks and o!TR ratings are both being displayed on a tournament's main sheet, we recommend calculating estimated initial ratings using those displayed ranks for consistency.
2. If o!TR is being used solely for *filtering*, then it is best for rank-eligible players to have estimated initial ratings within the filtering range. For example, players ranked between $\#10,000$ and $\#99,999$ would have an initial rating roughly between $985$ and $1288$, so a 5 digit tournament should typically have an upper o!TR rating limit higher than $1288$. If such recommendations are followed, then the filtering tool will correctly allow provisional players to play, and no additional steps are necessary.
3. If o!TR is also being used for *seeding*, then it is useful to keep in mind that on average, new players lose rating in their first matches. Thus, to avoid overestimating new players' performances, you may consider using an *adjusted initial rating*. For example, if a tournament is seeding the top $32$ players by o!TR rating into a bracket, it may be sensible to use the formula $\text{adjusted initial rating} = \text{estimated initial rating} - 100$ for any provisional players without a rating on record at the time of seeding.[^2]
4. As a reminder, any use of o!TR for an officially supported tournament must have approval from the Tournament Committee before play begins. If there is any deviation from simply using the filtering tool, be sure to document it clearly on the tournament's forum post and in the request for usage.

[^1]: This term refers to how a player at a certain rank today typically displays a higher skill level than a player at that same rank years ago.

[^2]: The choice of $-100$ comes from empirical rating data. Specifically, players ranked $\#10,000$ or worse lose roughly $100$ TR on average in their first $5$ matches and $150$ TR in their first $15$ matches, so subtracting off $100$ from their estimated initial rating is a modest correction to avoid overestimating first-tournament performance.

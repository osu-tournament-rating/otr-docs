# Match Cost

Although not used in rating calculations directly, o!TR does keep track of match cost for use in other statistics (for example, comparing performance across different tournaments). The formula is as follows.

## Formula

The match cost formula is inspired by Bathbot's formula, simplified to remove factors that are not relevant for our purposes. For each map played, each player receives a map score between 0.5 and 1.5, specifically
<code-block lang="tex">
\begin{equation}
    \text{map score} = 0.5 + \text{normcdf}\left(\frac{\text{score} - \text{avg}(\text{scores on map})}{\text{stddev}(\text{scores on map})}\right).
\end{equation}
</code-block>
These map scores are then averaged together and finally multiplied by a bonus factor for playing more of the match, specifically
<code-block lang="tex">
\begin{equation}
    \text{lobby bonus} = 1 + 0.3 \cdot \sqrt{\frac{\text{maps played} - 1}{\text{total maps} - 1}}.
\end{equation}
</code-block>

Thus, match cost values will range from 0.5 to 1.95, with a typical value being around 1.2.

> Some other match cost formulas include bonus factors for playing in tiebreaker or playing a variety of different mods during a match. We do not include such factors so that our formula primarily reflects relative performance rather than contribution towards winning. For example, the winner of a 1v1 match will always have a higher match cost, even if they won their maps by much smaller margins.
> 
{style="note"}
# Match Cost

Although not used in rating calculations directly, the match cost formula o!TR uses for statistics is as follows.

## Formula

The match cost formula is inspired by Bathbot's formula, simplified to remove factors that are not relevant for our purposes. Each player receives a **map score** between 0.5 and 1.5 for each map they play, with 1.0 being average across the lobby (specifically, this is `0.5 + normal cdf(z-score)`). To calculate match cost, we take the average of these map scores and multiply by a **lobby bonus factor** ranging from 1.0 to 1.3 (specifically, this is `1.0 + 0.3 * sqrt(x)`, where x ranges linearly from 0.0 for playing only one map to 1.0 for playing all of them). 
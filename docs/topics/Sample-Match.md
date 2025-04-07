# Sample Match

This page is dedicated to carrying out calculations to demonstrate an example of rating changes from a single match. We will be following the logic described [[Rating-Calculation.md#Ranking & rating calculation|here]], so it is advised to read that page first. This page will focus on detailing the actual calculations used in the [paper](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf) which introduces this rating model. 

> [!note]
> It is not necessary to understand every calculation on this page to get a good sense of what the rating model is doing. This documentation exists primarily for those who are curious about the mathematics, and also so that the rating assignment process is more transparent than only specifying "the ratings are fed into a model and numbers come out of it."
> 
> If you are interested more in the general philosophy of what ratings represent, it is highly recommended to read [[Rating-Calculation.md#Ranking & rating calculation|this page]] instead.

The sample match we will be using is [LC: (H O L A) vs (Ummm)](https://otr.stagec.xyz/matches/33746) ([osu! link](https://osu.ppy.sh/community/matches/112506508)). It was chosen for its relatively short length and smaller format—2v2, team size 3—while still effectively illustrating the main ideas.

We will assume the six players who played in the match had the following ratings and rating deviations immediately before this match, and we will calculate their ratings and rating deviations after the match ends. **Please note that these values are not the actual ratings of these players; these are sample numbers for illustration purposes.**

|                     Player                     | Rating ($\mu$) | Rating Deviation ($\sigma$) |
| :--------------------------------------------: | :------------: | :-------------------------: |
|   [Isita](https://osu.ppy.sh/users/13973026)   |     $1450$     |            $240$            |
|  [parr0t](https://osu.ppy.sh/users/23729699)   |     $1050$     |            $280$            |
|   [Zeer0](https://osu.ppy.sh/users/16085717)   |     $1000$     |            $290$            |
| [Railgun\_](https://osu.ppy.sh/users/13817114) |     $1000$     |            $280$            |
|  [poisonvx](https://osu.ppy.sh/users/9391047)  |     $700$      |            $270$            |
|    [Skyy](https://osu.ppy.sh/users/7113149)    |     $600$      |            $270$            |

Note that all games in this match were verified, so all of them will be used for rating calculation. If there were a game with incorrect lobby sizes (because of a disconnect) or an incorrect beatmap ID (because of a warmup), those would be excluded for the corresponding rejection reasons.

## Rating changes under Method A

In Method A of calculating rating changes, we first look at the four players of each game and rank their scores from highest to lowest. The teams that the players play for and the mods that they use are irrelevant, except that EZ scores (in this case, parr0t's score in the first game) are multiplied by 1.75. Thus the rankings are as shown:

| Game |   1st    |   2nd    |   3rd    |  4th  |
|:----:|:--------:|:--------:|:--------:|:-----:|
| $1$  | Railgun\_ |  parr0t  |  Isita   | Skyy  |
| $2$  |  Isita   |  parr0t  | Railgun\_ | Zeer0 |
| $3$  | Railgun\_ |  Isita   | poisonvx | Skyy  |
| $4$  |  Isita   | Railgun\_ |  parr0t  | Skyy  |
| $5$  |  parr0t  | Railgun\_ |  Isita   | Zeer0 |
| $6$  |  Isita   |  parr0t  | Railgun\_ | Zeer0 |

These rankings are the only information taken into account for rating calculations (individual scores are not considered). For each game, the players who play in it will be given a "game rating change." All games are calculated in the same way, so we will demonstrate this process for the first game.

Here, we follow the notation and logic of Algorithm 4 of the paper, found on page 21 of [the paper](https://jmlr.csail.mit.edu/papers/volume12/weng11a/weng11a.pdf). The description also references Algorithm 1, which can be found on page 15.

First, we compute an overall uncertainty constant which the paper calls $c$, which is given by 
$$c = \sqrt{4\beta^2 + \sigma_{\text{Railgun\_}}^2 + \sigma_{\text{parr0t}}^2 + \sigma_{\text{Isita}}^2 + \sigma_{\text{Skyy}}^2} \approx 614.2.$$
Here $\beta = 150$ is a constant specified by our [constants file](https://github.com/osu-tournament-rating/otr-processor/blob/master/src/model/constants.rs), and the other four terms in the square roots come from the rating deviations of the four players (before the match). This $c$ is used to compute the predicted probabilities of players placing in various orders. It roughly means that for this game, a difference of $c \approx 614.25$ rating points between two players means the higher-rated player has $e \approx 2.7$ times the chance of placing above the lower-rated player.

Next, we calculate, in the notation of the paper, two values $\Omega$ and $\Delta$ for each player in the game. These specify an *additive* rating change and a *multiplicative* rating deviation change, respectively. Instead of repeating all of the formulas from the paper, we will try to work out examples in understandable words.

1. First, consider the player who placed highest, Railgun\_ in this case. The model currently thinks the probability that Railgun\_ ranked highest is 
   $$p_{\text{Railgun\_ 1st}} = \frac{e^{\mu_{\text{Railgun\_}}/c}}{e^{\mu_{\text{Railgun\_}}/c} + e^{\mu_{\text{parr0t}}/c}+ e^{\mu_{\text{Isita}}/c} + e^{\mu_{\text{Skyy}}/c}} \approx 0.213,$$
   where we are plugging in the pre-match ratings from our table above. This is slightly smaller than 1/4, mostly because Isita's pre-match rating is much higher than Railgun\_'s. Railgun\_'s suggested rating change from this game is then
   $$\Omega_{\text{Railgun\_}} = \frac{\sigma_{\text{Railgun\_}}^2}{c} (1 - p_{\text{Railgun\_ 1st}}) \approx \boxed{100.4},$$
   and the factor by which their rating variance (that is, rating deviation squared) should be decreased is 
   $$\Delta_{\text{Railgun\_}} = \frac{\sigma_{\text{Railgun\_}}^2}{4c^2}p_{\text{Railgun\_ 1st}}(1 - p_{\text{Railgun\_ 1st}}) \approx \boxed{0.008}.$$
   The prefactor of $\frac{1}{4}$ is the "variance damping factor" $\gamma_q = \frac{1}{k}$ as discussed on page 26 of the paper. Notice that the less likely the model thinks it is for Railgun\_ to place first, and also the higher their rating deviation, the higher their suggested rating change.

2. Next, consider the second-highest-ranking player, parr0t. The model now cares about the probability of parr0t ranking highest, 
   $$p_{\text{parr0t 1st}} = \frac{e^{\mu_{\text{parr0t}}/c}}{e^{\mu_{\text{Railgun\_}}/c} + e^{\mu_{\text{parr0t}}/c}+ e^{\mu_{\text{Isita}}/c} + e^{\mu_{\text{Skyy}}/c}} \approx 0.231,$$
   as well as the probability of parr0t ranking highest except for Railgun\_,
   $$p_{\text{parr0t 2nd}} = \frac{e^{\mu_{\text{parr0t}}/c}}{e^{\mu_{\text{parr0t}}/c}+ e^{\mu_{\text{Isita}}/c} + e^{\mu_{\text{Skyy}}/c}} \approx 0.294.$$
   parr0t's suggested rating change from this game is then 
   $$\Omega_{\text{parr0t}} = \frac{\sigma_{\text{parr0t}}^2}{c} (1 - p_{\text{parr0t 1st}} - p_{\text{parr0t 2nd}}) \approx \boxed{60.5},$$
   and their variance decrease factor is $$\Delta_{\text{parr0t}} = \frac{\sigma_{\text{parr0t}}^2}{4c^2}\Big(p_{\text{parr0t 1st}}(1 - p_{\text{parr0t 1st}}) + p_{\text{parr0t 2nd}}(1 - p_{\text{parr0t 2nd}})\Big) \approx \boxed{0.020}.$$
   Notice that this suggested rating change is smaller than Railgun\_'s suggested rating change, since placing second means the formula for $\Omega$ "subtracts off two probabilities instead of one."
   
> [!note]
> The quantity $p_{\text{parr0t 2nd}}$ is *not* the overall probability of parr0t placing 2nd among the four players, but instead the probability that *assuming* Railgun\_ placed first, parr0t did better than the remaining players. We use this slightly less precise language for readability.
   
3. Next, to calculate rating changes for the third-highest-ranking player Isita, the model cares about the probability of Isita ranking highest, ranking highest except for Railgun\_, and also ranking highest except for Railgun\_ and parr0t. The resulting numbers are
   $$p_{\text{Isita 1st}} \approx 0.444, \quad p_{\text{Isita 2nd}} \approx 0.564, \quad p_{\text{Isita 3rd}} \approx 0.800.$$
   From this, we get that Isita's suggested rating change is 
   $$\Omega_{\text{Isita}} = \frac{\sigma_{\text{Isita}}^2}{c} (1 - p_{\text{Isita 1st}} - p_{\text{Isita 2nd}} - p_{\text{Isita 3rd}}) \approx \boxed{-75.8},$$
   and their variance decrease factor is 
   $$\Delta_{\text{Isita}} = \frac{\sigma_{\text{Isita}}^2}{4c^2}\Big(p_{\text{Isita 1st}}(1 - p_{\text{Isita 1st}}) + p_{\text{Isita 2nd}}(1 - p_{\text{Isita 2nd}}) + p_{\text{Isita 3rd}}(1 - p_{\text{Isita 3rd}})\Big) \approx \boxed{0.025}.$$
   The most important feature here is that because Isita was predicted to have a high probability of ranking highly, that heavily penalizes their suggested rating change (because those probabilities are subtracted in the calculation above).

4. Finally, to calculate rating changes for the fourth-highest-ranking player Skyy, we must compute 
   $$p_{\text{Skyy 1st}} \approx 0.111, \quad p_{\text{Skyy 2nd}} \approx 0.141, \quad p_{\text{Skyy 3rd}} = 0.200, \quad p_{\text{Skyy 4th}} = 1.$$
   Using formulas similar to the ones above (just with an extra term each), we then find that
   $$\Omega_{\text{Skyy}} \approx \boxed{-53.8}, \quad \Delta_{\text{Skyy}} \approx \boxed{0.018}.$$
   Notably, the suggested rating change for Skyy is *less extreme* than the suggested rating change for Isita, since Skyy's rating before the match was much lower.

Remember that all of this was done just for the first game of the match, but the exact same procedure works for all of the other games in the match. Here are the resulting values of $c$, $\Omega_i$, and $\Delta_i$ for each one, rounded for readability (if a player did not play in a game, then the corresponding cells are left blank):

| Game | $c$     | $\Omega_{\text{Isita}}$ | $\Omega_{\text{parr0t}}$ | $\Omega_{\text{Zeer0}}$ | $\Omega_{\text{Railgun\_}}$ | $\Omega_{\text{poisonvx}}$ | $\Omega_{\text{Skyy}}$ | $\Delta_{\text{Isita}}$ | $\Delta_{\text{parr0t}}$ | $\Delta_{\text{Zeer0}}$ | $\Delta_{\text{Railgun\_}}$ | $\Delta_{\text{poisonvx}}$ | $\Delta_{\text{Skyy}}$ |
| :--: | ------- | ----------------------- | ------------------------ | ----------------------- | --------------------------- | -------------------------- | ---------------------- | ----------------------- | ------------------------ | ----------------------- | --------------------------- | -------------------------- | ---------------------- |
| $1$  | $614.2$ | $-75.8$                 | $60.5$                   |                         | $100.4$                     |                            | $-53.8$                | $0.025$                 | $0.020$                  |                         | $0.009$                     |                            | $0.018$                |
| $2$  | $623.3$ | $55.4$                  | $55.1$                   | $-137.5$                | $-2.4$                      |                            |                        | $0.009$                 | $0.020$                  | $0.034$                 | $0.032$                     |                            |                        |
| $3$  | $609.8$ | $-13.7$                 |                          |                         | $98.1$                      | $14.9$                     | $-88.8$                | $0.019$                 |                          |                         | $0.01$                      | $0.026$                    | $0.024$                |
| $4$  | $614.2$ | $52.1$                  | $-41.2$                  |                         | $51.4$                      |                            | $-75.5$                | $0.009$                 | $0.033$                  |                         | $0.021$                     |                            | $0.023$                |
| $5$  | $623.3$ | $-53.7$                 | $99.3$                   | $-103.6$                | $70.3$                      |                            |                        | $0.026$                 | $0.008$                  | $0.030$                 | $0.017$                     |                            |                        |
| $6$  | $623.3$ | $55.4$                  | $55.1$                   | $-137.5$                | $-2.4$                      |                            |                        | $0.009$                 | $0.020$                  | $0.034$                 | $0.032$                     |                            |                        |
## Rating changes under Method B

In Method B of calculating rating changes, we again begin by ranking scores from highest to lowest, but we now treat any players who did not play a game as tying for last place. This yields the following table:

| Game |   1st    |   2nd    |   3rd    |  4th  | Tied 5th        |
| :--: | :------: | :------: | :------: | :---: | --------------- |
| $1$  | Railgun\_ |  parr0t  |  Isita   | Skyy  | poisonvx, Zeer0 |
| $2$  |  Isita   |  parr0t  | Railgun\_ | Zeer0 | poisonvx, Skyy  |
| $3$  | Railgun\_ |  Isita   | poisonvx | Skyy  | parr0t, Zeer0   |
| $4$  |  Isita   | Railgun\_ |  parr0t  | Skyy  | poisonvx, Zeer0 |
| $5$  |  parr0t  | Railgun\_ |  Isita   | Zeer0 | poisonvx, Skyy  |
| $6$  |  Isita   |  parr0t  | Railgun\_ | Zeer0 | poisonvx, Skyy  |
We will again demonstrate how game rating changes look by calculating the rating changes for the first game. This time, we have the overall uncertainty factor $$c = \sqrt{6\beta^2 + \sigma_{\text{Railgun\_}}^2 + \sigma_{\text{parr0t}}^2 + \sigma_{\text{Isita}}^2 + \sigma_{\text{Skyy}}^2 + \sigma_{\text{poisonvx}}^2 + \sigma_{\text{Zeer0}}^2} \approx 761.1.$$ With this, we will calculate $\Omega$ and $\Delta$ values for all six players based on the rankings in game 1:

1. The highest-ranking player, Railgun\_, now has 
   $$p_{\text{Railgun\_ 1st}} = \frac{e^{\mu_{\text{Railgun\_}}/c}}{e^{\mu_{\text{Railgun\_}}/c} + e^{\mu_{\text{parr0t}}/c}+ e^{\mu_{\text{Isita}}/c} + e^{\mu_{\text{Skyy}}/c} + e^{\mu_{\text{poisonvx}}/c} + e^{\mu_{\text{Zeer0}}/c}} \approx 0.163,$$
   so that (very similarly to above)
   $$\Omega_{\text{Railgun\_}} = \frac{\sigma_{\text{Railgun\_}}^2}{c} (1 - p_{\text{Railgun\_ 1st}}) \approx \boxed{86.2}$$
   and (the $4$ has been replaced with $6$ because of the change in number of players being considered)
   $$\Delta_{\text{Railgun\_}} = \frac{\sigma_{\text{Railgun\_}}^2}{6c^2}p_{\text{Railgun\_ 1st}}(1 - p_{\text{Railgun\_ 1st}}) \approx \boxed{0.003}.$$
2. The calculations for players 2 through 4 are very similar. For the second-highest-ranking player parr0t, we find
   $$p_{\text{parr0t 1st}} \approx 0.174, \quad p_{\text{parr0t 2nd}} \approx 0.208,$$
   leading to
   $$\Omega_{\text{parr0t}} \approx \boxed{63.7}, \quad \Delta_{\text{parr0t}} \approx \boxed{0.007}.$$
3. For the third-highest-ranking player Isita, 
   $$p_{\text{Isita 1st}} \approx 0.294, \quad p_{\text{Isita 2nd}} \approx 0.351, \quad p_{\text{Isita 3rd}} \approx 0.444,$$
   leading to
   $$\Omega_{\text{Isita}} = \boxed{-6.8}, \quad \Delta_{\text{Isita}} \approx \boxed{0.011}.$$
4. For the fourth-highest-ranking player Skyy,
   $$p_{\text{Skyy 1st}} \approx 0.096, \quad p_{\text{Skyy 2nd}} \approx 0.115, \quad p_{\text{Skyy 3rd}} \approx 0.145, \quad p_{\text{Skyy 4th}} \approx 0.261,$$
   leading to
   $$\Omega_{\text{Skyy}} = \boxed{36.6}, \quad \Delta_{\text{Skyy}} \approx \boxed{0.011}.$$
5. Finally, the model handles last-place ties by essentially equalizing the rating gains they would have in the different positions. For poisonvx, we have
   $$\begin{align*}p_{\text{poisonvx 1st}} &\approx 0.110, \quad p_{\text{poisonvx 2nd}} \approx 0.131, \quad p_{\text{poisonvx 3rd}} \approx 0.166, \\ p_{\text{poisonvx 4th}} &\approx 0.298, \quad p_{\text{poisonvx 5th}} \approx 0.403,\end{align*}$$
   and the suggested rating change is then
   $$\begin{align*}\Omega_{\text{poisonvx}} = \frac{\sigma^2_{\text{poisonvx}}}{c}&\Big(\frac{1}{2} - p_{\text{poisonvx 1st}} - p_{\text{poisonvx 2nd}} \\&- p_{\text{poisonvx 3rd}}- p_{\text{poisonvx 4th}} - p_{\text{poisonvx 5th}}\Big) \approx \boxed{-58.1}\end{align*}$$
   (more generally if there is an $r$-way tie, the $\frac{1}{2}$ becomes a $\frac{1}{r}$), while the suggested variance decrease factor has the same form of formula as before:
   $$\begin{align*}\Delta_{\text{poisonvx}} = \frac{\sigma_{\text{poisonvx}}^2}{6c^2}\Big(&p_{\text{poisonvx 1st}}(1 - p_{\text{poisonvx 1st}}) + p_{\text{poisonvx 2nd}}(1 - p_{\text{poisonvx 2nd}}) \\ &+ \cdots + p_{\text{poisonvx 5th}}(1 - p_{\text{poisonvx 5th}})\Big) \approx \boxed{0.017}.\end{align*}$$
   Similarly, for Zeer0 we have
   $$\begin{align*}p_{\text{Zeer0 1st}} &\approx 0.163, \quad p_{\text{Zeer0 2nd}} \approx 0.195, \quad p_{\text{Zeer0 3rd}} \approx 0.246, \\ p_{\text{Zeer0 4th}} &\approx 0.441, \quad p_{\text{Zeer0 5th}} \approx 0.597, \end{align*}$$
   and with the same formulas as poisonvx we find
   $$\Omega_{\text{Zeer0}} \approx \boxed{-126.2}, \quad \Delta_{\text{Zeer0}} \approx \boxed{0.023}.$$

Here is the table of $\Omega_i$ and $\Delta_i$ values under Method B. Note that we no longer have a column for $c$ because it is the same across all games in this method (all six players are considered in all games).

| Game | $\Omega_{\text{Isita}}$ | $\Omega_{\text{parr0t}}$ | $\Omega_{\text{Zeer0}}$ | $\Omega_{\text{Railgun\_}}$ | $\Omega_{\text{poisonvx}}$ | $\Omega_{\text{Skyy}}$ | $\Delta_{\text{Isita}}$ | $\Delta_{\text{parr0t}}$ | $\Delta_{\text{Zeer0}}$ | $\Delta_{\text{Railgun\_}}$ | $\Delta_{\text{poisonvx}}$ | $\Delta_{\text{Skyy}}$ |
| :--: | ----------------------- | ------------------------ | ----------------------- | --------------------------- | -------------------------- | ---------------------- | ----------------------- | ------------------------ | ----------------------- | --------------------------- | -------------------------- | ---------------------- |
| $1$  | $-6.8$                  | $63.7$                   | $-126.2$                | $86.2$                      | $-58.1$                    | $36.6$                 | $0.011$                 | $0.007$                  | $0.023$                 | $0.003$                     | $0.017$                    | $0.011$                |
| $2$  | $53.4$                  | $59.7$                   | $-15.6$                 | $30.9$                      | $-76.8$                    | $-61.5$                | $0.003$                 | $0.007$                  | $0.019$                 | $0.012$                     | $0.018$                    | $0.017$                |
| $3$  | $26.8$                  | $-115.4$                 | $-112.4$                | $86.2$                      | $53.3$                     | $37.3$                 | $0.007$                 | $0.023$                  | $0.024$                 | $0.003$                     | $0.008$                    | $0.011$                |
| $4$  | $53.4$                  | $26.7$                   | $-136.2$                | $62.5$                      | $-64$                      | $-31.5$                | $0.003$                 | $0.012$                  | $0.024$                 | $0.007$                     | $0.018$                    | $0.011$                |
| $5$  | $7.1$                   | $85.1$                   | $-5.2$                  | $65.9$                      | $-70.8$                    | $-56.2$                | $0.011$                 | $0.003$                  | $0.018$                 | $0.007$                     | $0.017$                    | $0.016$                |
| $6$  | $53.4$                  | $59.7$                   | $-15.6$                 | $30.9$                      | $-76.8$                    | $-61.5$                | $0.003$                 | $0.007$                  | $0.019$                 | $0.012$                     | $0.018$                    | $0.017$                |
Comparing to the previous table, we can see that rating changes are more positive in Method B for players who played in a game, and they are very negative for players who did not play.
## Overall rating change

Finally, we essentially do a weighted average of all of these numbers to determine the final rating changes for the whole match. For simplicity, we will demonstrate this just for one of the players, parr0t. Their final rating is obtained by averaging the values of $\Omega_{\text{parr0t}}$ across Methods A and B at a 90:10 ratio, then adding that to their initial rating:
$$\begin{align*}\mu_{\text{parr0t}}^{\text{new}} &= 1050 + 0.9\left(\frac{60.5 + 55.1 + 0 -41.2 + 99.3 + 55.1}{6}\right) \\
&+ 0.1\left(\frac{63.7 + 59.7 - 115.4 + 26.7 + 85.1 + 59.7}{6}\right) \approx \boxed{1087.3}.\end{align*}$$
The final rating deviation is obtained in a slightly more complicated way because the rating model would typically multiply the initial deviation by $\sqrt{1 - \Delta}$ to get the final deviation. Thus, we first obtain an "effective averaged $\Delta$" by calculating
$$\begin{align*}\Delta_{\text{eff}} = 0.9&\left(\frac{0.020 + 0.020 + 0 + 0.033 + 0.008 + 0.020}{6}\right) \\ &+ 0.1\left(\frac{0.007 + 0.007 + 0.023 + 0.012 + 0.003 + 0.007}{6}\right) \approx 0.0161,\end{align*}$$
so that parr0t's final rating deviation is $\sqrt{1 - \Delta_{\text{eff}}}$ times their initial rating deviation:
$$\sigma_{\text{parr0t}}^{\text{new}} = 280 \sqrt{1 - \Delta_{\text{eff}}} \approx \boxed{277.7}.$$
The table below shows the adjustments to ratings and rating deviations for the six players of this match.

|                    Player                     |  Rating ($\mu$)   | Rating Deviation ($\sigma$) |
| :-------------------------------------------: | :---------------: | :-------------------------: |
|  [Isita](https://osu.ppy.sh/users/13973026)   | $1450 \to 1455.9$ |       $240 \to 238.2$       |
|  [parr0t](https://osu.ppy.sh/users/23729699)  | $1050 \to 1087.3$ |       $280 \to 277.7$       |
|  [Zeer0](https://osu.ppy.sh/users/16085717)   | $1000 \to 936.4$  |       $290 \to 287.5$       |
| [Railgun\_](https://osu.ppy.sh/users/13817114) | $1000 \to 1053.4$ |       $280 \to 277.4$       |
| [poisonvx](https://osu.ppy.sh/users/9391047)  |  $700 \to 697.3$  |       $270 \to 269.3$       |
|   [Skyy](https://osu.ppy.sh/users/7113149)    |  $600 \to 566.1$  |       $270 \to 268.5$       |
All players' rating deviations have slightly decreased, indicating that the model is slightly more confident about the updated ratings. Also notice that Railgun\_'s rating has significantly increased due to their high participation and relatively high placement among players throughout the match. The overall rating changes are not precisely zero-sum due to the differences in players' rating deviations.
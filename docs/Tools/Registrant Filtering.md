The Registrant Filtering tool allows tournament hosts to filter registrants based on certain criteria which we maintain.

## Filter Criteria

Filters can be applied against:

- Ruleset
- Minimum and maximum rating
- Peak rating
- Tournaments played
- Matches played

We do not support filtering against osu! statistics, such as global rank, for these reasons:

1. If we do not have a player's osu! data at the time of filtering, we would have to fetch it on-demand. This can quickly get out of hand and introduce significant slowdowns.
2. We fetch osu! data periodically, the team has decided to not allow filtering against outdated information.
3. Supporting [BWS](https://osu.ppy.sh/wiki/en/Tournaments/Badge-weighted_seeding) and other custom criteria significantly increases the complexity of the tool and goes beyond the scope of what we intend to offer.

Please use one of the publicly-available spreadsheet templates to support other custom filtering options. These spreadsheets typically allow you to enter your own osu! API key to do the data fetching yourself. See the [Community Resources](https://osu.ppy.sh/community/forums/topics/2012941?n=1) osu! forum post for more information.

## Notice to Tournament Hosts

You **must**:

1. Obtain written approval from [osu! support](mailto:tournaments@ppy.sh) before using our tool in an [officially-supported](https://osu.ppy.sh/wiki/en/Tournaments/Official_support) tournament.
2. Post the timestamp & filter report ID on your forum post. A one-line template is displayed after using the tool which may be copied into your forum post.
3. Use our filtering system as intended. It is **expressly prohibited** to alter our filtering result for any reason. We store a detailed record of all inputs and outputs for auditing and verification purposes.

You should **consider**:

1. Saving the most recent public archive from our [[Replicas#Public Replicas|Public Replicas]] page. In the event of a disaster on our end, hosts are expected to provide the dataset to the [Tournament Committee](https://osu.ppy.sh/wiki/en/People/Tournament_Committee) when it comes time to review for badge eligibility.

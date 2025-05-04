While the osu! Tournament Rating (o!TR) platform does not directly solicit personal information from individuals, we do use and collect some data in order to provide our services. Users[^1] who log into our website using the [osu!](https://osu.ppy.sh/) OAuth platform have a different amount of data collected than players[^2].

# Overview

When osu! match data is processed, a player entity is automatically created which is then tied to a specific osu! user identifier. If a player exists in our database without having first logged into our platform, they will never become a user. A player becomes a user when they log in to our platform for the first time. Similarly, if a first-time user does not have any data in our database already, a player and user object is created for them simultaneously. This allows us to then link osu! match data to them should they participate in matches relevant to us in the future.

By logging in to our platform, you are consenting to the data which is collected below in the [[#Users]] section.

## Information

> [!important]
> All data is associated with your osu! profile. Player data cannot exist in our system without an osu! profile to attach it to.

### Players

The following information is stored if any submitted tournament contains any matches by which you are a participant:

- Publicly-available osu! profile information, such as:
  - ID
  - Username
  - Country code
  - Performance points
  - Global and country ranks
- Publicly-available information provided by [osu!track](https://ameobea.me/osutrack/), such as historical global rank

Using this information, we are able to build a network of:

- Which osu! tournaments, matches, and games you have participated in
- Which scores you have set in these games
- Various metrics regarding the above, including:
  - Your performance in tournaments
  - Who you play tournaments with the most frequently

### Users

We associate the following information with your player profile after you log into our platform:

- Last login date
- Who you follow on osu! (coming soon)
- The tournament data you have submitted to us
- Your settings, such as default ruleset

# Cookies

We use basic, mandatory cookies to provide users basic services, such as to store user sessions. If we didn't, users would be forced to log in each time they visit the site which doesn't align with the experience we wish to provide.

# Data Storage

Our platform operates in and stores data within the United States of America.

# Data Deletion

At this time, data deletion requests from our platform are not supported.

Data is re-fetched from relevant services periodically in order to update your username and other basic profile information. If your osu! account is deleted or otherwise inaccessible via the [osu! API](https://osu.ppy.sh/docs/index.html), we will no longer update your information on our end.

# Data Distribution

Outside of what is defined in the below sections, we do not engage with, sell, share, or distribute your information to any third parties.

## Compliance

We periodically archive and share a subset of our data publicly, specifically for the purpose of complying with [rules](https://osu.ppy.sh/wiki/en/Tournaments/Official_support#programs) outlined by the [osu! Tournament Committee](https://osu.ppy.sh/wiki/en/People/Tournament_Committee). This includes, but is not limited to:

- Match and player data fetched from the [osu!](https://osu.ppy.sh/docs/index.html) and [osu!track](https://github.com/Ameobea/osutrack-api) APIs.

## Donations

Users who choose to donate via [Buy Me a Coffee](buymeacoffee.com/stagecodes) will have their personal information processed by Buy Me a Coffee and Stripe. That personal information will be stored in accordance with their policies and is not stored by us.

[^1]: A user is an osu! user who has logged into our platform via osu! OAuth.
[^2]: A player is an osu! user whose data is automatically stored as part of our tournament submission process.

# Data

The o!TR team maintains a publicly accessible archive of database replicas to support two key objectives:

1. Facilitating development and contributions to the official [o!TR repositories](https://github.com/osu-tournament-rating/).
2. Ensuring that interested parties may verify a tournament using o!TR to seed or filter registrants did so legitimately.

## Public Replicas

Database replicas are published every Wednesday at 00:00 UTC and are stored in a Google Cloud storage bucket. **The public may browse available replicas [here](https://data.otr.stagec.xyz/).**

These public replicas omit the following information due to security and user privacy concerns:

1. Admin notes
2. Audit logs (tracks the state of entities over time)
3. Logs (general purpose logs)
4. OAuth clients
5. User friends (who an osu! user is following)
6. Users (of the o!TR platform)

Refer to the [[o-TR-Database-Disaster-Recovery|disaster recovery]] guide for instructions on importing a replica locally.

> [!note]
> By downloading a public replica, you agree to comply with our [terms of use](https://data.otr.stagec.xyz/).

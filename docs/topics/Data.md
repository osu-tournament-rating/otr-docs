# Data

The o!TR team maintains a publicly accessible archive of database replicas to support two key objectives:

1. Facilitating development and contributions to the official [o!TR repositories](https://github.com/osu-tournament-rating/).
2. Ensuring interested parties can verify a tournament (which used o!TR to seed or filter registrants) did so in a legitimate manner.

## Public Replicas

Database replicas are updated weekly and stored in a Google Cloud storage bucket. **The public may browse available replicas [here](https://data.otr.stagec.xyz/).**

These public replicas omit the following information due to security and user privacy concerns:

1. Logs
2. OAuth clients
3. Audit logs
4. User friends
5. Users
6. Admin notes

Refer to the [disaster recovery](Disaster-Recovery.md#restore-the-database) guide for instructions on importing a replica locally.

> By downloading a public replica, you agree to comply with our [terms of use](https://data.otr.stagec.xyz/).
>
{style="note"}

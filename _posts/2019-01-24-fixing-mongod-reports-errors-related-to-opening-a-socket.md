---
layout: post
title: "Fixing mongod reports errors related to opening a socket"
date: 2019-01-24
---

tl;dr If you get a complaint about the socket already in use try running the `mongo` shell twice.

For the past 24 hours I have been trying to fix a MongoDB error where anytime I attempted a connection Mongo would complain that the socket is already in use.

This is a common enough problem that it is covered in the [Troubleshoot Ubuntu Installation section of the MongoDB documentation](https://docs.mongodb.com/manual/reference/installation-ubuntu-community-troubleshooting/#mongod-reports-errors-related-to-opening-a-socket).

Unfortunately the recommendation to shut down the existing process and try again wouldn't work for me. I would kill the process in terminal, but the same complaint would happen when I started everything up again. Changing to a new port wasn't an option for me either. I was trying to run a complex application where the built-in assumption was that you were running MongoDB on the default 27017 port.

A fresh install of MongoDB didn't fix anything, and all the various suggestions I found on Stack Overflow and Stack Overflow clone boards also didn't fix anything either.

However I did accidentally fix the problem, and I'm here to share what I did. After running `service mongod start` I ran the `mongo` shell twice. The first time I ran it I received the error message with the web socket complaint. However the second time the problem just went away.

I was hoping by the time I got through this troubleshooting session I would be able to write some in-depth technical explanation about the inner workings of MongoDB. Unfortunately my actual solution was a fix that doesn't make any sense to me. Still, since I hadn't come across this suggestion in all my troubleshooting research, I decided it would be in the public interest to share this information in case it might help someone else that was similarly stuck.

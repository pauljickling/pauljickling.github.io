---
layout: post
title:  "Compare Text Evaluation"
date:   2017-04-01
categories: node
---

When I was developing the Dream Stream app I had two copies in separate directories. They were basically identical except one directory was for my GitHub repository and lacked the client ID number necessary to interface with Twitch's API.

Over time I became nervous that there might be some discrepancies between the two directories. Comparing code side by side seemed tedious and inefficient, it's easy enough for your eyes to glaze over a minor discrepancy. Instead I wrote the Compare Text script. When running the script in the command prompt it takes two files as its arguments, and it checks to make sure if they are identical or not.

In my initial version of Compare Text it also output some text files that listed the location by character of the text discrepancies, and the character differences. This was useful if there was one or two differences between files, but if there were lots of differences than the text files were just a big jumbled mess to sift through. So I ended up removing that feature.

Compare Text is a very straight forward program of limited utility, but it felt good to be able to create a tool quickly that I could use to check my own work.

---
layout: post
title:  "Looking Ahead to Dream Stream 2.0"
date:   2017-09-16
categories: dota javascript ruby
---
Yesterday Valve revealed [the format for the professional competitive Dota scene](http://blog.dota2.com/2017/09/the-dota-pro-circuit/) for the coming year. Most significantly, players will now earn points throughout the year by participating in Valve approved tournaments. As next year's International tournament approaches invites to the tournament will be assigned to teams based on the cumulative points acquired by players of those teams.

This new point system is an opportunity to further develop Dream Stream. Previously the only metric Dream Stream evaluated was the performance of players in public ranked matches. Now there is a chance to also measure professional players based on their performances at tournaments.

Introducing this new feature will involve a significant rewrite of Dream Stream, and presents several challenges, and open questions about how to proceed forward. I want to discuss those, but first I would like to articulate the goals that I am looking to achieve in pursuing a rewrite.

Goals
-----

Aside from the obvious objective of introducing a new feature to Dream Stream, I see the opportunity to accomplish other objectives I have been interested in for some time.

1.    Refactor the code base: Since originally writing the code to Dream Stream, I've become better acquainted with the types of data structures you can include in your code, and so this is an opportunity to produce a much more efficient script.

2.    Improve the visual layout of the website: I've also learned a lot more about frontend design principles since I first wrote Dream Stream, so this is also an opportunity to render a more attractive display.

3.    Remove jQuery from code: I've learned enough about the mechanics of pure Javascript that relying on jQuery feels unnecessary to me at this point.

Open Questions and Challenges
-----------------------------

There are also a lot of problems I am going to have to solve with this rewrite. The most pressing one will be how am I going to collect the data for the points professional players are accumulating? This won't be totally clear until the conclusion of the first tournament when there are actually players with points to display. How is Valve going to share this data with the public? Will there be a JSON file I can get access to? If not, I will have to scrape the data off their website. The best scraping tool I am familiar with is Nokogiri, a Ruby gem. If that is the case, I may end up writing Dream Stream as a Rails app. Since I'm not as familiar with Ruby as I am Javascript, that could lead to unexpected challenges.

---
layout: post
title: "Dream Stream 2.0"
date: 2018-06-05
categories: javascript scraping grid handlebars
---

Dream Stream 2.0 was a big shift to adopt more contemporary web design practices.

The first version of Dream Stream presented data in a table with ten rows. If there were more than ten entries in the JSON package it wouldn't render that. By contrast Dream Stream 2.0 writes a string to JSON on the server that the client renders to display all relevant entries. Also they are displayed as cards inside of a CSS grid container instead of rows in a table.

The interactive elements of Dream Stream 2.0 feature buttons that have a more flat design that we associate with the contemporary web.

The majority of the work for Dream Stream 2.0 was on the back-end. The introduction of the qualifying points system to the professional tournament scene was an opportunity to show website visitors skill levels along a different axis. However there were several challenges with the implementation.

The first step was collecting the data. Valve set up a procircuit route on the dota2.com site, but there wasn't an API available to interact with so that meant I needed to scrape the data. I ended up using Puppeteer, Google's headless browser. Although Puppeteer worked great as a scraping tool, it did end up having some unintended consequences when I moved into a production environment. Puppeteer requires a build pack to run on Heroku, and all of its dependencies makes pushing updates significantly slower, enough so that you could go off to make a cup of coffee while you were waiting. Although I don't have any intentions to switch from Puppeteer, it did mean that I had to be a lot more careful about pushing updates because quickly fixing a mistake could be a 10 minute long process where previously it would have been less than a minute.

The greatest challenge though was managing two disparate data sets, and combining them into a single JSON source the client could fetch. The issue was on the one hand I had JSON data that I had retrieved from the Dota 2 leaderboards, and on the other hand I had the JSON data I had written from the scraping tool. Since there would be some overlap entries where players might appear in both JSON packages how should I go about handling that data?

My solution was to create a Map object called `playerMap` that supplemented an array I was using to sort the data. When the map was created I stored the player name as the key, and the index position in the array as the value of the map. By doing this I was able to write a function that checked the scraped JSON data, and if the player's name was already in the Map, it knew where to update the array using the Map's value. If the player's name wasn't in the Map then it could simply be pushed to the array. Once this was done the players could be sorted along either their leaderboard rank, or their qualifying points. This work taught me the importance of finding the right data structure for the job.

Two other minor points that are worth mentioning. As I rewrote the code I started writing everything using ES2015 syntax, and am now perfectly comfortable writing that way. By far my favorite feature of ES2015 is string interpolation. It is a much easier way to create a string using variables rather than the concatenation methods of the past! Additionally, I also eliminated all use of jQuery, and everything is written in "pure" Javascript. While there's nothing wrong with jQuery, Javascript has become a robust enough language on its own that jQuery often feels like a redundant library to include.

Yesterday <a href="http://blog.dota2.com/2018/06/the-dota-pro-circuit-2018-2019/">Valve announced</a> changes to the tournament structure for next year, so Dream Stream will have to change yet again. Qualifying points are now associated with teams instead of players. I am not sure at this point if I even want to include qualifying points anymore since it is arguably less meaningful as a metric for an individual player. In addition to changing the association of the points, Valve eased up on the rules regarding player transfers, so it is possible there will be much more roster swapping in the coming year. Regardless of what I decide to do, at a minimum the scrape tool as it is written will cease to work, so I will need to make some adjustments in the near future.

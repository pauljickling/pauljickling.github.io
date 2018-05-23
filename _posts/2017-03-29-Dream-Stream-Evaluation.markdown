---
layout: post
title:  "Dream Stream Evaluation"
date:   2017-03-29
categories: node express twitch dota
---
<img src="https://pauljickling.github.io/assets/img/dreap_app1.png" alt="Screenshot of Dream Stream app">
Dream Stream was the first independent coding project I put together, and it has been a terrific opportunity to learn a lot of different aspects of Node and Javascript. While developing Dream Stream I learned how to:

*    Interact with two separate APIs
*    Parse JSON files
*    Write code to run a server
*    Filter and sort data in objects and arrays
*    Write code that can handle asynchronous communications
*    Become familiar with handlebar templating
*    Use CSS to create a responsive design
*    Use values from a drop down menu to filter live data

So there is a lot going on even for this relatively straightforward app!

First thing's first, what does Dream Stream do? It takes the data from the leaderboards for Dota 2, a popular PC multiplayer game, and cross checks that data with Twitch's API for who is currently streaming right now. That way anyone that is curious can quickly see who are the highest skilled players currently streaming the game at any given moment.

Initial Development
-------------------

I remember that I was able to write an initial prototype for the app over a single weekend. It was a really simple Node script that just outputted some text when you ran it, but it did the basics.

The biggest change that happened between the simple Node script, and the web app version was a reduction of biases in how to collect data. In the original version the script checked from a hand selected group of players, and it also only looked at the leaderboards for the Americas and Europe (there are also leaderboards for China and Southeast Asia).

The problem with a hand selected group of players to examine is obvious on its face. It can't display any users that I don't personally know about. As soon as I became more comfortable working with Twitch's API this was the first change I made.

The problem with only checking the European and American leaderboards is slightly more interesting. The assumption behind that one was that Twitch streamers are overwhelmingly from those regions. I've since discovered some exceptions, but that is still mostly correct. The bigger problem comes from professional players playing in tournaments all over the world. When Western players practice in bootcamps in Asia, it is the Chinese and Southeast Asian leaderboards they will start appearing on. The original script wouldn't pick up on any of that information.

What Dreamstream Does
---------------------

Although there are a lot of moving parts to the Dream Stream app, the core logic comes down to these lines of code in the collectdata.js file:

    request(login, function(error, response, body) {
      function filterPlayers(playerNames) {
        filteredPlayers.push(playerNames.filter(function(x) {
          return x == streamers[n];
        }).toString());
      }
      if (!error && response.statusCode == 200) {
        var live = JSON.parse(body);

    for (var i=0; i < live.streams.length; i++) {
              streamers.push(live.streams[i].channel.display_name);
              twitchUrls.push(live.streams[i].channel.url);
              logos.push(live.streams[i].channel.logo);
              lang.push(live.streams[i].channel.broadcaster_language);
        }
        nameSwitch();
        for (var n=0; n < streamers.length; n++) {
              filterPlayers(totalPlayers);
        }
        clearArray(filteredPlayers);
        getTwitchUrl();
        finalList();
        complete.sort(function (a, b) {
          if (a.mmr > b.mmr) {
            return -1;
          }
          if (a.mmr < b.mmr) {
            return 1;
          }
          return 0;
        });
        fs.writeFile("./public/dreamstream.json",
          JSON.stringify(complete), "UTF-8");
      } else {
          console.log("Error: " + error +
          " Status code: " + response.statusCode);
      }
    });

It starts simply enough with a request JSON function. login is a variable that includes the URL of the Twitch API call plus the API key which is not included in the public GitHub repository, but that I use in the Heroku app. The request is for a JSON file that includes a list of streamers on Twitch that are currently playing Dota 2.

Included within the request is the `filterPlayer` function. Unlike some of the other functions written for DreamStream, this one runs into scoping issues when outside of the request function because it relies on a variable defined in a for loop located within the request function. Therefore this function also necessarily needs to exist here, otherwise when the script runs there is no way to understand what variable y refers to. This function filters the array provided in the parameter and checks to see if the values of that array also exist in another array (called `streamers`). If it is, it is pushed to a new array called `filteredPlayers`. Essentially, the function is checking two different arrays and passing the value to a new array.

If the request receives a successful response from the Twitch API for the JSON file we set the contents of that JSON file to a variable called `live`. Using a loop all the information we'd be interested in from the JSON file is pushed to new arrays: the name of the streamer, the URL of the stream, the stream's logo, and the streamer's language.

Because some streamers have a different name on Twitch than the name they use in Dota 2, I used a `nameSwitch` function to adjust some of the names so that when we run the `filterPlayer` function afterwards to check the list of the leaderboard players with people currently streaming it doesn't ignore players that should be included. After running the filter function the new array will have some empty values, so we run a `clearArray` function afterwards to remove those values from the array.

The `finalList` function finally adds all the other values we collected in separate arrays, and creates our final array called complete where each value is an object that contains name, MMR, Twitch URL, logo, and language properties.

The final step is to sort the array by MMR, and then write the complete array to a dreamstream.json file.

Current State
-------------

I'm very pleased with how Dream Stream has turned out. The feedback I've received from the Dota community that I've shown the app to has been extremely positive. The site loads quickly, is responsive (I think it looks particularly nice on tablets), and I've yet to encounter any off behavior.

Things to Improve/Criticisms
----------------------------

The structure of the collectdata.js file reflects my novice status as a programmer. It is currently a somewhat complicated web of arrays and objects that could stand to be refactored in a more elegant fashion.

The HTML page is setup so that it has a table, and a jQuery script writes the data to that table. As it is written, there is a limit of ten entries possible. In practice, that hasn't been a problem thus far because I've yet to see ten people, much less more than ten streamers show up. Still, it would be better to be prepared for such an occurrence. Setting up data structures the way a framework like Angular handles things is an obvious next step.

There are also some issues with the way some of the functions in Dream Stream are currently written. I found I was really struggling with handling asynchronous callbacks. I resorted to an ugly brute force solution of inserting some `setTimeout()` functions to basically give certain functions time to run properly. I know this is bad practice, and it is something I want to fix. I'm currently teaching myself ECMAScript 6, and I'm hoping the Promise object in that will make more sense, and I'll be able to use it to write some code that handles asynchronous data properly.

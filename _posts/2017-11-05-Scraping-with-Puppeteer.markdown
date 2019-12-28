---
layout: post
title:  "Scraping with Puppeteer"
date:   2017-11-05
---
[Puppeteer](https://github.com/GoogleChrome/puppeteer) is a Node library that provides an API for a headless Chrome browser. A headless browser is a browser with no graphical user interface, which is a useful tool for testing and other sorts of automated tasks you might want to perform, including web scraping. I found the web scraping tools to be very powerful even if the documentation for them is limited at the moment. This was a timely issue as I had been previously considering the question of how I wanted to scrape data off of [the Dota 2 pro circuit page](http://www.dota2.com/procircuit).

After installing it via NPM you can write a script that looks something like this:

    const puppeteer = require('puppeteer');

    (async () => {
      const browser = await puppeteer.launch();
      const page = await browser.newPage();
      try {
        await page.goto('http://www.dota2.com/procircuit');
      } catch(e) { console.log(e) }

      await browser.close();
    })();


Setting the Javascript aside, this should seem intuitive to anyone that has used a web browser. Essentially the script launches the browser, then opens up a page to view content, and then the page loads a URL. Once you are done performing whatever operations you want to conduct you close the script out by closing the browser. The code is crystal clear to read thanks to the async/await keywords available in current versions of Node. Nearly every script that utilizes Puppeteer is going to start off with this introductory bit of code.

Now that we have our headless browser up in running it is time to collect some data from our website. The data I'm interested in at the Dota pro circuit page is in a table, and I'm only actually interested in the columns for the player names, and the points they have accrued. Luckily this page is semantically well-organized, so when I inspect the elements I find the `span.columnContent.playerNameColumn` and `span.columnContent.pointsColumn` classes. Selecting those classes will produce the exact data I'm looking for.

    const nameResult = await page.evaluate(() => {
      let nameArr = [];
      let playerColumn = document.querySelectorAll('span.columnContent.playerNameColumn');
      for (let i=0; i < playerColumn.length; i++) {
        nameArr.push(playerColumn.item(i).textContent);
      }
      return nameArr;
    });


As best I can tell, `page.evaluate` is the way you want to return DOM elements using Puppeteer (if I'm wrong about this, please email me, I'd love to know more!). The rest of it looks like a typical operation where a for loop pushes values into an empty array. However I do want to call attention to one particular line that caused me an enormous amount of difficulty until I figured out a subtle but important distinction:

`nameArr.push(playerColumn.item(i).textContent);``

If the `playerColumn` variable were a normal array this is not how we would write this. Instead it would look like this:

`nameArr.push(playerColumn[i].textContent);`

But `playerColumn` is not an array. When you perform a `document.querySelectorAll` call you retrieve an object called a Node List. This is an object that is similar to an array, but not identical to one. They share some methods like `.length`, but the NodeList departs from the array in many other respects. You can read more about Node Lists [here](https://developer.mozilla.org/en-US/docs/Web/API/NodeList). For our purpose, the important thing to keep in mind is that a Node List has a syntactically distinct way of iterating through its items.

Having created a method for collecting the list of player names, we can now repeat that process for selecting the player points.

Web scraping is a fantastic tool to have at one's disposal. It provides a way to collect data even if an API call or JSON request is unavailable. Of course it is important to use web scraping responsibly, and not perform any web scraping operation that would infringe on another individual or party's copyrights.

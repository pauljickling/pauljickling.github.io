---
layout: post
title: "Creating a Whiteboard App in Django"
date: 2018-07-30
---

Like anyone else looking for a job as a software engineer, I've been studying and practicing the sort of problems that get asked during the whiteboarding section of the interview. My typical habit is to come up with an answer to a problem, see if it works or not, and then mark up some comments about what I got wrong, and try again the next day. I keep repeating that until I can answer a problem without any errors.

While this is a reasonable way to get comfortable answering these kinds of problems, I was running into an issue with keeping track of all my various files. It didn't help that I could rarely come up with helpful names for my files. So I would end up having to sift through directories full of dozens of files trying to keep track of my answers. It finally occurred to me that my process would greatly benefit from having a database to manage everything. So last week I decided to start working on an app on Django, and yesterday I finished the MVP version.

This was also a good opportunity for me to work on a relational database instead of using MongoDB. The app consists of two models: a problem model and an answer model. The answer model has a problem as a foreign key since every answer has to have a problem, but there can be problems without answers. It's a natural fit for a relational database since one of the things I want the app to do is show previous answers associated with a particular question. You can do this in MongoDB as well, but it all fits together nicely when you're using a relational database.

In addition to the stated question, the problem model features a starred field, and a category field.

The starred field isn't utilized at the moment, but I'm anticipating in future versions a user will be able to star particular problems that they want to go back to.

The category feature includes a drop down menu of problem categories (sorting and searching, trees and graphs, recursion and dynamic programming, etc.) Although the view layer does display the category of problem, this doesn't currently do anything else, although in future versions I could implement a feature that would allow a user to select the types of problems they want to work on. At the moment all that happens is a randomly selected problem pops up on the screen.

The answer model includes fields like the language the user uses to answer the problem, a boolean field for whether the answer is correct or not, and the date of the answer.

Lately I've been experimenting with a Django and React stack, and I personally feel like the two pieces of tech complement each other nicely. However since this app is essentially just a glorified form page React felt like overkill. Instead I opted to use Bootstrap to make the forms look nice, and then add a little bit of custom CSS for a couple of presentation and layout issues like using a monospace font in the answer for, and creating a nice grid layout for the displayed answers.

Once I finished the app I discovered I had solved a problem I didn't even realize I had. One of the books I have been working from is *Cracking the Coding Interview*. This is a thick tomb of a book where when you open it up if you aren't holding it down with one of your hands the book will close back in on itself. As a piece of physical interaction this made it a nuisance to work with. It's a much nicer experience to just have these problems in a database that I interact with on a computer. It's a great feeling when you realize something you created has benefits you didn't even anticipate.

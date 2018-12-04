---
layout: post
title: "Debugging with grep"
date: 2018-09-18
---

There are a couple of standard pieces of advice for debugging software:

1. Create break points to figure out where something goes wrong
2. Create strategic print statements to figure out what is happening
3. Use the scientific method to reason about things

This is all very good advice, and how I approach debugging as well. However I have an additional piece of advice to give new developers that are trying to determine the source and solution to a bug: utilize recursive grep queries.

## What is grep, and why should I care?

grep, somewhat unhelpfully, stands for "global regular expression print". In plain English it is a command line Unix tool that uses a search pattern (i.e. a word or regular expression) to find instances of that expression. Most text editors have a find tool, so if you just wanted to use grep to find a word in a particular document without using regular expressions, you might be wondering about the value proposition. However the recursive flag is where grep truly shines. That allows you to search all files starting from the root directory into all the subfolders for a particular search pattern. This is incredibly powerful when you're dealing with a large, complex directory.

As software engineers we are encouraged to separate our code into discrete modules. This makes it easier to understand the interface of a piece of software, but it can come at the cost of understanding the program's flow of control. It is not uncommon to create a library of objects, each with an assortment of methods. And those methods might be called on by other libraries, and at that point if there is a bug in the code it could be very deeply nested, and not at all obvious where you should look to fix it. This is where the recursive grep query comes to the rescue, and allows you to follow the chain of calls so that you can begin to understand the control flow.

So lets say you've utilized break points and print statements to locate the point in the program where the bug is being generated, but all you have is a called method, but you have no idea where to find this method. In the root directory you can run:

`grep methodName -r`

This will create a list of instances and file names where your `methodName` comes up. At that point you can examine the files, find where the actual method is defined, and figure out what is going on. Sometimes that will lead to another method you have to look up, and so you repeat the process until you are able to generate an understanding of what is actually happening when a particular method is called.

Hopefully the method you are looking up has a unique name. But of course there is always the possibility that you are looking into a method with a generic name. I encountered this issue during my most recent debugging experience where I had to lookup a method called `addItem`. Well, it turns out the libraries and modules for this project had tons of methods called `addItem` so my recursive grep query slowly generated a ton of useless results. In those instances, you need to figure out some way to limit your results. Luckily there are flags that allow you to exclude directories. So, for example, when I was querying `addItem`, I wrote:

`grep addItem -r --exclude-dir=node_modules`

This excluded all the npm dependencies the project was using, and eliminated thousands of results down to two! With a couple of thoughtful queries, recursive grep searches is one of the most powerful debugging tools I know of. As you get more comfortable with grep and other tools available in the Linux command line you will be able to accomplish even more. For example, you could output your grep search into a file that can be referenced there instead of the standard output on the terminal:

`grep -Hn [0-9] file_name.txt > search_results.txt`

Here we are using the `-Hn` flag which will prefix our output with the filename and line number. We are using a regular expression for our search pattern that will look for any digits, and it outputs the file to search_results.txt.

---
layout: post
title: "Technical Interviewing Tips"
date: 2018-11-26
---

There are a lot of things you need to prepare for for a technical screening. This post won't go over the data structures and algorithms you need to rehearse before going into the interview, but instead will cover some other general things that are good to have a handle on.

#### String and Array Slicing

As mentioned in my blog post on dynamic programming, slicing is really useful, so you should be comfortable with how you do that in whatever language you work in. In a language like Java there are methods you need to use to do this. In something like Python you can get really expressive. For example, here's a single line of code that creates a reversed string: `new_string = old_string[::-1]`

Learning to use regular expressions is also valuable here. Regular expressions are powerful and highly efficient.

#### Optimization

You've solved the problem that your interviewer gave you. Great! Now its time to optimize your algorithm. Here's where Big O analysis comes in handy. Go through your code and figure out the runtime complexity of the different components. Anything that isn't O(1) is a potential candidate to take a look at.

Also don't forget about space complexity. Lets say you have an array containing single characters. The size of characters varies, but lets say it is something like 8 bits. You may not need that many bits. So you could use a hash table to convert your characters into binary, and shave off a lot of unneeded bits.

#### Using Hash Tables

Speaking of hash tables, you should always think about how they might get integrated into a solution you are working on. There's a reason they are considered the most important data structure in computer science! If you are working on a solution, and are about to add a bunch of if statements to handle different inputs, see if you can't use a hash table to handle that logic instead.

#### Checking for Errors

This is an area that is really easy to get dinged for in interviews. You have the right idea in your solution, but you haven't foreseen particular edge cases that will create bugs. Unfortunately I don't have any good advice for how to get better at this besides lots of practice, but you should try to give yourself an honest self-evaluation about how good you are at anticipating and handling these edge cases.

---
layout: post
title: "Dynamic Programming Basics"
date: 2018-10-28
---

Dynamic programming is confusing for a lot of people. Even the name is strange, and it's by design. It was coined by Richard Bellman (the same Richard Bellman of the Bellman-Ford algorithm) as a deliberate term of obfuscation to hide the fact that what he was up to at the RAND corporation at the time was mathematical research.

So dynamic programming is kind of a meaningless term, but what does it actually refer to? Essentially, it is a technique for solving optimization problems that can be broken down into simpler sub-problems, and then solved recursively.

The simplest example of dynamic programming is designing a function that solves the Fibonacci sequence. Lets recall what a simple recursive implementation looks like.

```
def fib(n):
    if n <= 1:
        return 1
    else:
      return fib(n - 1) + fib(n - 2)  
```

One thing that is unfortunate about this type of recursive technique is that you will evaluate a lot of statements you have already solved as you work your way through the recursive formula. It would be better if our algorithm could remember these results so that as we worked through the problem we could skip statements that have already been encountered. Luckily we have a data structure that can do that for us, the hash table.

```
def fib(n):
    memo = {0:0, 1:1}
    if n not in memo:
        memo[n] = fib(n - 1) + fib(n - 2)
    return memo[n]
```

This process of storing our results in a hash table is called *memoization*, and it is useful because hash table look ups take O(1) time. Note there is also another dynamic programming technique called the bottom-up approach that is sometimes used instead of memoization. I'm not going to go into it here, but just know that it exists and is an equally valid approach to solving problems. Usually either approach works, but for certain problems one might be a little simpler to understand and implement than the other.

Now that you've seen this memoized Fibonacci function, you basically understand everything there is to know about dynamic programming. Of course, most problems that involve dynamic programming are more complicated than calculating Fibonacci numbers, but the steps towards solving the problem remain the same. Every dynamic programming problem will have the following elements:

1. Reducing a problem into smaller sub-problems. You want to start by solving the simplest possible sub-problem, and that will be your base case to end the recursion.

2. A recursive solution for solving sub-problems.

3. Memoization.

Another way to think about it is that dynamic programming is a slightly more elegant/efficient version of a brute force solution. If you are trying to solve a problem where you necessarily have to consider every possibility among a list of possibilities, you are most likely dealing with a dynamic programming problem, and with any luck using these techniques will give you a solution that is in polynomial time.

There are two things that make dynamic programming problems difficult to solve.

The first is figuring out what the sub-problem is you need to solve. Unfortunately there isn't any magic technique for figuring this out. You just need to think about the problem you are dealing with. I recently was working on a problem that asked the following: given a number of cents (n), output the number of combinations of pennies, nickels, dimes, and quarters that are possible. Figuring out an elegant recursive technique for solving this is definitely not obvious! I'll give a hint though: for quarters the recursion is (q * 12) + ((q - 1) * 12 ) + ((q - 2) * 12), etc. where q is the number of quarters. Can you figure out what's special about the number 12?

The second tricky thing about dynamic programming problems is they often involve splicing. You may have an array of numbers, and then need some specific combination of numbers from the array. One thing I've found when you are doing splicing for these types of problems is that off by one errors are very easy to make. Splicing lends itself to these types of errors since the first parameter is inclusive of the integer position, but the second parameter is not. It's a good thing to keep in mind while double checking your work.

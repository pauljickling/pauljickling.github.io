---
layout: post
title: "The Value of while"
date: 2018-08-22
---

When you are learning to program you come across certain pieces of advice that are helpful, but not entirely accurate. The intention is not to be misleading, but to act as a safeguard against the mental habit to abstract away subtle details that, when ignored, lead to buggy software. So in Javascript we are taught to use `===` evaluators instead of `==`. In truth both operators have their value, it just depends on whether we care about evaluating data types or not. Similarly, I remember learning about how to write a while loop, and then quickly being told to forget all that and use for loops.

## Why are there `while` loops at all instead of nothingness?

It's easy to understand why a for loop is generally preferable to the while loop. Creating an infinite while loop is incredibly easy. Although it is not impossible to write an infinite for loop, it is harder to write one by accident.

And yet while loops exist in just about every programming language. So what is the value of a while loop, and when should we use it?

Lets ask a different question first. What is the most obvious application of a for loop? To my mind, it would be iterating through a list. In Javascript:

```
for (i of iterable_object) {
  // do something
}
```

We now have a loop that goes through every element of our `iterable_object`, be it a string, array, or some other type of object with multiple elements.

How is the for loop able to perform its operation? It needs a unit of measurement for a single element (i), it needs to know how to count, and it needs a unit of length for a terminating condition.

Now that we know what are the necessary conditions for a for loop, we can now imagine instances where we need to use a different type of loop. That is, when we don't have the necessary conditions for a for loop, it follows that we need a different type of loop. One obvious example is when we don't know how many times our loop needs to run. This comes up when we are dealing with random numbers.

Imagine we have two randomly selected numbers from a list, and we need one of the random numbers to become the same as the second. Here's an example in Python:

```
import random

numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]


def random_select(list):
    selection = random.choice(list)
    return selection


random1 = random_select(numbers)
random2 = random_select(numbers)

while random1 != random2:
    random2 = random_select(numbers)
    if random1 == random2:
        break
```

We have a list with the numbers 0 through 9. We also have a function that randomly selects a value from that list. We then create two random variables using that function. We can make those variables the same by first testing if they are equivalent, and if not to create a new random selection for `random2`. However there is one more incredibly important aspect of this code, and that is the included if statement. Without the if statement, this while loop will be infinite because even though we are mutating the value of `random2` that change is happening within a scope that our while loop is not considering when evaluating its condition. In other words, even if the random selection in the while loop is the same as `random1`, our while loop isn't considering that condition, it is only considering the initial randomized value. Therefore this loop will repeat forever unless we create a new terminating condition with the if loop. So each iteration of the while loop needs to recheck if `random1` is now equal to `random2`, and if so break.

You might be thinking that getting one random number to be the same as another random number isn't particularly useful, and you'd be completely correct. However imagine working with data structures that are slightly more complex than a list of numbers, and the utility becomes more apparent. I encountered this when I added a new feature to [my Whiteboard app](https://github.com/pauljickling/whiteboard).

The Whiteboard app randomly selects a problem to serve the user. Every problem has a category it belongs to: string manipulation, optimization problems, recursion, object-oriented design, etc. These categories are all displayed on the top of the page as a navbar menu. So I wanted a feature where the randomly selected problem would belong to a category that matches the user selected category. Now we have a use case. Instead of testing if `random1 != random2` we are testing if `user_selection != random_problem.category`. The user selection isn't random, but it also isn't knowable in advance so it is almost as if you are designing for two random selections. And the while loop is there to serve a purpose.

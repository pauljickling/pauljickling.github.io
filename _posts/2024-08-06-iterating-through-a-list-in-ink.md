---
layout: post
title: Iterating Through a List in Ink
date: 2024-08-06
---
Ink's lists are not an array like in Python. Instead they are boolean sets. They are mostly used for activating and deactivating certain elements within the set, or perhaps incrementally moving along the elements of the set. As such, Ink's list lacks a lot of the functionality you would expect from an array, including pushing and popping elements, or iterating through the list.

However, since recursion is possible in Ink, it is still possible to iterate through a list with the caveat that there is some unexpected behavior that will throw up an error if you attempt an obvious implementation, as we will see below. This is how you might first attempt it:

```
=== function list_iteration(l, i) ===
~ temp length = LIST_COUNT(l)
{l(i)}
{i < length:
    ~ i += 1
    ~ list_iteration(l, i)
}
```

The function takes the list, and the initial integer value as its parameters, prints the content, and then if `i` is less than the length value of the list, increments `i` and calls the function again.

Unfortunately, if you write this code in Inky, it will throw up the following error: `since 'l' is used as a divert target... it should be marked as -> l`. Needless to say, l is not a divert target, and if you try to implement the suggested change, it will not work. I believe this is an implementation bug.

At present, we can work around this bug by reducing an abstraction, and not calling the list itself as a parameter. This makes our code less DRY if there are multiple lists that you need to iterate through, but since the alternative is a program that won't execute that is the price you have to pay. The code below works for a list called `Numbers`:

```
LIST Numbers = (one), (two), (three), (four)

=== function number_iteration(i) ===
~ temp length - LIST_COUNT(Numbers)
{Numbers(i)}
{i < length:
    ~ i += 1
    ~ number_iteration(i)
}
```
Calling `number_iteration(1)` returns:
```
one

two

three

four
```

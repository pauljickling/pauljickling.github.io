---
layout: post
title: "Storylets in Ink"
date: 2024-01-29
---
Emily Short defines [storylets](https://emshort.blog/2019/11/29/storylets-you-want-them/) as having the following qualities:

- they are a piece of content
- they have conditions for when they can occur
- there are effects on the world state that result after they have played.

In another post, she describes [the algorithm](https://emshort.blog/2017/05/25/mailbag-high-agency-narrative-systems/) in plain English:

"Go through all the storylets, and list the ones whose requirements are currently satisfied. Next present a random sampling, or a complete list to the player to pick from. When the player picks one, display its content and execute the results, then go back to the beginning."

Providing all the options available is easy enough, although could represent a UI challenge depending on how large the list becomes, but a random selection is an interesting idea I like. The ink language has many limitations, but it has sufficient data structures and routing capabilities to provide for this. We start with a list.

`LIST Deck = (card1), (card2), (card3), (card4)`

I'm calling this list variable `Deck` based on Emily Short's idea that storylets can work as a kind of deckbuilding game, but whatever name is appropriate can be replaced here. If your narrative is organized by location then you might call it `Places`, or if it is character driven `Characters`, or more generically `Scenes` as they do in King of Dragon Pass, one of the more notable examples of a game that utilizes the storylet format.

As a quick review, a `LIST` variable is not like a list in Python, or even a linked list (although you can easily add some functions to give it some linked list properties), but is actually a boolean set. So each element in the LIST type is just a boolean variable. When we include the element in parenthesis it is assigned to `true`. Game state in any reasonably complex system can be difficult to track, so this is a useful data structure to use as a canonical source of truth. In our case we use the list for determining if a particular storylet is available for the player. If it is, we set it to true. In this simple example all storylets are available.

The loop of our game will involve a knot that acts as a container knot for our knot that provides available storylets.

```
=== main ===
-> storylets(Deck)
```

The `main` container knot is important because we need to pass our list as a parameter to the knot. We're going to perform some operations that we don't want to affect the actual `Deck` list.

The storylets knot is where the magic happens.

```
=== storylets(Storylets) ===

~ temp draw1 = LIST_RANDOM(Storylets)
~ Storylets -= draw1
~ temp draw2 = LIST_RANDOM(Storylets)
~ Storylets -= draw2
~ temp draw3 = LIST_RANDOM(Storylets)

+ [{choice(draw1)}] -> link(draw1)
+ [{choice(draw2)}] -> link(draw2)
+ [{choice(draw3)}] -> link(draw3)
```

The operations at the top involve selecting a randomly available card from the `Deck` we passed early as the `Storylets` parameter, and assigning it to a temp variable `draw1/3`. After a temp variable is assigned we set that variable to false in `Storylets` so that it can't be selected again. Then we repeat the process until we have the number of options we want to present the player. In this example, I have designed it for three choices made available to the player.

Next comes the choices presented. As you can see, we rely on a function called `choice` to provide the choice text (without this you'd be stuck with variable names for the choice). Then there is a divert to a knot called `link`. Both take the `draw` variables as parameters. So let's take a look at what these are doing.

```
=== function choice(x) ===
{x:
    - card1: The story of card one
    - card2: The story of card two
    - card3: The story of card three
    - card4: The story of card four
}
```

Ink doesn't have data structures like arrays or hash tables unfortunately, but it does have case switching blocks, so we can use those to provide the simple task of translating a variable name to a value that we want to use.

```
=== link(x) ===
{x:
    - card1:
        -> card1_knot ->
    - card2:
        -> card2_knot ->
    - card3:
        -> card3_knot ->
    - card4:
        -> card4_knot ->
}
```

A similar thing is happening with our `link` knot. Note how it is using the "[tunnelling](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#1-tunnels)" syntax, this way it is able to go from `storylets` to `link` to the actual destination without knowing in advance what storylets are going to appear, which it can't since they are random.

And that's the entirety of the plumbing for this structure. At this point you just write the knots that contain your content, and make them available by adding them to the deck, and enumerating them in the `choice` function and `link` knot.

Note that our `storylets` knot contains no conditional logic about whether a storylet is available or not. As stated earlier, we are treating our list as a source of truth. So our list will need to be updated somewhere in the storylets themselves. A typical structure will often involve a player making a choice of some kind, which will have affects like making certain storylets available, and other unavailable.

If you're interested in storylet implementation, be sure to look at this alternative approach by @smwhy [here](https://github.com/smwhr/ink-storylets/). There are many similarities in the implementation (I think out of necessity), but there are also some key differences. In this one the list is not treated as a source of truth for storylet availability, but instead as a First-In-First-Out priority queue of storylet variables. As a result, this requires an additional function to enumerate conditional arguments to see if a choice is available. Depending on the goals of your particular narrative design, this storylet construction could be a better model for what you are trying to accomplish.

---
layout: post
title: "The Oddity of Naming Conventions in Programming Languages"
date: 2018-10-08
---

I was recently thinking about how we implement variable names. In mathematics it is really common to use a single character for variable names. Why is that? The typical answer is that mathematicians don't care about what the variable represents at all, so it is best to use something completely forgettable. As far as abstract mathematics go I'm willing to accept that answer. But as we move closer to the world of applied mathematics, engineering, etc. that answer becomes less persuasive. In this domain we aren't simply solving equations anymore. Instead we are performing operations among variables that possess specific relationships to each other. In that case, don't I actually care about what this variable is?

```

C = 2πr

def C(r):
    p = 3.14
    return 2 * p * r

def circumference(radius):
    pi = 3.14
    return 2 * pi * radius

```

Here are three ways of expressing finding the circumference of a circle, once mathematically, once in Python using single character variables, and the other as a function in Python as it would typically be expressed.

If you look at the source code for programs written in the 1980s, you will see a lot of functions that might resemble the second example. When memory constraints were much greater, you would care about the length of variable names, and that could make the difference between a program you could or could not fit on a floppy disk. As we moved away from a memory constrained environment programmers have taken the liberty of having variable names that actually say something about what the variable name is, and this is considered good coding practice. So the old C style method of writing for loops expressed in Javascript is:

```
for (let i=0; i < things.length; i++) {
  console.log(i);
}
```

Now we express that differently:

```
for (let thing in things) {
  console.log(thing);
}
```

We got rid of the i for iterator. And this is a fairly trivial example, but it is one that most programmers will feel very strongly about. Yet when we're asked about the asymptotic complexity of an algorithm that finds the shortest path in a graph, we're still used to speaking in terms of O=(V+E) where V stands for Vertices, and E stands for Edges.

I think of languages as territories of experience. By territories I mean the rules of a language. So in semiotics they say that a sign has a signifier (for example, a word) that points to the signified (the meaning of the word). That a sequence of sounds or sequence of written characters is an identifiable unit of meaning for us is what I mean by a territory. It is something that has boundaries, and when you exceed those boundaries (by mispronouncing or misspelling a word) the meaning is no longer available. Unlike in math and in programming, it is common for our word-variables to have more than one meaning, and even to have fluid, unfixed meanings. That is because words act as territories for our experiences. Experiences are ephemeral things: memories, emotions, contexts, etc. They are typically not precisely defined, and they have histories. In Spanish you can talk about your "abuelita" (literally "little grandmother" in English) as a term of endearment, but translating it literally in English you lose that context of endearment. We are encountering different territories of experience. Different territories of experience can exist within the same language as well. Our vocabularies are established and reinforced by our class backgrounds, certain phrases have special meanings for different social groups, and the insularity of academic research and professional development produces particular codes of jargon. Being a good cosmopolitan citizen in a pluralistic society means learning how to navigate these waters.

All of this is to say that within the experience of a computer programmer dealing with variable names you will find overlapping territories of experience that demand context switching in particular instances. Hence the imperative that we must have useful variable names in our programs, but when we are discussing some sort of formal proof of our algorithms we have a different way of describing things.

What is most interesting to me about the development of variable names is the importance of the programming language you work in. So in Python you use underscore case to name things, but in Javascript you use camelcase.


```
def does_something():
    # does something

function doesSomething() {
  // does something
}

```

It is interesting to me that these stylistic rules break down along programming language lines. After all, the compiler or interpreter doesn't care about any of this. You could imagine an alternative universe where instead these kinds of stylistic rules were decided by whether you were a network engineer or devops engineer. So we have different territories of experience along programming languages where we expect code written in certain languages to look a particular way beyond the specific syntax of implementing the code.

This has an interesting consequence for Javascript. Since Javascript is the language of the web, programmers belonging to all these different tribes have to use it, with their competing territories that tell them what code should look like. So for example, Javascript had its method of prototypal inheritance, but lots of people found this confusing so in ES6 they added this class constructor syntax that was syntactical sugar for people from backgrounds like Python and Ruby. Note that Javascript itself didn't change, it still uses prototypal inheritance. But now you had this way of creating prototypes that looked more like how you would define classes in other languages. This is an unenviable role however: when you try to satisfy everyone, you end up satisfying no one. One exciting thing about the development of WebAssembly is in the future, more and more people will be able to write code for the web in whatever language they feel like. When that future arrives Javascript won't have to pretend to be anything but itself.

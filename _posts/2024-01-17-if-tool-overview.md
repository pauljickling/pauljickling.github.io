---
layout: post
title: "Interactive Fiction Tooling Overview"
date: 2024-01-17
---
Over the last year I've experimented with a variety of tools for writing interactive fiction. I thought it might be worthwhile to give an overview of the different tools available, and what some of their pros and cons are.

I initially tried to write this blog post giving a comprehensive overview of the different tools, but it became very long and rambly. So I'm going to constrain myself to a bullet point overview instead.

Also noticably absent from this list are any tools for developing parser based text games. Although there are parser games I have enjoyed playing, I personally feel the format is inaccessible and frustrating for most people, and only provides the illusion of freedom. As such I stuck to tools for choice-based interactive fiction since it would be the only format I would be interested in developing in.

## Ren'Py

Ren'Py is a visual novel engine. Although it can implement other types of games, visual novels is really what it excels at.

### Pros

- Light, expressive syntax for writing dialog and positioning character art
- Python under the hood that can be included in a ren'py script

### Cons

- Screens UI language is painful to work with
- Including data from class objects and dicts can be tricky
- Debugging tools are bad

## Twine

Twine is one of the most popular tools for writing interactive fiction. It is used to generate HTML files, and relies on hyperlinks for creating branching, choice based content. For those with a non-programmer background I think Twine is easily the best choice. But for those with such a background it can feel overly restrictive and a lot of choices might seem strange/frustrating.

### Pros

- Excellent choice for non-programmers
- Nice visual display of narrative flow chart
- Mostly nice syntax (although this varies considerably depending on Story Format choice)

### Cons

- Lack of version control
- Everything is located in your OS's temp folder, so if you want to include local images, for example, you have to write to full path
- Lots of options for "Story Formats", and not obvious which one will be the right fit for a project
- Lots of quirks that can be difficult to workaround
- Uneven documentation
- Lots of unappealing default CSS, but writing custom CSS can involve a lot of fighting the engine

## Undum

Undum is a client-side JavaScript framework for interactive fiction.

### Pros
- Really nice default presentation
- Works well for writing storylet content
- Well written, easily extensible JavaScript
### Cons
- Involves writing a lot of boilerplate JavaScript
- Not in active developmennt (afaict)

## Dendry

Dendry is designed as a first-class storylet engine.

### Pros
- Well suited for writing storylet based content
### Cons
- Documentation essentially limited to a barebones GitHub README and a single notion page
- Took me a fair amount of fiddling around with npm configs before I could get things going

## Inky

Inky is an IDE for writing in ink, a markup language for writing interactive fiction. If you have a programming background, I think this is probably the best tool available (as you can see based on the pro/con ratio).

### Pros

- Excellent IDE, and one of the few that I am happy to use over just writing in vim
- Excellent documentation
- Excellent debugging tools
- Highly portable
- Easily extensible, but with good defaults when generating web exports
- Great syntax
- Powerful features such as function-like passages (called "knots") that accept parameters, and a boolean set data structure for tracking game state

### Cons

- Lack of array and hashmap data structures, it's possible to overcome those limitations, although it isn't obvious how without purchasing the book on programming in ink 
- Difficult to google information
- You need to be very cautious if you are writing any kind of flow state that could result in an infinite loop. In trying to render the content on the right it will end up causing the program to hang.

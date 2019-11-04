---
layout: post
title: "Maybe TypeScript and React is Bad"
date: 2019-11-04
---

Statically typed languages are in, and with good reason. You catch errors earlier, and that makes you look better as a developer. Statically typed langauges care about data inputs and outputs, and complain if something unexpected happens.

```
function say_hello(name: string) -> string {
    return "Hello " + name;
}
```

Our `say_hello` function returns a string with the provided name. Crucially, it expects a string input and string output. That means if you try to provide `3` or `True` as a parameter, your compiler knows you are doing something you shouldn't be doing, and stops you in your tracks. Either make sure your function is actually receiving strings, or you need to think a little more carefully about how your function is supposed to work.

Statically typed languages are good because they reduce assumption making in your program, which minimizes an assortment of bugs that can be difficult to identify and resolve in functions that are more complex than the above example. They can increase development time, but with the tradeoff of eliminating a class of bugs, greater certainty about data, and hopefully less time debugging in the future. In general, this is a worthwhile tradeoff to make.

Because there is a growing consensus that statically typed languages are good, there is a lot of interest in introducing static typing to the popular dynamically typed languages: JavaScript, Python, and Ruby. Python has the optional static type checker MyPy, Ruby has projects like Sorbet, and JavaScript has TypeScript,a  JS superset developed by Microsoft.

The other major development in JavaScript land is that React has become synonymous with frontend development. You'll occasionally see people using things like Angular, Vue, or perhaps something else for frontend development, but at least if you glance at job listings in the Bay Area, overwhelmingly what you are seeing is a demand for React.

So naturally you might think, okay, static typing is in, React is in, I guess for my next web app I should do the thing using React and TypeScript.

Not so fast.

I spent the last 5 months or so working on a project that used this tech stack, and we're now having discussions about moving forward, and the overwhelming consensus of the team is to ditch TypeScript. Here are a few reasons why:

### TypeScript Won't Resolve Common Problems in Frontend Development

The types of errors TypeScript catches are not the typical sorts of errors you are worried about as a frontend developer. For example, errors like calculating and displaying time/date stamps correctly across different timezones is the sort of thing a frontend developer really ought to be concerned about in terms of guaranteed correctness, and on this front TypeScript offers nothing. For certain types of data heavy web applications TypeScript can certainly be useful, but I suspect for most use cases TypeScript will end up feeling like overkill for your project.

### TypeScript Will Make Googling Answers More Time Consuming and Difficult

99% of the time if I have a JavaScript question I can find an answer on [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript) and if I have a React question I can find an answer on [React Docs](https://reactjs.org/docs/). In the 1% of cases where I don't find an answer there Stack Overflow and the odd blogpost has always had me covered. However the introduction of TypeScript removes these two amazing resources because now I have to google how to do a React thing in TypeScript, and I find myself completely at the whims of StackOverflow and blog posts. And the relevancy of my query to the content diminishes, and the quality of answers likewise diminishes. This means that I suspect that that TypeScript is actually much more niche than it might appear if you spend a lot of time on HackerNews and other sites like that. This increases the amount of development time that makes the statically typed tradeoff less favorable, and also makes the language less fun to work with.

### Common Code Patterns Go Out the Window

While writing a very basic React component doesn't look that different in a `.jsx` file compared to a `.tsx` file, the story looks quite different once you start digging into more complex features. For example, using React's Context API or fetching the URL params for a React Router feature involve very different looking once you introduce TypeScript, and not for the better. In general I found it made the code more verbose, and less obvious to understand.

### TypeScript Makes Using Third Party Modules Painful

With the exception of some of the bigger libraries and modules like React Router, in general I found using third party modules to be much more difficult because these third party modules will have their own specified types and interfaces that you need to download (and hopefully they work, but they might not) and understand, and often documentation is wanting. And this is annoying because it defeats the whole idea of an API, namely that I shouldn't have to understand the API's inner workings in order to use it. Well, with TypeScript I do kind of have to understand those inner workings, otherwise I get a new class of errors from the compiler that are difficult to understand. Speaking of which...

### TypeScript's Compiler Error Messages are Bad

One of the painful aspects of working with JavaScript is you tend to bump up against a lot of very unhelpful error messages. So you would hope that TypeScript would offer an improved experience here, but in my personal experience that is only minimally true. Compared to the errors I've seen from other langauges like Rust, Elm, or Go, TypeScript's compiler warnings were generally vague and unhelpful.

There are some other nitpicky issues I have with TypeScript, but I think these above listed complaints get at the core issues I have when it is combined with React. In general, I am pro-static typing, and I think React's component composition structure is the way to go. However I don't like how TypeScript and React work together, and I would caution anyone to really think carefully along first principles to decide whether this particular tech stack is the right one for your project rather than jumping on board because these are the cool pieces of tech to use at the moment.

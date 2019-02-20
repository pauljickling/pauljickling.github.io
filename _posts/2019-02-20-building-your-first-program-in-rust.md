---
layout: post
title: "Building Your First Program in Rust"
date: 2019-02-20
---
In January I commited to learning a language I had been eyeing for over a year, Rust. At the same time I had picked up some contract work, and I wanted an easy way to keep track of the time I spent on various work. So in my spare time I started building a command line tool in Rust, and completed the MVP build the other day. The way it works is I can type in `tm start debugging`, and it will keep a log of how long I work on that activity until I type `tm stop debugging`. The output of the command is a csv file that contains a final field that contains the number of hours spent on an activity.

Rust has an earned reputation as a difficult to learn language. However one thing I learned from this project is you can get a lot done in Rust without the more complex and advanced features like traits, lifetimes, reference counting pointers, etc. In that way learning Rust is not unlike would liken it to learning Vim. Vim is famous for its difficult learning curve, but if you just commit to doing things simply at first (don't let the Vim police shame you for just going into insert mode and moving around with the arrow keys!), and building up from there, you will quickly feel empowered by what you are capable of doing.

I kept things dead simple for the MVP build. The *lib.rs* file has some functions to read and write files, and a few others that handle some data interpretation. Then in *main.rs* it simply accepts the terminal arguments, and goes through the necessary steps to construct a working csv file based on that input. There aren't any sophisticated data structures constructed with structs and enums. Those can come later when the complexity of the software increases with new features added. Instead I simply worked with a few modules from the standard library, and performed some string and integer manipulations.

I could have made things easier on myself (and it would probably have been better standard practice) had I decided to use external packages available on [crates.io](https://crates.io), but I made the decision early on that I would not do that in order to really engage with the fundamentals of Rust. One consequence of this however is that this probably forced my application into some design decisions that wouldn't have normally been made.

The first thing I learned early on is that the *time* module in the standard library is really quite limited compared to the time modules I am used to from other languages. My application needed to record a particular time and date, to calculate the amount of time between recorded entries, and to display a human friendly time/date stamp. Technically speaking, the time module is able to perform these first two needs using the `now()` method for the `SystemTime` struct. It produces something like the following output: 

`SystemTime { tv_sec: 1550682172, tv_nsec: 352247776 }`

What's going on here is the `now()` method outputs a `Result<Duration, SystemTimeError>` type, and since there isn't an error, there is a match to a `Duration` type that has the data available as seconds and nanoseconds. Since I'm only interested in the seconds value, the `SystemTime` struct is somewhat cumbersome to work with. Furthermore the *time* module has nothing to work with for my requirement that there is a human friendly date/time value.

Luckily there was no need to have to invent a calendar system from scratch. The terminal's command line interface can be accessed from the *process* module. So `date` can be accessed for a human readable date/time stamp, and then for calculations `date +%s` retrieves the Unix time value in milliseconds. In both instances what you get back from standard output are ASCII decimal values, so those need to be converted into a `char` type. This can be done while looping through the received data, and pushing to a mutable string with `*c as char`. The `*` dereferences the value so that it can be recast as a `char` type.

The other challenges working in Rust involved handling strings, the borrow checker, and coercing string types to integer types. 

Strings are relatively complicated in Rust because of the borrow checker rules. There are actually two types of strings, the `str` type that is a part of the core library, and the `String` type from the standard library. `str` is a primitive that are called *string slices* or *string literals*, and are typically used as borrowed references. For example, when you type `let hello= "Hello world";` you have created a borrowed string literal.

`String` on the other hand is a data type that takes ownership over the contents of a string. `String` is able to dereference to a `str`, so it can inherit all the methods available to `str`, but it has additional methods that are not available to `str`. Some of the more notable methods are `push()` and `push_str()`. This is a useful clue about which string type you should use. Generally speaking, if you need a mutable value that can be manipulated, use `String`, otherwise use `str`.

The borrow checker is also a source of confusion for people new to Rust. One of the unique features of Rust is it neither uses a garbage collector, nor does it explicitly allocate and free memory. Instead Rust has ownership rules about data management. The rules are as follows:

1. Each value in Rust has a variable that is the owner
2. There can only be one owner at a time
3. When the owner goes out of scope, the value is dropped

The borrow checker is a feature of Rust's compiler that enforces these ownership rules. If you write any code that violates these rules, the compiler will complain, and you'll have to fix things. Luckily, although these are novel constraints to keep in mind while programming, in practice it is pretty easy to get a handle on things. Most of the time all it takes to comply with the rules is to use referenced values as much as possible. Another aspect that mitigates the learning curve for dealing with the borrow checker is the compiler is very good about providing hints about what you need to do to fix your code. Most of the time, the suggestion made by the compiler is exactly what you should do. Rust's compiler is really, really nice.

The one place where I found the compiler less helpful is when I experienced a *ParseIntError*. I ran into this issue when trying to take a value from the csv file, and convert it into a float to perform some calculations. I ran into this issue because of an error that had to do with incorrect csv formatting, but it was difficult for me to debug because of how opaque the error message was. This does point to a larger difficulty with Rust for beginners where there are many ways you potentially could coerce from one data type to another, but I get the impression there basically is usually a correct way to do this, but figuring out what the particular pattern is non-obvious.

Having listed my main complaints with my initial development experience in Rust, I'd like to now discuss the many aspects I really appreciated.

### Static Typing

I've played around with some languages like Java, C++, and TypeScript that are statically typed, but this was my first real development experience with one. Although I was complaining earlier about how opaque I found the *ParseIntError* from the compiler, the reality is that figuring out this error in a dynamically typed language would have almost certainly been more difficult to discover. Another benefit is that static typing forced me to think more clearly about what I was trying to do. At the same time, I appreciate that the compiler is often able to intuit what type you are assigning, and so Rust is able to avoid the verbosity that people find off-putting with Java.

### No `Null` Type

Rust doesn't have `Null`, `None`, `nil`, etc. Anyone that has spent enough time developing knows what a headache these types of errors cause. Instead Rust uses the `Option` enum that has `Some` or `None` variants. This provides a much smoother development experience that results in easier to understand code, and more predictable program behavior.

### Excellent Error Handling

I really like how error handling works in Rust. When you want to return a value that you anticipate might have an error, you will write a function that returns a `Result` type. `Result` is an enum where the variants are either the expected data type, or else an error that you handle. To sweeten the deal, you can also use the `?` operator at the end of statements to pass along error propogation to where it needs to go. While prototyping and doing rapid development, it is common to use the `unwrap()` method that belongs to the `Enum` type (`Result` is a built in type of `Enum`). It unwraps the Enum and returns the content of an `Ok`. The problem with this is that it doesn't handle errors, so the `unwrap()` method is a common cause of panics. However thanks to how `?` operator works, Rust developers have powerful tools to replace `unwrap()` with proper error handling.

Between `Result` and `panic!` macros, you have a lot of control over how your program should respond to anticipated errors.

### Pattern Matching

Rust has some of the nicest pattern matching syntax I've seen in any language, and it is probably the one thing I will miss most when I do work in other languages. As a simple example, in my program I need to read a file. However it is possible that file does not exist, in which case it needs to create the header for a new file. Pattern matching can do this in a few lines of code:

```
let file = match contents {
    Ok(x) => x,
    _ => String::from("action, date/time stamp, unix time, hours\n"),
};
```

What's going on here is we have a variable called `contents` of the `Result` type. So that means it has two variants, `Ok` or `Err`. If it is `Ok` it will have a value wrapped up in it, so our match statement says to return that value if it encounters that pattern. Otherwise we have the `_` expression, which is a wildcard character. The wildcard serves the same sort of purpose as else in an if-else statement. It's there to handle any other possibility that might come up. To write a valid match statement you have to account for every possibility. So in this case, the wildcard pattern match occurs for a file not found, in which case it produces the string header instead.

For such a simple case you could certainly handle this with an if-else statement, but the nice thing about the match expression is it can handle much more complex cases with lots of potential variants, and also it has nicer syntax that is easier to understand.

## Summary

I think Rust is a really wonderful language. I anticipate that as I get more comfortable with it the problems I experienced will go away, and the things I enjoy about the language will magnify. It might not be my first pick for what to work in for a lot of tasks, but I definitely plan to continue to use it. Rust makes it easier to do ambitious work, and so whatever challenges you might face are always rewarded.

---
layout: post
title: "Lifetimes in Rust"
date: 2020-01-20
---
In Rust, every reference has what is called a *lifetime*. A lifetime is the period during which the reference is valid. Like in most programming languages, that is going to be the scope where the reference is assigned.

```
let x = 5;

fn foo() {
    let y = 10;
    println!("{}", x);
    println!("{}", y);
}

println!("{}", x);
println!("{}", y); // This will raise an error because y does not exist in this scope
```

Here, `y` is defined in the `foo` function, and so it goes away whenever the function completes its call, so the global space has no knowledge of the `y` assignment. (Side note that there is another problem with the section of code, but that has to do with using closures in Rust, which is outside the scope of this blog post).

So far so good. Mostly, lifetimes are the sort of thing you don't have to think about any more carefully than in any other programming language. *Mostly*. That is to say, there are cases where you do have to think about them a little more. 

In situations where a function is written where the compiler cannot know in advance how long it needs a reference to be valid it will be necessary to explicitly annotate the lifetime of the references contained in that function. The simplest example is a function with an `if`/`else` branch.

```
fn return_greater<'a>(x: &'a i32, y: &'a i32) -> &'a i32 {
    if x > y {
        x
    } else {
        y
    }
}
```

If `x` is greater than `y` then the references to either don't need to stick around for the `else` block because the function doesn't need to execute that block. However in cases where `y` is greater than `x` we do need to at least hold onto the `y` reference at that point so it can be returned. The compiler cannot know when it needs to hold onto that reference, and when it is okay to drop itsince the function accepts any valid pair of references to signed 32-bit integers. It's the entire point of the function.

To address this, we annotate the lifetime, and state that the parameters should exist for the duration of that lifetime. The `'` syntax is used for declaring a lifetime. It is idiomatic in Rust to write `'a` for annotated lifetimes. I have no idea why, but you can think of the `a` as short for annotated. So at the start of the function `<'a>` is written. That is a lifetime that refers to the the length of the function scope. Then any parameter reference `&'a` means that that reference should exist at least as long as the function scope. Our function now works. Also note how you only need to use the lifetime syntax within the function signature, not the body.

One other case where lifetime annotations come up is in declaring structs. In addition to having owned data types, structs can also hold references, and in those cases it will need to be annotated. This most commonly comes up with references to string slices. 

Lets say we are creating a computer roleplaying game. There are a lot of different types of systems at play, but the one we are interested in implementing is the text block. The text block doesn't do anything too fancy, it just displays some text to the player, has some metadata associated with it, and has a selection of choices (which are themselves another struct) the player can select to proceed with the story. We can write something like this:

```
struct TextBlock<'a> {
    id: u32,
    text: &'a str,
    choices: Vec<Choice<'a>>
}
```

Note how our choice struct, which isn't defined here, but we can imagine also has an annotated lifetime for its own string slice references. When we include that struct in the `TextBlock` struct, it too needs to include its annotated lifetime which means that the referenced string slices for `Choice` structs need to last at least as long as the scope of a `TextBlock` struct. Our `Choice` struct lives instead a vector, and so our syntax of `Vec<Choice<'a>>` is nearly morphing into the infamous [turbofish](https://turbo.fish)!

When you are first learning Rust looking at other people's code can be intimidating because any syntax that is unique to Rust increases the cognitive load. Luckily lifetime annotations are a relatively straightforward concept so knowing how they work is an important piece of the Rust code puzzle.

---
layout: post
title: "Keyed Collections in Javascript: Maps and Sets"
date: 2018-05-31
---

When you are first learning Javascript, the built in objects you typically learn about are objects and arrays, and that's pretty much it. That isn't surprising when you consider the development history of the language, which was rushed into existence due to market pressures. Pre-ECMAScript2015 JS was feature sparse relative to other programming languages. When you see older developers talk about Javascript as a "toy language", they are probably thinking of earlier versions. And if you were only allowed to have two default objects to contain data at your disposal, arrays and objects are reasonable and excellent choices. It is incredibly useful to Look things up either via index or key-value pairs.

When I started learning languages like Python and Rust I encountered a wide variety of other data structures besides objects and arrays. There's tuples, structs, vectors, heaps, etc. Most of the time, if you want to use data structures like these in Javascript you will have to find a library or module to install to extend Javascript, or else write it yourself. However in the post-ES2015 world there are a lot of under-utilized features in Javascript. When I looked over Mozilla's <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects">documentation for built-in objects</a> I saw two data structures that I don't see discussed particularly often: maps and sets.

Maps and sets are what are referred to as *keyed collections*: a collection of elements that contain key-value pairings, and based on the order of insertion it is possible to iterate through the collection. They are kind of like the best of both worlds of objects and arrays, but because the built-in methods are narrower they serve more specialized purposes. One unique feature of keyed collections that makes them distinct from Javascript's object literals is that the keys don't have to be strings: they could be arrays, objects, numbers, or any other data type available in Javascript.

<h3>Maps</h3>

A map is a keyed collection that has key value pairs, and you can iterate through it using a `for...of` loop. This is how you declare a new map variable:

```
let map = new Map();
```

There are a number of useful methods available for Map, but I think arguably the three most important ones are `set`, `get`, and `has`. `set` is used to place key-value pairs into the map object. `get` is used to retrieve a map value using the key as its argument. Finally, `has` can be used to check if a map has a particular stored value using the key as its argument, returning a Boolean.

```
let locations = new Map();
locations.set('San Francisco', 'CA');
locations.get('San Francisco'); // CA
locations.has('San Francisco'); // true
```

It is true that for a simple example like this you could use an object literal for the same goal. But the advantage of using a map object is that you could introduce more complex and diverse forms of data without sacrificing the simplicity of the map syntax. For instance, you could have arrays containing longitudinal and latitudinal coordinates as keys that identify locations.

<h3>Sets</h3>

Sets store values of any type, however they will not store non-unique values.

```
let set1 = new Set([1, 2, 3, 4, 5, 5, 5]);
console.log(set1); // Set { 1, 2, 3, 4, 5 }
```

Maps and sets share the keyword `has`. You can also add entries to a set using the `add` method. Sets are useful when you aren't concerned with the number of instances of a value, you just want to know if that value is present or not within a set.

You are less likely to use maps and sets for a lot of work you might perform using Javascript. But when these data types are a natural fit for a task you are working on, they will save you a lot of time, and make your code easier to understand.

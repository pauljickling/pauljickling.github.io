---
layout: post
title: "Keyed Collections in Javascript: Maps and Sets"
date: 2018-05-31
---

When you are first learning Javascript the built in objects you typically learn about are objects and arrays, and that's pretty much it. Considering the development history of Javascript, that isn't surprising. Pre-ECMAScript2015 JS was feature sparse relative to other programming languages. And if you were only allowed to have two default objects to contain data at your disposal, arrays and objects are reasonable and excellent choices. Looking things up either via index or key-value pairs are incredibly useful.

When I started to study other languages like Python and Rust I encountered a wide variety of other data structures besides objects and arrays. There's tuples, structs, vectors, heaps, etc. Most of the time, if you want to use data structures like these in Javascript you will have to find a library or module to install to extend Javascript, or else write it yourself. However in the post-ES2015 world there are a lot of under-utilized features in Javascript. When I looked over Mozilla's <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects">documentation for built-in objects</a> I saw two data structures that I don't see discussed particularly often: maps and sets.

Maps and sets are what are referred to as *keyed collections*: a collection of elements that contain key-value pairings, and based on the order of insertion it is possible to iterate through the collection. They are kind of like the best of both worlds of objects and arrays, but because the built-in methods are narrower they serve more specialized purposes. One unique feature of keyed collections that makes them distinct from ordinary Javascript objects is the keys don't have to be strings: they could be arrays, objects, numbers, or any other type of data available in Javascript.

<h3>Maps</h3>

So a map is a keyed collection that has key value pairs, and you can iterate through it using a for...of loop. You can declare a new map like this:

```
let map = new Map();
```

There are a number of useful methods available for Map, but I think arguably the three most important ones are `set`, `get`, and `has`. `set` is used to place key-value pairs into the map object. `get` is used to retrieve a map value using the key as its argument. Finally, `has` can be used to check if a map has a value stored in it using the key as its argument, and returns a Boolean.

```
let locations = new Map();
locations.set('San Francisco', 'CA');
locations.get('San Francisco'); // CA
locations.has('San Francisco'); // true
```

It is true that for a simple example like this you could use an object literal for the same goal. But the advantage of maps are you could introduce more complex and/or diverse forms of data without sacrificing the simplicity of the map syntax. For example, you could have arrays containing longitudinal and latitudinal coordinates as keys that identify locations.

<h3>Sets</h3>

Sets are stores of value of any type. The important thing to remember is that they will not store non-unique values.

```
let set1 = new Set([1, 2, 3, 4, 5, 5, 5]);
console.log(set1); // Set { 1, 2, 3, 4, 5 }
```

Maps and sets share the keyword `has`. You can also add entries to a set using the `add` method. Sets are useful when you aren't concerned with the number of instances of a value, you just want to know if that value is present or not within a set.

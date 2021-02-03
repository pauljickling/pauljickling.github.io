---
layout: post
title: "Gatsby Gotchas"
date: 2021-01-21
---

Last year I shifted roles from working on front-end development to DevOps. One of the last projects I worked on while doing front-end development used Gatsby. Gatsby tries to reduce the amount of data overhead that you would normally experience using React with Server Side Rendering. It also plays nice with JAM stack services like Netlify, so it is a pretty popular solution for frontend web development.

Gatsby has a lot of documentation, although it can be a bit difficult to navigate all of it, so it is easy to miss a couple of important details that are useful for someone starting out, so I thought I would list them here.

## Pages and Components Work Differently

In React, everything is basically a component, and you build out components on top of each other until you have a component that is your webpage. In Gatsby you are still composing components in JSX the same way you would in React, but your project will have a pages directory, and a component directory, and Gatsby treats these as separate things that it handles. This is important because the way you do things like make graphQL queries will vary depending on whether it is a page or a component, one requires the `useStaticQuery` module, and the other is declared with the expression `export const query`.

## Image Plugins Must Be Declared at the Top of the Config Array

One of the big selling points for developer quality of life are the Gatsby image plugins that will automatically compress images so you aren't sending unnecessary data to the client. However for these to work correctly you need to include them at the beginning of the config array. I have no idea why.

## `document` and `window` Objects Can Have Unexpected Behavior in Production

If you need to use the `document` or `window` objects in Gatsby you will need to pay close attention to them. They will work as you expect when you run the `gatsby develop` command, and examine your web application in localhost. However if you then run `gatsby build` these objects will break. This is because during `gatsby develop` Gatsby creates a web server where these objects are available, but this is not the case during `gatsby build`. This is one of the quirks of the server side rendering solution. You can work around this limitation however by making sure to use conditional rendering for these objects.

## You Can Concatenate Your CSS Classnames with String Interpolation

This isn't Gatsby specific, but the Gatsby tutorial does push developers towards CSS solutions like CSS modules, and CSS-in-JS, so I figured I would mention this tip as well. You can give yourself a lot of flexibility and control over how you style components by concatenating the classnames with string interpolation. The syntax will look something like:

`<div className={`${css.foo} ${backgroundClass}`}>`

Then you can define these values elsewhere so your css classes can change based on the state of your app. This is a very powerful technique!

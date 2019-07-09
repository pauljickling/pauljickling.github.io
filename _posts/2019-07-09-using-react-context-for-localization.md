---
layout: post
title: "Using React Context for Localization"
date: 2019-07-09
---

Localization is an enormous undertaking for any organization. There are many different considerations that go along with a localization task that are beyond the scope of this post. I just want to talk about the task of providing text on a website in different languages.

React famously has a "top-down"/"unidirectional" flow of data. Parent components pass down props to their children component, and not vice versa. That means that developers working in React must contend with a tree-structure for their data. Personally, I would love a web framework that had data ownership rules inspired by Rust's borrow checker, but for now the React approach to maintaining a single source of truth for data is a reasonable solution.

Where this gets tricky however is when you are in a situation where you have data that is used by nearly every component in your application. In those instances, you will want to use React's Context API. Localization is a good candidate for using the Context API. You will typically have some component that controls the language of the app nested in the tree of components somewhere.

To use the context API, you will need to create a context object. I like to keep this in a separate file.

```
import React from 'react';

export const languageContext = React.createContext();
```

You can also pass a default context value in the parameter if you'd like. So you might pass an object with a language attribute, and a function that toggles the language, for example.

```
{
  language: "EN",
  toggleLanguage: () => { // your function here },
}
```

For a component to use the Context API you have to declare the context it is using, and then use the `.Consumer` or `.Provider` methods as is appropriate. Lets say we have a LanguageSelector component. It can use our context by writing `LanguageSelector.contextType = LanguageContext;`

A Context Consumer receives context information, and a Provider provides the context that our consumers would use. However, this is where things get confusing, the Provider in this case is going to be our highest level component, and the LanguageSelector component is going to be a Consumer. Huh? This is because we're still operating in the world of React's one way data flow. This is why it can be helpful to provide an object as a default context value that contains a function that helps manage the context. That way, our nested LanguageSelector component can consume the `toggleLanguage` method, which updates the context for our App component (or whatever is your root component), which is the actual Context Provider for all the other components that are Context Consumers. Lets take a look at what that looks like. Our LanguageSelector component will render something like this:

```
<LanguageContext.Consumer>
{({language, toggleLanguage}) => (
  <button onClick={toggleLanguage}>
    Toggle Language
  </button>
)}
</LanguageContext.Consumer>
```

As you can see, the syntax for this is an annoying combo of curly braces, parenthesis, and additional curly braces. It's your initial JSX curly braces utilizing JavaScript, followed by a function that takes your context object as it's parameter, returning the JSX expression. What we're interested in of course is just utilizing the context's `toggleLanguage` method.

Now that we have a component that is consuming the `toggleLanguage` method it is time to set up the Provider Context in the root component. In this instance we can encapsulate the entirety of what is rendered in the following:

```
<LanguageContext.Provider value = {this.state}>
...
</LanguageContext.Provider>
```

After defining the state to be associated with the language properties of our context, we can now pass that information along our component tree as ordinary props.

Components that need to render text can then utilize some sort of `getText` method.

```
getText = () => {
  if (this.props.language === "EN") {
    return <p>{English}</p>;
} else {
    return <p>{Spanish}</p>
  }
}
```

Where {English} and {Spanish} are variables that hold the text you are using to localize your components.

There are a couple of different ways to handle localization, but I found this technique avoids adding unnecessary complexity to your codebase.

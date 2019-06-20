---
layout: post
title: "JS Implementation of a Sticky Footer"
date: 2019-06-20
---

Suppose we want a footer at the bottom of a page. It's a common enough requirement for most web pages. You typically might include various legal documents, and other information that a regular user isn't normally going to consult, and therefore doesn't belong in the navbar, but is still important to provide. Our footer component will have the following rules in CSS:

```
.footer {
  position: absolute;
  bottom: 0;
}
```

All of the content in `.footer` now lives at the bottom of our browser window. This is simple, but creates a new problem. What if we have more than a window's worth of content on the screen? Our footer will now occupy the same space as some of the content. Bad! What we really want is a *sticky footer*. That is, a footer that will stick to the bottom of the page, unless there is a page or more worth of content, in which case it will behave normally.

[Chris Coyer goes through a history of CSS solutions for this problem](https://css-tricks.com/couple-takes-sticky-footer/). If I were starting a project from scratch, I would probably use the flexbox solution. It's nice and simple, and it uses CSS that should be supported by nearly every browser. For reference, here's the code:

```
html, body {
  height: 100%;
}
body {
  display: flex;
  flex-direction: column;
}
.content {
  flex: 1 0 auto;
}
.footer {
  flex-shrink: 0;
}
```

However what happens when you need to implement this component in an existing codebase with some other way of defining the layout? If you're like me, you are terrified of the idea of going around and messing with "global" variables like `html` and `body`. Who knows what sort of side effects that might have? The odds of going down crazy rabbit holes trying to fix unanticipated behavior sound high and not fun.

When we don't have a great way to handle problems with pure CSS, we can always use JavaScript. I was dealing with this problem for a site that uses React and TypeScript. The footer component had the following code:

```
public componentDidMount() {
  this.setState({
    anchored: this.absolutelyPosition,
  });
}

...

private get absolutelyPosition() {
  const bodyHeight = document.body.clientHeight;
  const viewportHeight = window.innerHeight;
  return bodyHeight < viewportHeight;
}
```

So we have the `absolutelyPosition` method that calculates the document and viewport height, and returns a boolean depending on if the body height is less than the viewport height. The `anchored` state is set to this boolean. What does `anchored` do? It does this:

```
const elementClasses = classNames(
  this.elementClass,
  this.props.className, {
    [`${this.elementClass}--anchored`]: this.state.anchored,
   }
);
```

Every component has some associated class names that are determined by props and other factors. In this case we have a rule that says if the `anchored` state is true we attach the phrase `--anchored` to our class name. So our CSS can now look something like this:

```
.footer--anchored {
  position: absolute;
  bottom: 0;
}
```

So now we have a footer that may or may not have an `--anchored` class name attached to it depending on the viewport height and the height of the content for the page. In cases where the amount of content of the body of the page is less than the viewport height it has absolute positioning and sticks to the bottom of the page. But in instances where that isn't true it just behaves as a normal element.

So we're done, right? Not quite. The problem I had with this code is it makes the assumption that our body height is a fixed size. But mobile displays can be turned, and in a desktop environment users might be resizing the their browser window for reasons. In that event the user is in for a nasty surprise with an out of flow footer.

So we need to add an event listener to pay attention to when the resize happens.

```
public componentDidMount() {
  window.addEventListener('resize', this.handleResize);
  this.setState({
    anchored: this.absolutelyPosition,
  });
}

private handleResize = () => {
  let bodyHeight = document.body.clientHeight;
  let viewportHeight = window.innerHeight;
  if (bodyHeight < viewportHeight) {
    this.setState({
      anchored: true,
    });
  } else {
    this.setState({
      anchored: false,
    });
  }
}
```

Now we have an event handler, `handleResize` that fires off anytime a window resize happens. It recalculates the body and viewport height and sets state accordingly. Our footer now behaves properly, and doesn't get in the way of page content, while sticking to the bottom when there is room for it.

---
layout: post
title: "Static Asset Management in React"
date: 2019-08-30 
---

React really wants you to import static assets like png and jpg files so that it is part of a minified Webpack bundle that reduces the number of server requests made. Here is how it works in [create-react-app](https://create-react-app.dev/docs/adding-images-fonts-and-files).

Crucially, this means if you have an image tag in your JSX and provide a path the way you would in a regular HTML file, it won't be able to find the file you are looking for. In my experience, this is a real source of confusion for people new to React.

Here is the example given in the create-react-page documentation on how to import an image:

```
import React from 'react';
import logo from './logo.png'; // Tell Webpack this JS file uses this image

console.log(logo); // /logo.84287d09.png

function Header() {
  // Import result is the URL of your image
  return <img src={logo} alt="Logo" />;
}

export default Header;
```

Ok cool, we now have a logo that displays on our React page. We can repeat this process if we want to add a few more pictures too. But what happens if we have a component that needs access to hundreds of pictures? Do we really want to fill up the component with hundreds of lines of import statements? That sounds prtty annoying. If you are a Vim user, this potentially gets even worse because there is a good chance you are using some plugins to highlight your JSX that do not play well with code folding features.

One solution might be to futz around with your Webpack settings. Personally, I treat that as an option of last resort because it really is not the sort of thing I really enjoy doing.

Another solution however is to have a dedicated static assets JavaScript file that any of your React components utilize. Here is what that `assets.js` looks like:

```
import cat from './assets/cat.png'; 
import dog from './assets/dog.png';
import pizza from './assets/pizza.png';

export default {
  cat,
  dog,
  pizza,
};
```

Then your component can use these assets this way:

```
import React from 'react';

/* Static Assets */
import assets from './assets';

. . .

return (
  <div className="picture-grid">
    <img src={assets.dog} alt="a cute dog" />
    <img src={assets.cat} alt="a cat tightly squeezed into a box" />
    <img src={assets.pizza} alt="a delicious looking New York slice" />
  </div>
);
```

Now you have a simple way to load as many images as your heart desires without fiddling around with your configuration, and potentially losing some of the benefits you gain by using React.

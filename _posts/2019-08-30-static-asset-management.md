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

Another solution however is to have a dedicated static assets JavaScript file that any of your React components utilize. Here is what that `images.js` looks like:

```
import cat from './images/cat.png'; 
import dog from './images/dog.png';
import pizza from './images/pizza.png';

export default {
  cat,
  dog,
  pizza,
};
```

Then your component can use these images this way:

```
import React from 'react';

/* Static Assets */
import images from './images';

. . .

return (
  <div className="picture-grid">
    <img src={images.dog} alt="a cute dog" />
    <img src={images.cat} alt="a cat tightly squeezed into a box" />
    <img src={images.pizza} alt="a delicious looking New York slice" />
  </div>
);
```

Now you have a simple way to load as many images as your heart desires without fiddling around with your configuration, and potentially losing some of the benefits you gain by using React. However we can do even better. We can automate away manually writing our `images.js` file with a bash script.

```
#!/bin/bash
# Updates the images.js file
if [ -f "images.js"]; then rm images.js; fi
echo "Writing directory images to file"
for file in images/*
do
    len=$((${#file} - 4))
    echo import ${file:7:$(($len - 7))} from \'$file\'\; >> images.js
done
echo "" >> images.js
echo export default { >> images.js
for file in images/*
do
    len$((${#file} - 4))
    echo " ${file:7:$(($len - 7))}," >> images.js
done
echo }\; >> images.js
exit 0
```

Lets break this down for everyone that isn't fluent in Bash-ese (that basically includes me, I'm very new to writing Bash scripts).

Bash scripts always begin with the line `#!/bin/bash`. HTML has the equivalent starting line of `<!DOCTYPE html>` that verifies that this is, in fact, an HTML file. Like Python, comments in Bash begin with a `#`.

`if` statements in Bash have an unusual syntax compared to what you are probably used to. They are closed out with `fi`. What does `fi` mean? Is it a backwards `if`? Short for fin? I have no idea, but that's the syntax. Each statement of the if branch is terminated with a semi-colon. In this instance we are using a `-f` flag that checks for a particular file, and if it is there, it removes the file since the script will rewrite it from scratch.

`echo` is a print statement. By default it prints to your terminal's standard output, but as we will soon see, it can also be directed elsewhere.

We want to loop through the entire image directory and write these files to a new `images.js` file. Bash loops look somewhat similar to Ruby loops. The statement `for file in images/*` will look through all of the images directory (the `*` is a wild card), and assign it to the variable file. Speaking of variables, we assign those with the equal signs, and no spaces. We then can use those variables with the `$` character. So if we write `hi="hello"` and `echo $hi` our terminal will output hello.

In this script we have a pretty funny looking variable called `len`. The first thing you need to know is that you can write mathematical expressions using `$(())` as your syntax. So `echo $((2 + 2))` will print 4. The next thing you need to know is that the `${#file}` is a length method for our variable. So whatever the string length is, our `len` variable will be that number minus four. Why do we need this variable? Well, it is because we are trying to write a substring of our file variable that does not include the path or the file extension. For certain versions of Bash this would be straight forward because you would write your substring the same way that you write them in Python, where you could cut off the end of the string with a negative number. However older versions of Bash don't support this, and the MacOS version of Bash is one of those. So instead we need to calculate the length to figure out what we need.

You will also note in our substring that in addition to the length calculation we are subtracting the length by 7. This has to do with the starting position of our substring. In other words, our length value isn't appropriate for our substring anymore.

You will also notice the `\` escape characters in our `echo` statement so that the subsequent characters get rendered instead of operating on the statement. Finally note the end of the line `>> images.js`. `>` is used in the terminal to write to a file. So `echo hello world > hello.txt` will write a file called `hello.txt` with the contents `hello world`. Using the double arrows `>>` means you write to the new line of a file. So if we have a `hello.txt` file with the contents `hello world` if we write `echo hello world >> hello.txt` our `hello.txt` file will contain:
```
hello world
hello world
```

Once we have our import statement, we repeat the process for our exports. Finally we end the script with `exit 0` which indicates a successful exit. Now all we have to do is run this bash script and it will write every file in our `images` dirctory into our `images.js` file.

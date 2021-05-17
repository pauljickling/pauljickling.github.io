---
layout: post
title: "Editing Made Easy with Vim"
date: 2021-05-17
---

Thanks to the shift to DevOps practices in deploying code, people are spending a lot more time these days editing yaml files that are used to configure their CI/CD pipeline. Most people I know don't love yaml-- for new users there are lots of weird ways to shoot yourself in the foot when trying to include string data, and getting the correct indentation/spacing can sometimes be tricky. However it has several useful features that are unavailable in a more rigid data format like JSON such as being able to leave comments, or assign variables, and this makes it a more useful format for a lot of configuration tasks. Regardless of how you feel about yaml, it will probably be with us for some time as alternatives like toml tend to be fairly similiar in their approach.

An editor like Vim, or VSCode with some Vim-like features enabled, can make the editing and maintenance of yaml configuration files much easier. Imagine you have a large yaml file, and some feature of a collection is being removed. You might have some config file that looks like this:

```
    - video: path/to/file.mp4
      image: path/to/file.webp
      text: lorem ipsum...
```

You could have thousands of entries like this. But suddenly the spec has changed, your not using video anymore, you can get rid of that. Great, you definitely want to do that because your pipeline is using this config file to determine what static assets it needs to buindle together for the build, so removing all those video files will cut down your build time, making all your developers happy. 

So you use vim's sed features to delete the lines that begin with `- video:`, and you also remove any lines that are just white space. You also do a search and replace for images, which are now the first part of these collections with `%s/image:/- image/g`. Great, but now there is one problem. The indentation for image is off, so your config file won't work. Manually fixing that would suck. Luckily Vim also has the global command so you can find patterns, and execute globally on that line.

`:g/- image:/<`

Vim looks for every line with the `- image:` pattern, and executes the `<` command, which sets the indentation back one as specified by your vimrc file. You now have a valid yaml configuration file that meets the new specifications, and get to move on with your day. Yay!

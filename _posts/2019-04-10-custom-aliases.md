---
layout: post
title: "Custom Aliases"
date: 2019-04-10
---

There are a lot of blog posts out there about writing aliases as shortcuts for various git commands. That's great, and totally something you should do. But I wanted to also list some other aliases I've found useful.

`alias py='python3.6'`

If you do a lot of work in Python, the odds are great that you have a bunch of versions of Python on your machine. Having to specify the version you're using is a pain, so an alias is a great way to handle that. Relatedly,

`alias activate='source env/bin/activate'`

I am terrible at remembering any directory path I didn't create myself, so this is another essential alias for me to simplify entering into a virtualenv. In general, I create a lot of aliases for reading files or going to paths in directories I didn't create. Lets say something doesn't seem to be working in Ubuntu, I'll probably want to check the log on that:

`alias log='vim /var/log/kern.log'`

Because there is no way I am going to remember that something is in the `var/` directory, much less the rest of the path. Speaking of Vim, since I often work with a lot of tabs open I can end up with a lot of unneeded swap files located in some obscure directory where they spend their days sending me annoying prompts when I try to open up a file I'm working on. I take great pleasure in using this alias:

`alias killswap='rm -rf $HOME/.local/share/nvim/swap/'`

As for anytime I need to write more aliases, that means I need to access my `.bashrc` file, so of course I have an alias for that too:

`alias config='vim $HOME/.bashrc'`

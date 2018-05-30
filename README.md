Jekyll notes:

Markdown file names for blog posts must be formatted this way:

YYYY-MM-DD-Title-With-Dashes.markdown

Every entry begins with this header:

```
---
layout: post
title:  title in quotes here
date:   YYYY-MM-DD
categories: tags separated by spaces
---
```

Markdown files accept HTML tags and markdown syntax. For more details see https://jekyllrb.com/docs/posts/

There is additional documentation on markdown syntax available here: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

A quick summary of the directory structure:

* \_includes contains the head HTML code in head.html and the navbar in header.html that is included in every page
* \_layouts contains default page types that are selected in the markdown header
* \_posts contain the blog posts
* \_sass contains the default sass file included with Jekyll
* assets contains the CSS file as well as images and any other static files that might need to be served
* sites contains stand-alone HTML files such as CSS experiments and demos that do not follow the conventions and designs of the rest of the site
* the root directory contains the \_config.yml file that provides Jekyll build instructions, along with various markdown files for non-blog posts, gemfiles, and the .gitignore file.

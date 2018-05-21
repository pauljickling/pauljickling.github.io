---
layout: post
title:  "Interview with David Jickling Evaluation"
date:   2017-04-02
categories: xml css
---

This was an exercise in making a document more readable relying completely on CSS to manipulate the display (aside from inserting a CSS link of course). The CSS file consists of three parts: manipulations to the entire document, manipulations to XML data that we want to ignore, and manipulations to the `<hi>` tag.

The entire document
-------------------

Surprisingly the default display setting of XML data is inline. Setting the display to block is probably the single most important change made to make the document more readable.

The margin is set to 0 auto to center the document.

Some padding is added, and line-height set to 1.5 to improve readability.

Font size is set to 1.1em so it should appear nice and large no matter what display a person is using. In general, I'm a big proponent of the idea that in general people should be using larger font sizes on the web! There have been plenty of studies demonstrating that people are more likely to finish a book with larger print. I believe people shy away from larger fonts because of an association with larger fonts being for children, but it actually improves the reading experience for everyone.

Finally a max-width is set so there aren't too many characters displayed per line on wider screens.

Note that because of all these rules are defined globally, there isn't any actual need to write any rules for the `<p>` tag.
Hidden tags

The XML file has a lot of useful data about the document, but not data that is necessarily useful to most readers. We set the display to none so that the beginning of the document isn't clogged with extraneous data, but for those curious they can still consult the data by examining the XML file.

The hi tag
----------

The `<hi>` tag was used in this XML document to indicate the interviewer's questions.

I decided to add some background color to the interview to distinguish the questions being asked. This is the sort of thing you need to be careful about. The best backgrounds are either black text on a white background or vice versa. Once you start messing with different color text and backgrounds you risk making your document less accessible because low contrast fonts and backgrounds are more difficult to read. I consult the A11Y Style Guide when making decisions about accessible design. According to [their section on color](http://a11y-style-guide.com/style-guide/section-general.html#kssref-general-colors) they recommend a minimum contrast ratio of 4:5:1, and preferably 7:1. Luckily [there are tools available](https://leaverou.github.io/contrast-ratio/) for checking out what your contrast ratio is. As you can see, the sky blue color I selected passes the test. The text is also italicized to help distinguish it.

The final adjustment to the `<hi>` tag is the negative left margin value. Normally I shy away from using negative margins, but this is one instance where it proves useful. A typical sample of the XML looks like this:


             <p>
             <hi rend="italics">Q: So after graduate school where did you go?</hi>



             </p>


             <p>JICKLING: I taught for a few years because I wanted to follow
             the academic road, but after two or three years I decided I really
             couldn't teach about government and public administration unless I did
             it, so I came to Washington as a junior officer in the Navy Department.</p>


Note that the `<hi>` tag is embedded inside of a `<p>` tag. Every `<hi>` tag ends up appearing indented in the document because of the global rule that every tag is displayed as a block, so that `<p>` tag ends up indenting all the `<hi>` tags. This looks unusual. A more standard interview format would be for the questions and the answers to have the same amount of indentation, or else for the responses to be slightly indented.

Any adjustment to the `<p>` tag would necessarily affect the `<hi>` tag, this is why negative margins prove to be useful in this instance. The use of negative margins creates the desired effect where the responses appear indented relative to the questions.

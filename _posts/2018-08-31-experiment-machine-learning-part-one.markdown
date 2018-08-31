---
layout: post
title: "An Experiment Using Machine Learning, Part 1"
date: 2018-08-31
---

I recently decided it would be fun to start learning about machine learning. And what better way to learn something new than to try and conduct your own experiment?

## The Experiment

I decided to go back to my roots as an English major, and see if machine learning can shed any light into the theory about whether Francis Bacon was the author of Shakespeare's plays. And in the interest of transparency, I should say that I've always felt that this theory is elitist nonsense, akin to the people that argued Frederick Douglass could not have been the author of his autobiography because no black man could have commanded such erudition and persuasive rhetoric. So I'll be rooting for the results casting further doubts on this theory, but it goes without saying that I'll be trying my best to formulate the experiment in a way that my own bias does not affect the experiment.

It is also worth mentioning that this will be a statistical analysis, and therefore the results won't be conclusive.

With that in mind, here are some initial questions.

- Can a methodology be developed that analyzes language patterns to make a reasonable guess about the author of a piece of text? This is an important foundational question. If no such methodology can be developed, then whatever experiment I might formulate won't contain any meaningful results. My current assumption is given a large enough text sample to analyze, a reasonable guess can be made, but maybe that will prove to be incorrect.

- If our first question is cleared, can we formulate an alternative hypothesis for the results, whatever they might be? Conversely, can we undertake any additional analysis or experiments to strengthen that conclusion?

## Additional Considerations

This experiment will involve a lot of work, that's why this blog post is part 1 of many. In addition to needing to learn a lot of the relevant machine learning literature to think up how to setup and conduct my experiment, there are several other considerations that need to be addressed.

- I need to look at what Shakespearian machine learning research already exists. Has someone already tried out this experiment? I hope so! If so that saves me a lot of work, because then all I need to do is look at their results and see if I have any questions about their methodology. This specific inquiry aside, are there any other experiments that might be relevant?

- I also need to put some thought into how to gather and manage the texts that are to be analyzed. This will involve the complete works of Shakespeare, and all the books written by Sir Francis Bacon. Luckily, all this data is easily available on [Project Gutenberg](https://www.gutenberg.org/ebooks/), but even then the data will need to be scrubbed. I have to deal with prefaces not written by the author, and other extraneous texts. There are character names and stage directions that are probably not particularly relevant to the analysis, etc. Since this is a lot of content to manage, ideally I can write a script that automatically handles this, but that is all dependent on the consistency of the text itself.

- What sort of unit of data should I be examining? Words? Sentences? Presumably I should be able to find some answers in the literature on natural language annotation. The answer to this question will allow me to get a better idea of how I actually want to setup and test my experiment.

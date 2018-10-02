---
layout: post
title: "An Experiment Using Machine Learning, Part 3"
date: 2018-10-02
---

In the last blog post in this series I reviewed my research findings on other machine learning experiments regarding Shakespeare. After those findings I started to setup a repository of texts, and wrote some Python scripts to extract texts into lists of words as csv files that included word frequency. This was a somewhat difficult challenge because I discovered there are a lot of difficult edge cases to handle. I also had to start thinking about doing the same thing with sentences. After getting somewhat lost in the weeds trying to handle this, I finally did some research into existing Python libraries, and found my way to the [Natural Language Tool Kit](nltk.org). It's always nice when someone has already solved tricky problems for you and made their tools available.

I am still learning the API, but I conducted a quick experiment using the FreqDist module that can quickly generate tables of word frequencies and distributions. I decided to look at hapaxes. A hapax is a word that only occurs once within a given body of text. In one of the experiments I looked at in the last post, the authors examined the configuration of glue words to generate an authorial fingerprint. An analysis of hapaxes is essentially the opposite approach. Whereas glue words are words that everyone has to use, hapaxes represent the outermost edges of a person's vocabulary. Does a collection of hapaxes represent a meaningful authorial fingerprint? That remains to be seen, and something I plan to interrogate more. For now though, I have the following dataset:

Shared hapaxes:  1210
Shakespeare hapax list length:  13073
Bacon hapax list length:  12782
Total hapax list length:  25855

It was rather nice that the hapax list lengths for the Shakespeare works and Bacon works were roughly comparable, less than 1000 in distance! Out of a total of 25855 hapaxes, only 1210 were shared. In other words, for every 21 hapaxes examined, only one of them were shared. Therefore the unique vocabulary shared between Bacon and Shakespeare's written output is less than 5%.

There are some reality checks we will want to consider immediately. For example, what's the shared hapax ratio for works belonging to a single author? Is this ratio likely to change when we are writing in different genres? The answers to these questions might demonstrate that hapaxes are a bad measurement to be using.

Thus far I haven't performed any machine learning quite yet, this is simply statistical analysis. However the NLTK means I now have the means to start gathering and analyzing data quickly, so I should be able to setup a proper experiment soon.

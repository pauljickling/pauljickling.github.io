---
layout: post
title: "Checking for Bad Links"
date: 2019-12-29
---

A frequent problem with webpage maintenance is through no fault of your own there will be broken links. Often these don't get fixed unless a user is kind enough to notify the owner of the site.

However we don't have to rely on the kindness of our readers to address this, awe can even do so without having to do something totally boring like click the links ourselves to see if they work. We can automate this work away with a tool like Puppeteer, and some sweet bash commands.

The first step is to have Puppeteer grab all the links from the page you are looking at. If you need a refresher on using Puppeteer, [I wrote a blog post a few years back on how to do some basic scraping]({% post_url 2017-11-05-Scraping-with-Puppeteer %}).

Once you have an array with this list of links you should write it to a file. At this point you could probably also have Puppeteer check all those URLs, but in my experience, a tool like `curl` will be way faster. So we can write a bash script to manage all of that now.

```bash
#!/bin/bash
# You should include some stuff to run your Puppeteer script
echo "Checking HTTP status codes of links"
echo "status_code, url" > status_codes.csv
if [[ -e ./links ]] ; then
    while read -r i; do
        export URL="$i"
        echo "Getting status code for link $URL"
        STATUS_CODE=$(curl -sI "$URL" | awk 'FNR==1 { print $2 }')
        echo "$STATUS_CODE, $URL" >> status_codes.csv
    done < links
fi
echo "CSV file generated. You can find broken links with the following command:"
echo "grep '^404' status_codes.csv"
```

The `while` loop runs through each line of your file with the list of links, and assigns that as the variable `URL`. Note that I'm making the assumption here that your file just has a list of url names, nothing else like quotation marks, commas, or square brackets, etc. that you might have generated from using a JavaScript array.

We assign the `STATUS_CODE` variable with a curl request piped to an awk one-liner. The `-s` curl flag has it run silently so it doesn't output some information we're not interested in, and the `-I` flag just returns the HTTP header, which has all the information we're interested in.

Awk is a bit too complicated to go into detail here. The big picture idea though is that sed is used to edit lines of text, and awk is used to edit fields of data. Of course that's a huge oversimplification, but will work for our purposes. Since our curl response outputs a field of data, we can use awk to manage it. `FNR==1` tells awk just to evaluate the first row of our input, and `print $2` tells awk to print the 2nd field, which is where the status code we are interested in is located.

Finally you can find all the broken links you need with `grep '^404' status_codes.csv`. As a reminder, the `^` in a regular expression looks for the specified pattern at the beginning of the line.

You could even automate further with some tools to rewrite your code with the broken links, but that depends on the specificities of your codebase. But even the bare minimum here is a powerful way to quickly maintain your website.

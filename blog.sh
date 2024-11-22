#!/bin/bash
set -eu

# Set blog title to argument

TITLE="$1"

# Get date for blog
DATE="$(date +%Y-%m-%d)"

# Must supply title as argument to script
if [[ $# -eq 0 ]] ; then
    echo "Missing title argument"
    exit 1
fi

# Markdown header template
MARKDOWN_HEADER="---
layout: post
date: $DATE
title: \"$TITLE\"
---"

TITLE_PATH="${TITLE// /_}"
# Assign file path
FILE_PATH="_posts/$DATE-$TITLE_PATH.md"

# Write to filepath
echo "$MARKDOWN_HEADER" > "$FILE_PATH"

# Let user know task complete and location of file
echo "Markdown header generated at $FILE_PATH"

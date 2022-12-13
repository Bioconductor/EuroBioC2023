
## This script should be used in the base directory of the hugo project
## In bash:
## bash create_abstracts.sh

## Delete previously created track files
rm -rf content/abstracts/track*.md
mkdir -p content/abstracts

for i in $(ls data/abstracts/*track*.yaml)
do

    echo Creating page for $i

    title=$(grep -e "title:" $i | sed "s/title: \"//" | sed "s/\"$//")
    session_type=$(grep -e "session_type:" $i | sed "s/session_type: \"//" | sed "s/\"$//")
    paper=$(grep -e "paper:" $i | sed -e "s/paper: \"//"  | sed "s/\"$//")

    echo title is $title
    echo session_type is $session_type
    echo paper is $paper
    
    echo -e "---
title: \"$title\"
tags: [\"$session_type\"]
type: \"blog\"
draft: false
---

{{< tracks track=\"$paper\">}}

" > content/abstracts/$paper.md 

done

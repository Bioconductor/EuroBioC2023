
## This script should be used in the base directory of the hugo project
## In bash:
## bash create_abstracts.sh


## Delete previously created abstracts
rm -rf content/abstracts/paper*.md
mkdir -p content/abstracts

for i in $(ls data/abstracts/*paper*yaml)
do

    echo Creating abstract page for $i

    title=$(grep -e "^title:" $i | sed -e "s/title: \"//" | sed "s/\"$//")
    session_type=$(grep -e "^session_type:" $i | sed "s/session_type: \"//" | sed "s/\"$//")
    paper=$(grep -e "^paper:" $i | sed "s/paper: \"//" | sed "s/\"$//")
    
    echo -e "---
title: \"$title\"
tags: [\"$session_type\"]
type: \"blog\"
draft: false
---

{{< abstracts paper=\"$paper\">}}

" > content/abstracts/$paper.md 

done

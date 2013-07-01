#! /bin/bash

title=`cat $1 | perl -nle 'print quotemeta($1) if /<h1>(.*)<\/h1>/'`

#echo $1
#echo $title

perl -p -i -e "s/<%= title %>/$title/" $1
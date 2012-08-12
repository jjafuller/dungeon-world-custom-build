#! /bin/bash

title=`cat $1 | perl -nle 'print quotemeta($1) if /<h1>(.*)<\/h1>/'`

#echo $1
#echo $title

sed -i "s/<%= title %>/$title/" $1
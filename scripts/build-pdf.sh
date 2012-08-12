#! /bin/bash

cd build/tex

pdflatex dungeon-world.tex
pdflatex dungeon-world.tex

rm dungeon-world.aux
rm dungeon-world.out
#rm dungeon-world.log

mv dungeon-world.pdf ../

cd ../..
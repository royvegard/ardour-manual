#!/bin/bash

for f in diagrams/*.svg; do
    g=`echo $f | sed -e "s/.svg/.pdf/"`
    inkscape -z -f $f --export-pdf $g --export-area-drawing
done

for f in graphics/*.svg; do
    g=`echo $f | sed -e "s/.svg/.pdf/"`
    inkscape -z -f $f --export-pdf $g --export-area-drawing
done

pdflatex ardour.tex
makeindex ardour
pdflatex ardour.tex
pdflatex ardour.tex

if [ "$1" == "-d" ]; then
    evince ardour.pdf
fi

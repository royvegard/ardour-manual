#!/bin/bash

for f in diagrams/*; do
    g=`echo $f | sed -e "s/.svg/.pdf/"`
    inkscape -z -f $f --export-pdf $g --export-area-drawing
done

pdflatex ardour.tex && pdflatex ardour.tex && pdflatex ardour.tex

if [ "$1" == "-d" ]; then
    evince ardour.pdf
fi

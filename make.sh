#!/bin/bash

if [ `which inkscape`g == "g" ]; then
    echo "You must have inkscape installed to build this manual"
    exit 1
fi

if [ `which pdflatex`g == "g" ]; then
    echo "You must have pdflatex installed to build this manual"
    exit 1
fi

if [ `which makeindex`g == "g" ]; then
    echo "You must have makeindex installed to build this manual"
    exit 1
fi

for f in diagrams/*.svg; do
    g=`echo $f | sed -e "s/.svg/.pdf/"`
    echo "Convert $f to PDF"
    inkscape -z -f $f --export-pdf $g --export-area-drawing
done

for f in graphics/*.svg; do
    g=`echo $f | sed -e "s/.svg/.pdf/"`
    echo "Convert $f to PDF"
    inkscape -z -f $f --export-pdf $g --export-area-drawing
done

pdflatex ardour.tex
makeindex ardour
pdflatex ardour.tex
pdflatex ardour.tex

if [ "$1" == "-d" ]; then
    evince ardour.pdf
fi

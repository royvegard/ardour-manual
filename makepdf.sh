#!/bin/bash

# We need Inkscape
if [ `which inkscape`g == "g" ]; then
    echo "You must have inkscape installed to build this manual"
    exit 1
fi

# Convert SVG to PDF.
for f in diagrams/*.svg; do
    g=`echo $f | sed -e "s/.svg/.pdf/"`
    echo "Convert $f to PDF"
    inkscape -z -f $f --export-pdf $g --export-area-drawing
done

# The DocBook needs to know what file extensions to look for
# for screenshots (scs) and diagrams (dia), so write a file
# to tell it.
cat > extensions.ent <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!ENTITY scs ".png">
<!ENTITY dia ".pdf">
EOF

mkdir -p pdf

# -P <foo> removes the revhistory table
dblatex -P doc.collab.show=0 -P latex.output.revhistory=0 -p ardour.xsl -s ardour.sty -r pptex.py -T simple ardour.xml -t pdf -o pdf/ardour.pdf



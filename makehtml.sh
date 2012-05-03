#!/bin/bash

# We need Inkscape
if [ `which inkscape`g == "g" ]; then
    echo "You must have inkscape installed to build this manual"
    exit 1
fi

# Convert SVG to PNG, as I don't think we can rely on browsers
# rendering SVG.  Come on, it's only 2012.
for f in diagrams/*.svg; do
    g=`echo $f | sed -e "s/.svg/.png/"`
    echo "Convert $f to PNG"
    inkscape -z -f $f --export-png $g --export-area-drawing
done

for f in graphics/*.svg; do
    g=`echo $f | sed -e "s/.svg/.png/"`
    echo "Convert $f to PNG"
    inkscape -z -f $f --export-png $g --export-area-drawing
done

# The DocBook needs to know what file extensions to look for
# for screenshots (scs) and diagrams (dia), so write a file
# to tell it
cat > extensions.ent <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!ENTITY scs ".png">
<!ENTITY dia ".png">
EOF

# Make the HTML
xmlto html -m config.xsl ardour.xml --skip-validation -o html

# Copy the PNG conversions into html/
mkdir -p html/diagrams
cp diagrams/*.png html/diagrams
mkdir -p html/graphics
cp graphics/*.png html/graphics
cp -r screenshots html/

# And our CSS
cp ardour.css html

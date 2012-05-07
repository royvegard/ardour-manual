# Ardour manual makefile

graphics/%.png:	graphics/%.svg
	inkscape -z -f $< --export-png $@ --export-area-drawing

graphics/%.pdf:	graphics/%.svg
	inkscape -z -f $< --export-pdf $@ --export-area-drawing

diagrams/%.png:	diagrams/%.svg
	inkscape -z -f $< --export-png $@ --export-area-drawing

diagrams/%.pdf:	diagrams/%.svg
	inkscape -z -f $< --export-pdf $@ --export-area-drawing

html:	ardour.xml ardour-html.xsl extensions-html.ent ardour.css graphics/*.png screenshots/*.png diagrams/*.png

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-html.ent extensions.ent

#	DocBoox -> html
	xmlto html -m ardour-html.xsl ardour.xml --skip-validation -o html

#	Copy graphics and CSS in
	mkdir -p html/diagrams
	cp diagrams/*.png html/diagrams
	mkdir -p html/graphics
	cp graphics/*.png html/graphics
	cp -r screenshots html
	cp ardour.css html

pdf:	ardour.xml ardour-pdf.xsl extensions-pdf.ent graphics/*.pdf screenshots/*.png diagrams/*.pdf

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-pdf.ent extensions.ent

# 	-P <foo> removes the revhistory table
	dblatex -P doc.collab.show=0 -P latex.output.revhistory=0 -p ardour-pdf.xsl -s ardour.sty -r pptex.py -T simple ardour.xml -t pdf -o pdf/ardour.pdf


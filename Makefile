# Ardour manual makefile

all:	html pdf

DIAGRAMS := ardour-monitoring.svg audio-region.svg basic-processor-list.svg basic-track-signal-flow.svg crossfades.svg \
	dragging-fades.svg editor-summary.svg external-monitoring.svg jack-monitoring.svg mixer-strip-summary.svg \
	mixer-summary.svg overlapping-regions.svg route-in-detail.svg solo-mute.svg swing.svg toolbar-annotated.svg \
	typical-jack-session.svg typical-midi-track-controls.svg zoom-controls.svg

graphics/%.png:	graphics/%.svg
	inkscape -z -f $< --export-png $@ --export-area-drawing

graphics/%.pdf:	graphics/%.svg
	inkscape -z -f $< --export-pdf $@ --export-area-drawing

diagrams/%.png:	diagrams/%.svg
	inkscape -z -f $< --export-png $@ --export-area-drawing

diagrams/%.pdf:	diagrams/%.svg
	inkscape -z -f $< --export-pdf $@ --export-area-drawing

html:	ardour.xml ardour-html.xsl extensions-html.ent ardour.css screenshots/*.png $(subst .svg,.png,$(addprefix diagrams/,$(DIAGRAMS)))

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-html.ent extensions.ent

#	DocBoox -> html
	xmlto html -m ardour-html.xsl ardour.xml --skip-validation -o html

#	Copy graphics and CSS in
	mkdir -p html/diagrams
	cp diagrams/*.png html/diagrams
	cp -r screenshots html
	cp ardour.css html

pdf:	pdf/ardour.pdf

pdf/ardour.pdf:	ardour.xml ardour-pdf.xsl extensions-pdf.ent screenshots/*.png $(subst .svg,.pdf,$(addprefix diagrams/,$(DIAGRAMS)))

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-pdf.ent extensions.ent

	mkdir -p pdf

# 	-P <foo> removes the revhistory table
	dblatex -P doc.collab.show=0 -P latex.output.revhistory=0 -p ardour-pdf.xsl -s ardour.sty -r pptex.py -T native ardour.xml -t pdf -o pdf/ardour.pdf


clean:;	rm -rf html pdf diagrams/*.pdf diagrams/*.png graphics/*.png *.aux ardour.cb ardour.cb2 ardour.glo ardour.idx ardour.ilg
	rm -rf ardour.ind ardour.lof ardour.log ardour.tex ardour.toc extensions.ent ardour.out

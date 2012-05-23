# Ardour manual makefile

all:	html pdf

DIAGRAMS := ardour-monitoring.svg audio-region.svg basic-processor-list.svg basic-track-signal-flow.svg crossfades.svg \
	dragging-fades.svg editor-summary.svg external-monitoring.svg jack-monitoring.svg mixer-strip-summary.svg \
	mixer-summary.svg overlapping-regions.svg route-in-detail.svg solo-mute.svg step-entry.svg swing.svg \
	toolbar-annotated.svg typical-jack-session.svg typical-midi-track-controls.svg zoom-controls.svg \
	session.svg time-tempo-changes1.svg time-tempo-changes2.svg thinning.svg

SCREENSHOTS := add-track-or-bus.png audio-midi-setup-advanced.png audio-midi-setup-device.png audio-midi-setup-options.png \
	automation-lane.png default-folder-for-new-sessions.png editor.png export-dialogue.png fades-menu.png go-to-end.png \
	go-to-start.png input-connection-matrix.png input-port-matrix.png loop.png midi-edit1.png midi-edit2.png midi-edit5.png \
	midi-panic.png mixer.png monitoring-choices.png monitor-section.png new-session.png play.png play-range.png processor-box.png \
	quantize.png recorded-one-region.png session-record.png region-fades.png region-gain-line.png region-trim-end.png rhythm-ferret-dialogue.png \
	route-group-dialogue.png stop.png strip-silence-dialogue.png tool-draw-midi.png tool-listen.png tool-objects.png tool-ranges.png \
	tool-region-contents.png tool-region-gain.png tool-stretch.png tool-zoom.png top-of-mixer-strip.png track-controls.png track-in-group.png \
	transport-controls.png typical-audio-track-controls.png typical-bus-controls.png welcome-to-ardour.png connection-manager.png \
	punch-in-out-buttons.png punch-range-marker.png track-record.png

XML := advanced_jack.xml ardour.xml automation.xml configuration.xml editing.xml editor_window.xml introduction.xml jack.xml \
	misc.xml overview.xml quick_start.xml recording.xml region_operations.xml sessions.xml signal_flow_and_the_mixer.xml \
	tracks_and_busses.xml troubleshooting.xml synchronisation.xml control_surfaces.xml

GRAPHICS := cc.png

#
# For the HTML, default to copying the screenshots direct
#
html/screenshots/%.png: screenshots/%.png
	mkdir -p html/screenshots
	cp $< $@

#
# Some need resizing...
#
html/screenshots/editor.png: screenshots/editor.png
	mkdir -p html/screenshots
	convert -resize 50% $< $@
html/screenshots/mixer.png: screenshots/mixer.png
	mkdir -p html/screenshots
	convert -resize 50% $< $@
html/screenshots/default-folder-for-new-sessions.png: screenshots/default-folder-for-new-sessions.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@
html/screenshots/welcome-to-ardour.png: screenshots/welcome-to-ardour.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@
html/screenshots/monitoring-choices.png: screenshots/monitoring-choices.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@
html/screenshots/monitor-section.png: screenshots/monitor-section.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@
html/screenshots/audio-midi-setup-device.png: screenshots/audio-midi-setup-device.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@
html/screenshots/new-session.png: screenshots/new-session.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@
html/screenshots/export-dialogue.png: screenshots/export-dialogue.png
	mkdir -p html/screenshots
	convert -resize 75% $< $@

# For HTML: convert graphics from SVG to PNG
graphics/%.png:	graphics/%.svg
	inkscape -z -f $< --export-png $@ --export-area-drawing

# For LaTeX/PDF: convert graphics from SVG to PDF
graphics/%.pdf:	graphics/%.svg
	inkscape -z -f $< --export-pdf $@ --export-area-drawing

# For HTML: convert diagrams from SVG to PNG
diagrams/%.png:	diagrams/%.svg
	inkscape -z -f $< --export-png $@ --export-area-drawing

# For LaTeX/PDF: convert diagrams from SVG to PDF
diagrams/%.pdf:	diagrams/%.svg
	inkscape -z -f $< --export-pdf $@ --export-area-drawing

#
# HTML
#

html:	$(XML) ardour-html.xsl extensions-html.ent ardour.css \
	$(addprefix html/screenshots/,$(SCREENSHOTS)) \
	$(subst .svg,.png,$(addprefix diagrams/,$(DIAGRAMS))) \
	$(subst .svg,.png,$(addprefix graphics/,$(GRAPHICS))) \

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-html.ent extensions.ent

#	DocBoox -> html
	xmlto html -m ardour-html.xsl ardour.xml --skip-validation -o html

#	Copy graphics and CSS in
	mkdir -p html/diagrams html/graphics
	cp diagrams/*.png html/diagrams
	cp graphics/*.png html/graphics
	cp ardour.css html

#
# PDF
#

pdf:	$(XML) ardour-pdf.xsl extensions-pdf.ent screenshots/*.png $(subst .svg,.pdf,$(addprefix diagrams/,$(DIAGRAMS)))

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-pdf.ent extensions.ent

	mkdir -p pdf

	dblatex -p ardour-pdf.xsl -s ardour.sty -r pptex.py -T native ardour.xml -t pdf -o pdf/ardour.pdf


#
# LaTeX (handy for debugging)
#

tex:	$(XML) ardour-pdf.xsl extensions-pdf.ent

# 	The DocBook needs to know what file extensions to look for
# 	for screenshots and diagrams; use the correct file to tell it.
	cp extensions-pdf.ent extensions.ent

	mkdir -p tex

# 	-P <foo> removes the revhistory table
	dblatex -P doc.collab.show=0 -P latex.output.revhistory=0 -p ardour-pdf.xsl -s ardour.sty -r pptex.py -T native ardour.xml -t tex -o tex/ardour.tex


clean:;	rm -rf html pdf diagrams/*.pdf diagrams/*.png graphics/*.png *.aux ardour.cb ardour.cb2 ardour.glo ardour.idx ardour.ilg
	rm -rf ardour.ind ardour.lof ardour.log ardour.tex ardour.toc extensions.ent ardour.out

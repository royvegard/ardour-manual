#!/bin/bash

mkdir -p tex
dblatex -s ardour.sty -T simple ardour.xml -t pdf -o tex/ardour.pdf



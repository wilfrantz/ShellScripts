#!/bin/bash

convert -density 150 -fill  "rgba(255,0,0,0.25)"  -gravity Center -pointsize 80 -draw "rotate -45 text 0,0 \"$2\""  "$1" "$3"

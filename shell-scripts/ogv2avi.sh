#!/bin/bash
# ogv to avi
# invoke as: /usr/bin/ogv2avi foo.ogv bar.avi
mencoder "$1" -ovc xvid -oac mp3lame -xvidencopts pass=1 -o "$2"


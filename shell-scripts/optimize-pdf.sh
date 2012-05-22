#!/bin/bash
# http://www.ubuntugeek.com/ubuntu-tiphowto-reduce-adobe-acrobat-file-size-from-command-line.html

read -p "Enter source filename: " SOURCE
read -p "Enter destination filename: " DESTINATION

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$DESTINATION $SOURCE

# http://milan.kupcevic.net/ghostscript-ps-pdf/

# PDF optimization level selection options
# -dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
# -dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
# -dPDFSETTINGS=/printer  (high quality, 300 dpi images)
# -dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
# -dPDFSETTINGS=/default  (almost identical to /screen)

# Paper size selection options
# -sPAPERSIZE=letter
# -sPAPERSIZE=a4
# -dDEVICEWIDTHPOINTS=w -dDEVICEHEIGHTPOINTS=h (point=1/72 of an inch)
# -dFIXEDMEDIA (force paper size over the PostScript defined size)

# Other options
# -dEmbedAllFonts=true
# -dSubsetFonts=false
# -dFirstPage=pagenumber
# -dLastPage=pagenumber
# -dAutoRotatePages=/PageByPage
# -dAutoRotatePages=/All
# -dAutoRotatePages=/None
# -r1200 (resolution for pattern fills and fonts converted to bitmaps)
# -sPDFPassword=password


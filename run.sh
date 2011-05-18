#!/bin/sh
set -e
ghc --make $1.hs -O -fforce-recomp $2
./$1 +RTS -hT -i0.05 || true
~/Dev/hp2pretty/dist/build/hp2pretty/hp2pretty < $1.hp > $1.svg
rsvg $1.svg $1.png
xview $1.png

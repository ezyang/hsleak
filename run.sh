#!/bin/sh
set -e
ghc --make $1.hs -O -fforce-recomp
./$1 +RTS -hT -i0.05 || true
hp2ps $1
evince $1.ps

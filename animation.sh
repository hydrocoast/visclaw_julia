#!/bin/bash

## (input) *.svg filepath
if [ -z "$1" ]; then
    dirname="./fig"
else
    dirname="$1"
fi

## (input) prefix of .svg
if [ -z "$2" ]; then
    prefix="step"
else
    prefix="$2"
fi

## (output) prefix of .gif
if [ -z "$3" ]; then
    gifname="out"
else
    gifname="$3"
fi

## pwd
homedir=`pwd`
cd ${dirname}

## convert svg to png
convert ${prefix}*.svg  ${prefix}%03d.png

## the number of files
nf=$(ls -1 step*.png| wc -l )

## make an animation
ffmpeg -i ${prefix}%03d.png -vf palettegen palette.png
ffmpeg -r 4 -i ${prefix}%03d.png -i palette.png -filter_complex paletteuse ${homedir}/${gifname}.gif

## remove temporary files
rm *.png

cd ${homedir}

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

## the number of files
nf=$(ls -1 ${prefix}*.svg| wc -l )

## make an animation
ffmpeg -i ${prefix}%03d.svg -vf palettegen palette.png
ffmpeg -y -r 4 -i ${prefix}%03d.svg -i palette.png -filter_complex paletteuse ${gifname}.gif

## remove temporary files
rm palette.png

cd ${homedir}

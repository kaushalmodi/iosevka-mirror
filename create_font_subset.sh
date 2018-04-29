#!/usr/bin/env bash
# Time-stamp: <2018-04-29 10:29:15 kmodi>

# https://github.com/be5invis/Iosevka/issues/238#issuecomment-351527918
# pyftsubset - https://github.com/fonttools/fonttools
# Name Identifiers (name-ID): https://developer.apple.com/fonts/TrueType-Reference-Manual/RM06/Chap6name.html
# Creating subset font: https://michaeljherold.com/2016/05/04/creating-a-subset-font.html

# Using the --with-zopfli option required first doing "pip install --user zopfli"
# Using pyftsubset for woff2 required first doing "pip install --user brotli"

# Use http://torinak.com/font/lsfont.html to verify the generated fonts

set -euo pipefail # http://redsymbol.net/articles/unofficial-bash-strict-mode
IFS=$'\n\t'

# glyphs_file="./glyphs.txt" # Source: https://github.com/be5invis/Iosevka/issues/238#issuecomment-384515046
# common_args="--name-IDs+=0,4,6 --text-file=${glyphs_file}"

# Unicode table: https://unicode-table.com/en/
#   U+0020-007E : Basic Latin : https://unicode-table.com/en/blocks/basic-latin/
#   U+00A7-00BE : Latin 1 Supplement : https://unicode-table.com/en/blocks/latin-1-supplement/
#   U+2000-205E : General Punctuation : https://unicode-table.com/en/blocks/general-punctuation/ (includes zero width space, curly quotes, etc.)
common_args='--layout-features="" --unicodes="U+0020-007E,U+00A7-00BE,U+2000-205E"'

run_pyftsubset () {
    font="${1}"

    echo "${font}: Generating subset WOFF files .."
    for file in ${font}/ttf/*
    do
        # Get basename without extension from ${file}
        # https://stackoverflow.com/a/2664746/1219634
        tmp="${file##*/}"
        basename_no_ext="${tmp%.*}"
        # echo "file = ${file}"
        # echo "basename_no_ext = ${basename_no_ext}"
        # https://stackoverflow.com/a/407334/1219634
        if [[ $file == *.ttf ]] # The ${font}/ttf HAS to contain .ttf font files.
        then
            eval "pyftsubset ${file} ${common_args} --flavor=woff --with-zopfli --output-file=./woff/${basename_no_ext}.woff"
        fi
    done

    echo "${font}: Generating subset WOFF2 files .."
    for file in ${font}/ttf/*
    do
        tmp="${file##*/}"
        basename_no_ext="${tmp%.*}"
        if [[ $file == *.ttf ]] # The ${font}/src HAS to contain .ttf font files.
        then
            eval "pyftsubset ${file} ${common_args} --flavor=woff2 --output-file=./woff2/${basename_no_ext}.woff2"
        fi
    done
}

run_pyftsubset "."

echo "Done!"

#!/bin/sh
# Use ldd command to find out all shared library dependencies of program.
# and use patchelf tool to patch it.
# Author: Yang Zhang  <yzfedora@gmail.com>

if [ $# != 2 ]; then
    echo "Usage: $0 path_to_program output_directory"
    exit 1
fi

program="$1"
outputdir="$2"
libfile="libraries.txt"

if [ ! -e "$outputdir" ]; then
    if ! mkdir -p $outputdir; then
        exit
    fi
fi

rm -rf $libfile
for lib in `ldd $program | grep -oE "\/[-_+./0-9a-zA-Z]+ "`; do
    echo "$lib" >> $libfile
done

interpreter="`basename $(cat $libfile | grep ld-linux | tr -d '\n')`"
for lib in `cat $libfile`; do
    cp $lib $outputdir

    libname=`basename $lib`
    if echo $libname | grep ld-linux >/dev/null 2>&1; then
        continue
    fi

    # patch the dynamic library only. 
    echo "patchelf --set-rpath $outputdir $outputdir/$libname"
    if ! patchelf --set-rpath $outputdir $outputdir/$libname; then
        exit 1
    fi
done

echo "patchelf --set-rpath $outputdir --set-interpreter $outputdir/$interpreter $program"
if ! patchelf --set-rpath $outputdir --set-interpreter $outputdir/$interpreter $program; then
    exit 1
fi

echo "patchelf --shrink-rpath $program"
if ! patchelf --shrink-rpath $program; then
    exit 1
fi

rm -rf $libfile

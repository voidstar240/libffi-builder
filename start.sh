#!/bin/bash

set -e

DATA="/data"
VERSION="3.5.2"
SOURCE="$DATA/source"
PKGDIR="$DATA/pkg"
OUT="$DATA/libffi-$VERSION"


if [ ! -f "source.tar.gz" ]; then
    echo "Downloading libffi source..."
    cd "$DATA"
    wget "https://github.com/libffi/libffi/archive/refs/tags/v$VERSION.tar.gz" -O "source.tar.gz"
fi

if [ ! -d "$SOURCE" ]; then
    echo "Extracting libffi source..."
    cd "$DATA"
    mkdir "$SOURCE" > /dev/null 2>&1 || true
    tar -xf "source.tar.gz" -C "$SOURCE" --strip-components 1
fi

echo "Compiling libffi..."
cd "$SOURCE"
./autogen.sh
./configure --disable-exec-static-tramp --disable-multi-os-directory --enable-pax_emutramp --prefix="/" --disable-docs
make

echo "Packaging libffi..."
make DESTDIR="$PKGDIR" install
mkdir "$OUT" > /dev/null 2>&1 || true
mkdir "$OUT/include" > /dev/null 2>&1 || true
cp "$PKGDIR/lib/libffi.a"        "$OUT"
cp "$PKGDIR/lib/libffi.so.8.2.0" "$OUT"
cp "$PKGDIR/include/ffi.h"       "$OUT/include"
cp "$PKGDIR/include/ffitarget.h" "$OUT/include"

cd "$DATA"
tar --transform 's,^data/,,' -czvf "libffi-$VERSION.tar.gz" "$OUT"
echo "Done"

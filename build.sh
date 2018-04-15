#!/bin/bash
# Patch an issue with glibc-2.26
sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
HELP2MAN=/bin/true \
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 || exit 1
make -j $SHED_NUM_JOBS || exit 1
make "DESTDIR=${SHED_FAKE_ROOT}" install || exit 1
ln -sv flex ${SHED_FAKE_ROOT}/usr/bin/lex

#!/bin/bash
sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
HELP2MAN=/tools/bin/true \
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
ln -sv flex ${SHED_FAKEROOT}/usr/bin/lex

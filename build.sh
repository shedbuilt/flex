#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_TRUE_PATH='/bin/true'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    SHED_PKG_LOCAL_TRUE_PATH='/tools/bin/true'
fi
SHED_PKG_LOCAL_DOCDIR="/usr/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}"

# Patch an issue with glibc-2.26
sed -i "/math.h/a #include <malloc.h>" src/flexdef.h &&

# Configure
HELP2MAN=$SHED_PKG_LOCAL_TRUE_PATH \
./configure --prefix=/usr \
            --docdir="$SHED_PKG_LOCAL_DOCDIR" &&

# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&

# Create a 'lex' symlink
ln -sv flex "${SHED_FAKE_ROOT}/usr/bin/lex" || exit 1

# Prune Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}/usr/share/doc"
fi

#!/bin/bash

. ./config.sh

UNBOUND_VERSION=release-1.16.2
UNBOUND_HASH="cbed768b8ff9bfcf11089a5f1699b7e5707f1ea5"
UNBOUND_SRC_DIR=$WORKDIR/unbound-1.16.2

PREFIX=$WORKDIR/prefix_${arch}

cd $WORKDIR
rm -rf $UNBOUND_SRC_DIR
git clone https://github.com/NLnetLabs/unbound.git -b ${UNBOUND_VERSION} ${UNBOUND_SRC_DIR}
cd $UNBOUND_SRC_DIR
test `git rev-parse HEAD` = ${UNBOUND_HASH} || exit 1

CC=clang CXX=clang++
./configure \
	CFLAGS=-fPIC \
	CXXFLAGS=-fPIC \
	--prefix=${PREFIX} \
	--host=${HOST} \
	--enable-static \
	--disable-shared \
	--disable-flto \
	--with-ssl=${PREFIX} \
	--with-libexpat=${PREFIX}
make -j$THREADS
make -j$THREADS install

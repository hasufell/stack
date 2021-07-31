#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../../ghcup_env"

mkdir -p "${TMPDIR}"
mkdir -p "${STACK_ROOT}"

if [ $ARCH = 'ARM64' ] ; then
	curl -sSfL https://downloads.haskell.org/~ghcup/0.1.15.1/aarch64-apple-darwin-ghcup-0.1.15.1 > ./ghcup-bin
	chmod +x ghcup-bin
else
	curl -sSfL https://downloads.haskell.org/~ghcup/x86_64-apple-darwin-ghcup > ./ghcup-bin
	chmod +x ghcup-bin
fi

./ghcup-bin -v upgrade -f
ghcup install ghc ${GHC_VERSION}
ghcup set ghc ${GHC_VERSION}
ghcup install cabal ${CABAL_VERSION}
rm ghcup-bin


if [ $ARCH = 'ARM64' ] ; then
	cabal update
	mkdir vendored
	cd vendored
	cabal unpack network-3.1.2.1
	cd network*
	autoreconf -fi
	cd ../..
fi

cat << EOF > cabal.project
packages: ./stack.cabal

optional-packages: ./vendored/*/*.cabal
EOF


exit 0

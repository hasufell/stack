#!/bin/sh

set -eux

# pkg install --force --yes --no-repo-update curl gcc gmp gmake ncurses perl5 libffi libiconv

. "$( cd "$(dirname "$0")" ; pwd -P )/../../ghcup_env"

mkdir -p "${TMPDIR}"
mkdir -p "${STACK_ROOT}"

curl -sSfL https://downloads.haskell.org/~ghcup/x86_64-portbld-freebsd-ghcup > ./ghcup-bin
chmod +x ghcup-bin

./ghcup-bin -v upgrade -f
ghcup install ghc ${GHC_VERSION}
ghcup set ghc ${GHC_VERSION}
ghcup install cabal ${CABAL_VERSION}
rm ghcup-bin

exit 0

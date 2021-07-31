#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../../ghcup_env"

mkdir -p "${TMPDIR}" "${CABAL_DIR}"
mkdir -p "${CI_PROJECT_DIR}"/sr

mkdir -p "$GHCUP_INSTALL_BASE_PREFIX/ghcup/bin"

CI_PROJECT_DIR=$(pwd)
curl -o ghcup.exe https://downloads.haskell.org/~ghcup/0.1.16.1/x86_64-mingw64-ghcup-0.1.16.1.exe
chmod +x ghcup.exe

./ghcup.exe -v upgrade -f
ghcup.exe install ghc ${GHC_VERSION}
ghcup.exe set ghc ${GHC_VERSION}
ghcup.exe install cabal ${CABAL_VERSION}

rm ./ghcup.exe

exit 0

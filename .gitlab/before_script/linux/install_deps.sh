#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../../ghcup_env"

mkdir -p "${TMPDIR}"
mkdir -p "${STACK_ROOT}"

sudo -V || { apt-get update -y && apt-get install -y sudo ; }

sudo apt-get update -y
sudo apt-get install -y libnuma-dev zlib1g-dev libgmp-dev libgmp10 libssl-dev liblzma-dev libbz2-dev git wget lsb-release software-properties-common gnupg2 apt-transport-https

if [ "${CROSS}" = "arm-linux-gnueabihf" ] ; then
	sudo apt-get install -y autoconf build-essential gcc-arm-linux-gnueabihf
	sudo dpkg --add-architecture armhf
	sudo apt-get update -y
	sudo apt-get install -y libncurses-dev:armhf
fi

case "${ARCH}" in
	"ARM")
		url=https://downloads.haskell.org/~ghcup/0.1.16.1/armv7-linux-ghcup-0.1.16.1
		;;
	"ARM64")
		url=https://downloads.haskell.org/~ghcup/0.1.16.1/aarch64-linux-ghcup-0.1.16.1
		;;
	32)
		url=https://downloads.haskell.org/~ghcup/0.1.16.1/i386-linux-ghcup-0.1.16.1
		;;
	64)
		url=https://downloads.haskell.org/~ghcup/0.1.16.1/x86_64-linux-ghcup-0.1.16.1
		;;
	*) exit 1 ;;
esac


curl -sSfL "${url}" > ./ghcup-bin
chmod +x ghcup-bin

./ghcup-bin -v upgrade -f
ghcup install ghc ${GHC_VERSION} || { cat "${GHCUP_INSTALL_BASE_PREFIX}"/.ghcup/logs/* ; exit 1 ; }
ghcup set ghc ${GHC_VERSION}
ghcup install cabal ${CABAL_VERSION}
rm ghcup-bin

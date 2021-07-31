#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../ghcup_env"

mkdir -p "$CI_PROJECT_DIR"/.local/bin

CI_PROJECT_DIR=$(pwd)

ecabal() {
	cabal "$@"
}

if [ "${OS}" = "WINDOWS" ] ; then
	GHCUP_DIR="${GHCUP_INSTALL_BASE_PREFIX}"/ghcup
else
	GHCUP_DIR="${GHCUP_INSTALL_BASE_PREFIX}"/.ghcup
fi

git describe --always

if [ "${OS}" = "WINDOWS" ] ; then
	ext=".exe"
else
	ext=''
fi

### build

ecabal update

echo '' >> stack.yaml
echo 'allow-different-user: true' >> stack.yaml


if [ "${OS}" = "LINUX" ] ; then
	if [ "${ARCH}" = "32" ] ; then
		ecabal build -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections -optl-static'
		cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections -optl-static' --verbose=0 --offline sh -- -c 'command -v stack')" "$CI_PROJECT_DIR"/.local/bin/stack${ext}
		cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections -optl-static' --verbose=0 --offline sh -- -c 'command -v stack-integration-test')" "$CI_PROJECT_DIR"/.local/bin/stack-integration-test${ext}
	elif [ "${ARCH}" = "64" ] ; then
		ecabal build -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections -optl-static'
		cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections -optl-static' --verbose=0 --offline sh -- -c 'command -v stack')" "$CI_PROJECT_DIR"/.local/bin/stack${ext}
		cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections -optl-static' --verbose=0 --offline sh -- -c 'command -v stack-integration-test')" "$CI_PROJECT_DIR"/.local/bin/stack-integration-test${ext}
	else
		ecabal build -w ghc-${GHC_VERSION} -f integration-tests
		cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --verbose=0 --offline sh -- -c 'command -v stack')" "$CI_PROJECT_DIR"/.local/bin/stack${ext}
		cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --verbose=0 --offline sh -- -c 'command -v stack-integration-test')" "$CI_PROJECT_DIR"/.local/bin/stack-integration-test${ext}
	fi
elif [ "${OS}" = "FREEBSD" ] ; then
	ecabal build -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections'
	cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections' --verbose=0 --offline sh -- -c 'command -v stack')" "$CI_PROJECT_DIR"/.local/bin/stack${ext}
	cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --ghc-options='-split-sections' --verbose=0 --offline sh -- -c 'command -v stack-integration-test')" "$CI_PROJECT_DIR"/.local/bin/stack-integration-test${ext}
elif [ "${OS}" = "WINDOWS" ] ; then
	ecabal build -w ghc-${GHC_VERSION} -f integration-tests
	cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --verbose=0 --offline sh -- -c 'command -v stack')" "$CI_PROJECT_DIR"/.local/bin/stack${ext}
	cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --verbose=0 --offline sh -- -c 'command -v stack-integration-test')" "$CI_PROJECT_DIR"/.local/bin/stack-integration-test${ext}
else
	ecabal build -w ghc-${GHC_VERSION} -f integration-tests
	cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --verbose=0 --offline sh -- -c 'command -v stack')" "$CI_PROJECT_DIR"/.local/bin/stack${ext}
	cp "$(ecabal new-exec -w ghc-${GHC_VERSION} -f integration-tests --verbose=0 --offline sh -- -c 'command -v stack-integration-test')" "$CI_PROJECT_DIR"/.local/bin/stack-integration-test${ext}
fi
ecabal test -w ghc-${GHC_VERSION}
ecabal haddock -w ghc-${GHC_VERSION}

# strip
if [ "${OS}" = "DARWIN" ] ; then
	strip "$CI_PROJECT_DIR"/.local/bin/stack
else
	strip -s "$CI_PROJECT_DIR"/.local/bin/stack
fi


### cleanup

rm -rf "${GHCUP_DIR}"


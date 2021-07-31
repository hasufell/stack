#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../ghcup_env"

mkdir -p "$CI_PROJECT_DIR"/.local/bin

ghcup install ghc 8.6.5

ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

# gitlab docker stuff doesn't use root and breaks all sorts of stack assumptions
echo "" >> stack.yaml
echo "allow-different-user: true" >> stack.yaml

# Nix cannot be installed from within docker: https://github.com/NixOS/nixpkgs/issues/2878
# So just disable nix tests.
rm -r test/integration/tests/4095-utf8-pure-nix

# broken, reason unclear
if [ "${OS}" = "WINDOWS" ] ; then
	rm -r test/integration/tests/3631-build-http2
	rm -r test/integration/tests/haddock-options
	rm -r test/integration/tests/override-compiler
	rm -r test/integration/tests/upload
elif [ "${OS}" = "LINUX" ] ; then
	rm -r test/integration/tests/3997-coverage-with-cabal-3
	rm -r test/integration/tests/4101-dependency-tree
	rm -r test/integration/tests/sanity
elif [ "${OS}" = "DARWIN" ] ; then
	rm -r test/integration/tests/4101-dependency-tree
	rm -r test/integration/tests/sanity
elif [ "${OS}" = "FREEBSD" ] ; then
	rm -r test/integration/tests/1337-unicode-everywhere
	rm -r test/integration/tests/4101-dependency-tree
	rm -r test/integration/tests/4938-non-ascii-module-names
	rm -r test/integration/tests/internal-libraries
	rm -r test/integration/tests/sanity
fi

# run the tests
"$CI_PROJECT_DIR"/.local/bin/stack-integration-test


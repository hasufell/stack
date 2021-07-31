#!/bin/sh

set -eux

. "$( cd "$(dirname "$0")" ; pwd -P )/../../ghcup_env"

mkdir -p "${TMPDIR}"
mkdir -p "${STACK_ROOT}"

sudo apt-get update -y
sudo apt-get install -y libnuma-dev zlib1g-dev libgmp-dev libgmp10 libssl-dev liblzma-dev libbz2-dev git wget

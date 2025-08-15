#!/bin/sh -e

set -x

script_path=$(dirname "$(realpath "$0")")

sudo ln -sf "$script_path"/configuration.nix /etc/nixos/configuration.nix
#https://github.com/Zaechus/nixos-config/blob/main/setup.sh
#!/bin/sh -e

set -x

script_path=$(dirname "$(realpath "$0")")

sudo ln -sf "$script_path"/flake.nix /etc/nixos/flake.nix
#sudo ln -sf "$script_path"/configuration.nix /etc/nixos/configuration.nix
#sudo ln -sf "$script_path"/home.nix ~/.config/home-manager/home.nix

sudo nixos-rebuild switch --flake ".#$1" --impure 

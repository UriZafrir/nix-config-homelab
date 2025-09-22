
git clone git@github.com:UriZafrir/nix-config-homelab.git

./setup.sh


sudo nixos-rebuild switch --flake ~/general/nix-config-homelab/

nix flake update --flake ~/general/nix-config-homelab/
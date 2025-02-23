
git clone git@github.com:UriZafrir/nix-config-homelab.git
cd nix-config-homelab
mv /etc/nixos/* .
sudo ln -s "/home/uri/nix-config-homelab/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
sudo ln -s "/home/uri/nix-config-homelab/configuration.nix" /etc/nixos/configuration.nix

nixos-rebuild switch
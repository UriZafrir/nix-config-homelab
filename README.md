
install git with nix-env or:
git clone git@github.com:UriZafrir/nix-config-homelab.git
cd nix-config-homelab
mv /etc/nixos/configuration.nix .
cp /etc/nixos/hardware-configuration.nix .
sudo ln -s "/home/uri/nix-config-homelab/configuration.nix" /etc/nixos/configuration.nix

nixos-rebuild switch --verbose
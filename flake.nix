{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Add Proxmox VE input
    # proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };

#  outputs = inputs@{ nixpkgs, home-manager, nur, proxmox-nixos, ... }: {

  outputs = inputs@{ nixpkgs, home-manager, nur, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit nur; };
        modules = [
        ./hosts/home-lab/configuration.nix
          {
            nixpkgs.overlays = [ 
              nur.overlays.default 
              # proxmox-nixos.overlays.${system}
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.uri = ./home/home.nix;
          }
          # proxmox-nixos.nixosModules.proxmox-ve
          # # Proxmox VE configuration
          # ({ pkgs, lib, ... }: {
          #   services.proxmox-ve = {
          #     enable = true;
          #     ipAddress = "192.168.0.105";  # Change to your host IP
          #     bridges = [ "vmbr0" ];
          #   };
          # })
        ];
      };
    };
  };
}
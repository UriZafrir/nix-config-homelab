# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
      (import "${home-manager}/nixos")
    ];
  services.vscode-server.enable = true;
  #as non root, run this
  #systemctl --user enable auto-fix-vscode-server.service
  #systemctl --user start auto-fix-vscode-server.service

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/mnt/data" = {
    device = "/dev/sda1";
    fsType = "auto";
  };
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;


services.xserver.desktopManager.gnome.enable = true;
#this one
services.xserver = {
  enable = true;
  displayManager.gdm = {
    enable = true;
    wayland = true;
  };
};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uri = {
    isNormalUser = true;
    description = "uri";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
    
  };
  
  home-manager.users.uri = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.httpie ];
  programs.bash.enable = true;

  # This value determines the Home Manager release that your configuration is 
  # compatible with. This helps avoid breakage when a new Home Manager release 
  # introduces backwards incompatible changes. 
  #
  # You should not change this value, even if you update Home Manager. If you do 
  # want to update the value, then make sure to first check the Home Manager 
  # release notes. 
  home.stateVersion = "24.11"; # Please read the comment before changing. 

};
  security.sudo.wheelNeedsPassword = false;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # environment.variables = {
  #   EDITOR = "vim";
  # };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.interactiveShellInit = ''
    # Your .bashrc entries go here
  '';
  environment.systemPackages = with pkgs; [
    #utils
    vim 
    wget
    git
    curl
    htop
    jq
    traceroute
    dnsutils
    openssl
    lsof

    #kubernetes
    kubectl
    kubernetes-helm
    k9s
    docker
    docker-compose
    minikube
    vscode
    vscode.fhs
  
    #weston
    #wlr-randr
    #ddcutil

    #brightness
    gnome-randr

    #programs
    firefox
    qbittorrent
    chromium
    adwaita-icon-theme
    google-chrome
    keepassxc
    remmina
    flameshot
    gnome-terminal
    efibootmgr
    gnomeExtensions.dash-to-panel
    vlc
    pamixer
    clipit
    zed-editor
    tabby

    #programming
    python314
    go
    gnumake
    copyq
    vscodium-fhs
    envsubst
    nodejs_22
    git-filter-repo
    gnome-tweaks
    poetry
    python313Packages.pip
    pipx
    rustup
    rustc
    pnpm
    xdg-utils

    #sound
    pavucontrol
    alsa-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  services.k3s = {
    enable = false;
    role = "server";
    extraFlags = [
      "--disable=traefik"
      "--disable=servicelb"
      "--default-local-storage-path=/mnt/data"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.extraHosts =
    ''
      #192.168.0.105 jellyfin.uri.cluster.gd

    '';
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;  

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
};
boot.loader.grub.useOSProber = true;

}

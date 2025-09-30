# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# let
#   home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
      # (import "${home-manager}/nixos")
    ];
  # services.vscode-server.enable = true;
  #as non root, run this
  #systemctl --user enable auto-fix-vscode-server.service
  #systemctl --user start auto-fix-vscode-server.service
  #https://nixos.wiki/wiki/Visual_Studio_Code
  programs.nix-ld.enable = true;

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/mnt/data" = {
    device = "/dev/sda1";
    fsType = "auto";
  };

  # system.activationScripts.setDataPerms.text = ''
  # chown -R uri:users /mnt/data
  # '';
  
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
  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = true;
  # };
  # networking.interfaces.wlan.ipv4.routes = [
  #   {
  #     address = "192.168.0.0";      # Destination network
  #     prefixLength = 16;            # Subnet mask 255.255.0.0
  #     via = "192.168.0.1";          # Next-hop gateway IP
  #   }
  # ];
  #https://github.com/ThomasRives/Proxmox-over-wifi
  #to use proxmox with wifi we need these:
  #bridge for proxmox
  # networking = {
  #   bridges.vmbr0 = {
  #     interfaces = [];
  #   };
  #   interfaces.vmbr0.useDHCP = false;
  #   interfaces.vmbr0.ipv4.addresses = [{
  #     address = "192.168.200.1";
  #     prefixLength = 24;
  #   }];
  #   #for localCommands need to use sudo systemctl restart NetworkManager.service, didnt work so i did manually, then checked using cat /sys/class/net/vmbr0/bridge/forward_delay
  #   localCommands = '' 
  #     ip link set dev vmbr0 type bridge forward_delay 0
  #   '';
  # };
  # #ipforwarding  
  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = true;
  # };
  # #nat masquerade for proxmox
  # networking.firewall.extraCommands = ''
  #   iptables -t nat -A POSTROUTING -s 192.168.200.0/24 -o wlo1 -j MASQUERADE
  #   iptables -t raw -I PREROUTING -i fwbr+ -j CT --zone 1
  # '';

  # services.dnsmasq= {
  #   enable = true;
  #   settings = {
  #   # Add the 'proxmox' domain resolving to your host IP reachable by VMs/containers
  #   address = "/proxmox/192.168.0.105";
  #   # Bind dnsmasq to your bridge interface vmbr0
  #   interface = "vmbr0";
  #   # bind-interfaces = true; # Only bind to the specified interface
  #   # Define the DHCP IP address range, netmask, and lease time (e.g., 24h)
  #   dhcp-range = "192.168.200.2,192.168.200.254,24h";
  #   # Specify the router IP (default gateway) for dhcp clients
  #   dhcp-option = "3,192.168.200.1";
  #   };
  # };


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


services.desktopManager.gnome.enable = true;

services.displayManager.gdm = {
  enable = true;
  wayland = true;
};

services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.dbus.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  security.sudo.wheelNeedsPassword = false;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
    imwheel
    killall
    #kubernetes
    kubectl
    kubernetes-helm
    k9s
    k3d
    docker
    docker-compose
    minikube
    tree
    gh
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
    gnomeExtensions.tiling-shell
    vlc
    pamixer
    clipit
    zed-editor
    tabby
    i3
    qdirstat
    # pdfsam-basic
    # openjfx24
    # zulu24
    pdfmixtool
    nettools
    uv
    iptables
    postgresql
    # azure-cli
    # (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
    terraform
    #programming
    gcc
    python314
    go
    gnumake
    copyq
    # vscodium-fhs
    # vscode-fhs
    vscodium
    vscode
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
    yarn
    kubeseal
    runc
    node-gyp
    step-cli
    libffi
    pkg-config
    tmux
    skypilot
    file
    gparted
    ncdu
    unzip
    # newt # for proxmox
    # cdrkit # for proxmox
    cilium-cli
    xclip # use with xclip -out -selection primary | xclip -in -selection clipboard
    dconf-editor
    inetutils
    vte
    librechat
    pciutils
    talosctl
    tcpdump

    #for witsy
    dpkg
    fakeroot
    zip

    #sound
    pavucontrol
    alsa-utils
  ];
  # services.nfs.server = {
  #     enable = true;

  #     # Export the desired directory
  #     exports = ''
  #       /mnt/data/general 192.168.0.0/16(rw,sync,no_subtree_check)
  #     '';
  #   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  programs.direnv.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      X11Forwarding = true;
    };
  };

  services.k3s = {
    enable = false;
    role = "server";
    extraFlags = [
      "--disable=traefik"
      "--disable=servicelb"
      "--default-local-storage-path=/mnt/data"
      # "--flannel-backend=none" 
      # "--disable-network-policy"
      # "--disable-kube-proxy"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    # Allow all incoming connections by allowing all TCP and UDP ports
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    # Or explicitly allow everything by disabling filtering (not recommended for production)
    # You could also add a passthrough rule or set the default policy accept
    # But NixOS firewall doesn't support a simple "open all" toggle, so empty allowed ports means open all
    # However, if you want no filtering, simplest is to disable firewall: enable = false
  };  
  networking.extraHosts =
    ''
      51.4.64.181 uri.work.gd 
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
  virtualisation.containerd.enable = true;  

  #virt-manager https://nixos.wiki/wiki/Virt-manager
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["uri"];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
};
boot.loader.grub.useOSProber = true;
boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };
  hardware.enableAllFirmware = true;
}

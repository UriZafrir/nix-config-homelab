{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "uri";
  home.homeDirectory = "/home/uri";

  # home.file = {
  #   ".bashrc".source = config.lib.file.mkOutOfStoreSymlink /home/uri/general/nix-config-homelab/dotfiles/.bashrc;
  #   ".vimrc".source = config.lib.file.mkOutOfStoreSymlink /home/uri/general/nix-config-homelab/dotfiles/.vimrc;
  #   ".imwheelrc".source = config.lib.file.mkOutOfStoreSymlink /home/uri/general/nix-config-homelab/dotfiles/.imwheelrc;
  # };
  home.file = {
    ".bashrc".source = ../dotfiles/.bashrc;
    ".bash_profile".source = ../dotfiles/.bash_profile;
    ".vimrc".source = ../dotfiles/.vimrc;
    ".imwheelrc".source = ../dotfiles/.imwheelrc;
    ".gitconfig".source = ../dotfiles/.gitconfig;
    ".npmrc".source = ../dotfiles/.npmrc;
    ".config/k9s/skins/transparent.yaml".source = ../dotfiles/k9s/transparent.yaml;
    ".config/k9s/config.yaml".source = ../dotfiles/k9s/config.yaml;
    ".config/k9s/plugins/log-full.yaml".source = ../dotfiles/k9s/log-full.yaml;
    ".scripts/screen-unlock-monitor.sh".source = ../scripts/screen-unlock-monitor.sh;
  };

  #this is for setting alt+shift as keyboard shotcut for language switch
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" "grp:alt_shift_toggle" ];
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  systemd.user.services.screen-unlock-monitor = {
      Unit = {
        Description = "Run a command when screen is unlocked (GNOME/X11)";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "%h/.scripts/screen-unlock-monitor.sh";
        Restart = "always";
        RestartSec = 2;
        StandardOutput = "journal";
        StandardError = "journal";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
#sometimes need /usr/lib/systemd/user
  systemd.user.services.imwheel = {
    Unit = {
      Description = "IMWheel";
      Wants = [ "graphical-session.target" ];   # For user services, better to use graphical-session.target
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
    Environment = ''
      DISPLAY=:0
      XAUTHORITY=/run/user/1000/gdm/Xauthority
    '';
      ExecStart = "/run/current-system/sw/bin/imwheel -d";
      ExecStop = "/run/current-system/sw/bin/pkill imwheel";
      RemainAfterExit = "yes";
    };
    Install.WantedBy = [ "default.target" ];
  };

systemd.user.services.xclip-sync = {
  Unit = {
    Description = "Sync PRIMARY selection to CLIPBOARD using xclip";
    Wants = [ "graphical.target" ];  # better user target
    After = [ "graphical.target" ];
  };

  Service = {
    Type = "oneshot";
    Environment = ''
      DISPLAY=:0
    '';
    ExecStart = "/bin/sh -c \"xclip -out -selection primary | xclip -in -selection clipboard\"";
  };

  Install = {
    WantedBy = [ "default.target" ];
  };
};

  xdg.desktopEntries.xrandr-brightness-adjuster = {
    name = "xrandr-brightness-adjuster";
    genericName = "Custom Application";
    exec = "/home/uri/AppImages/xrandr-brightness-adjuster";
    #icon = "/full/path/to/icon.png";
    #terminal = false;
    categories = [ "Utility" ];
    type = "Application";
  };
  
  xdg.desktopEntries.imwheel = {
    name = "imwheel";
    genericName = "Custom Application";
    exec = "/run/current-system/sw/bin/imwheel";
    #icon = "/full/path/to/icon.png";
    #terminal = false;
    categories = [ "Utility" ];
    type = "Application";
  };

  programs.git = {
    enable = true;
    userName = "Uri Zafrir";
    userEmail = "urizaf@gmail.com";
  };

  xdg.autostart.enable = true;

  # xdg.autostart.entries ends up in ll ~/.config/autostart/
  # ll /run/current-system/sw/share/applications/
  xdg.autostart.entries = [
    "${pkgs.flameshot}/share/applications/org.flameshot.Flameshot.desktop"
    "${pkgs.copyq}/share/applications/com.github.hluk.copyq.desktop"
    "${pkgs.keepassxc}/share/applications/org.keepassxc.KeePassXC.desktop"
    "${pkgs.gnome-terminal}/share/applications/org.gnome.Terminal.desktop"
    "${pkgs.imwheel}/share/applications/imwheel.desktop"
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
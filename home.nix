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
    ".bashrc".source = ./dotfiles/.bashrc;
    ".vimrc".source = ./dotfiles/.vimrc;
    ".imwheelrc".source = ./dotfiles/.imwheelrc;
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
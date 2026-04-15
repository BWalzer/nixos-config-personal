{ config, pkgs, ... }: {
  home.username = "benw";
  home.homeDirectory = "/home/benw";
  home.stateVersion = "25.11";

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/nvim".source = ./nvim;
  home.file.".config/waybar/config".source = ./waybar/config;
  home.file.".config/waybar/style.css".source = ./waybar/style.css;
  home.file.".config/waybar/theme.css".source = ./waybar/theme.css;
  home.file.".config/waybar/user-style.css".source = ./waybar/user-style.css;

  home.packages = with pkgs; [
    chromium
    claude-code
    hyprlauncher
    grimblast
    fastfetch
    discord
    pavucontrol
    wl-clipboard
    vscodium
    libnotify        # Testing notifications
    git
    gh
    brightnessctl
    nerd-fonts.jetbrains-mono
    waybar
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.ghostty = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake $HOME/nixos-config#nixos-personal";
      editsys = "$EDITOR $HOME/nixos-config/configuration.nix";
      edithome = "$EDITOR $HOME/nixos-config/home.nix";
      editflake = "$EDITOR $HOME/nixos-config/flake.nix";
      edithypr = "$EDITOR $HOME/nixos-config/hyprland.conf";
      sysupdate = "nix flake update $HOME/nixos-config && sudo nixos-rebuild switch --flake $HOME/nixos-config#nixos-personal";
    };
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000; # milliseconds
      "icon-path" = "/etc/profiles/per-user/${config.home.username}/share/icons/Papirus:${pkgs.papirus-icon-theme}/share/icons/hicolor";
    };
  };
}

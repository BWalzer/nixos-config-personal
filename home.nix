{ config, pkgs, ... }: {
  home.username = "benw";
  home.homeDirectory = "/home/benw";
  home.stateVersion = "25.11";

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/nvim".source = ./nvim;

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
    bolt-launcher
    runelite                   # This is added with bolt-launcher, but adding it here for the .desktop file
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  programs.ghostty = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      editsys  = "$EDITOR $HOME/nixos-config/configuration.nix";
      edithome = "$EDITOR $HOME/nixos-config/home.nix";
      editflake = "$EDITOR $HOME/nixos-config/flake.nix";
      edithypr = "$EDITOR $HOME/nixos-config/hyprland.conf";
    };
    functions = {
      rebuild = {
        description = "Commit config, rebuild NixOS, push if successful";
        body = ''
          cd $HOME/nixos-config
          git add -A
          if not git diff --cached --quiet
            set commit_msg (test -n "$argv[1]"; and echo $argv[1]; or echo "rebuild: "(date '+%Y-%m-%d %H:%M'))
            git commit -m $commit_msg
          end
          sudo nixos-rebuild switch --flake $HOME/nixos-config#nixos-personal
          and begin
            pkill hyprlauncher
            if git remote | string length -q
              git push
            end
          end
        '';
      };
      sysupdate = {
        description = "Update flake inputs, rebuild, commit and push";
        body = ''
          cd $HOME/nixos-config
          nix flake update
          git add flake.lock
          if not git diff --cached --quiet
            git commit -m "flake: update inputs "(date '+%Y-%m-%d %H:%M')
          end
          sudo nixos-rebuild switch --flake $HOME/nixos-config#nixos-personal
          and begin
            if git remote | string length -q
              git push
            end
          end
        '';
      };
    };
  };


  programs.lutris = {
    enable = true;
    extraPackages = with pkgs; [ winetricks mangohud gamemode ];
    protonPackages = with pkgs; [ proton-ge-bin ];
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000; # milliseconds
      "icon-path" = "/etc/profiles/per-user/${config.home.username}/share/icons/Papirus:${pkgs.papirus-icon-theme}/share/icons/hicolor";
    };
  };
}

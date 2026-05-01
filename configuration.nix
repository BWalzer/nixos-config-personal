{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow installation of non-free packages
  nixpkgs.config.allowUnfree = true;

  # openldap 2.6.13 has a flaky syncrepl test that fails in the Nix sandbox
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
    })
  ];

  #Nvidia settings for hyprland
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
  };
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-personal"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  programs.fish.enable = true;

  programs.hyprland = { enable = true;
    withUWSM = true;
  };
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "breeze";
  };

  services.displayManager.sessionPackages = [ pkgs.hyprland ];


  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "disable-devices" = {
	  "monitor.alsa.rules" = [
	    # Disable Yeti Nano as an output
	    {
	      matches = [{ "node.name" = "alsa_output.usb-Blue_Microphones_Yeti_Nano_2053SG00Q658_888-000154041006-00.analog-stereo"; }];
	      actions.update-props."node.disabled" = true;
	    }
	    # Disable AD102 HDMI output
	    {
	      matches = [{ "node.name" = "alsa_output.pci-0000_01_00.1.hdmi-stereo"; }];
	      actions.update-props."node.disabled" = true;
	    }
	    # Disable Ryzen HD Audio Output
	    {
	      matches = [{ "node.name" = "alsa_output.pci-0000_11_00.6.analog-stereo"; }];
	      actions.update-props."node.disabled" = true;
	    }
	    # Disable Ryzen HD Audio input
	    {
	      matches = [{ "node.name" = "alsa_input.pci-0000_11_00.6.analog-stereo"; }];
	      actions.update-props."node.disabled" = true;
	    }
	  ];
	};
	
	"bluetooth-settings" = {
	  "wireplumber.settings" = {
	    "bluetooth.autoswitch-to-headset-profile" = false;
	  };
	};
      };
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # stylix
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./wallpaper.png;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size=24;
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
    targets.sddm.enable = lib.mkForce true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  users.users.benw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
    shell = pkgs.fish;
  };

  hardware.graphics.enable32Bit = true;

  # Quiet the Kernel messages on original install
  # boot.consoleLogLevel = 1;
  # boot.kernelParams = [ "quiet" ];

  system.stateVersion = "25.11";
}


# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "barcaderator";
    homeDirectory = "/home/barcaderator";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ 
    steam 
    attract-mode
    mame
  ];

  home.file = { 
    ".attract" = {
      source = ../home/barcaderator/.attract;
      recursive = true;
    };
    ".local/mame" = {
      source = ../home/barcaderator/.local/mame;
      recursive = true;
    };
    ".mame" = {
      source = ../home/barcaderator/.mame;
      recursive = true;
    };
    ".local/steam" = {
      source = ../home/barcaderator/.local/steam;
      recursive = true;
    };
    ".xprofile" = {
      source = ../home/barcaderator/.xprofile;
      recursive = false;
    };
    ".gitconfig" = {
      source = ../home/barcaderator/.gitconfig;
      recursive = false;
    };
  };

  xfconf = {
    enable = true;
    settings = {
      xfce4-power-manager = {
        "xfce4-power-manager/blank-on-ac" = 0;
        "xfce4-power-manager/blank-on-battery" = 0;
        "xfce4-power-manager/dpms-enabled" = false;
        "xfce4-power-manager/lock-screen-suspend-hibernate" = false;
        "xfce4-power-manager/power-button-action" = 4; #shutdown on button press
        "xfce4-power-manager/show-tray-icon" = false;
      };
      xfce4-screensaver = {
        "lock/saver-activation/enabled" = false;
        "lock/user-switching/enabled" = false;
        "saver/idle-activation/enabled" = false;
        "saver/mode" = 0;
      };
      xfce4-session = {
        "general/SaveOnExit" = true;
      };
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}

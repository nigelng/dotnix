{ config, lib, pkgs, ... }:
let
  apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
  commonApps = builtins.map (app: builtins.getAttr app pkgs) apps.commonOs;
in {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    settings = {
      trusted-users = [ "nigelnguyen" ];
      allowed-users = [ "*" ];
    };

    gc = {
      # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  # Install and setup ZSH to work with nix(-darwin) as well
  environment = {
    systemPackages = commonApps;
    shells = with pkgs; [ fish zsh ];
  };

  users = { users.nigelnguyen = { name = "nigelnguyen"; }; };

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  # Auto upgrade nix package and the daemon service.
  services = { nix-daemon.enable = true; };

  # fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      hack-font
      fira-code
      open-sans
      source-code-pro
      jetbrains-mono
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.nigelnguyen = (import ../dotfiles);
  };
}

{ config, lib, pkgs, ... }:
let
  apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
  commonApps = builtins.map (app: builtins.getAttr app pkgs) apps.commonOs;
  userDetails = builtins.fromJSON (builtins.readFile ../config/user.json);
  osDetails = builtins.fromJSON (builtins.readFile ../config/os.json);
in {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    settings = {
      trusted-users = [ userDetails.homeDir ] ++ osDetails.trustedUsers;
      allowed-users = [ userDetails.homeDir ] ++ osDetails.allowedUsers;
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

  users = { users.${userDetails.homeDir} = { name = userDetails.homeDir; }; };

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
    users.${userDetails.homeDir} = (import ../dotfiles);
  };
}

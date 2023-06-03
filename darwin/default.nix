{ config, lib, pkgs, ... }:
let
  apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
  # mac osx specific
  systemApps = builtins.map (app: builtins.getAttr app pkgs) apps.system;
  macosSettings = builtins.fromJSON (builtins.readFile ../config/macos.json);

  currentUser = builtins.getEnv "USER";
  currentUserDir = builtins.getEnv "HOME";
in {
  imports = [ <home-manager/nix-darwin> ./macos.nix ./brew.nix ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    settings = {
      trusted-users = [ currentUser ] ++ macosSettings.trustedUsers;
      allowed-users = [ currentUser ] ++ macosSettings.allowedUsers;
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

  environment = {
    systemPackages = systemApps;
    darwinConfig = "$HOME/.nix/darwin/";
    shells = with pkgs; [ fish zsh ];
  };

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  services = { nix-daemon.enable = true; };

  # Users
  users.users.${currentUser} = {
    name = currentUser;
    home = currentUserDir;
    shell = pkgs.fish;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${currentUser} = (import ../dotfiles);
  };
}

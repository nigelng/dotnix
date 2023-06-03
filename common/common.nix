{ config, lib, pkgs, ... }:
let
  apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
  commonApps = builtins.map (app: builtins.getAttr app pkgs) apps.commonOs;
  osDetails = builtins.fromJSON (builtins.readFile ../config/os.json);
  currentUser = builtins.getEnv "USER";
in {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    settings = {
      trusted-users = [ currentUser ] ++ osDetails.trustedUsers;
      allowed-users = [ currentUser ] ++ osDetails.allowedUsers;
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

  users = { users.${currentUser} = { name = currentUser; }; };

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
    users.${currentUser} = (import ../dotfiles);
  };
}

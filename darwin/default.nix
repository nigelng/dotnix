{ config, pkgs, ... }:
let
  apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
  # mac osx specific
  darwinApps = builtins.map (app: builtins.getAttr app pkgs) apps.commonOs;
  userDetails = builtins.fromJSON (builtins.readFile ../config/user.json);
in {

  imports =
    [ <home-manager/nix-darwin> ../common/common.nix ./macosx.nix ./brew.nix ];

  environment = {
    systemPackages = darwinApps;
    darwinConfig = "$HOME/.nix/darwin/";
  };

  # dotfiles
  users.users.${userDetails.homeDir} = {
    home = "/Users/${userDetails.homeDir}";
    shell = pkgs.fish;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  home-manager = {
    users.${userDetails.homeDir}.home.file = {
      ".gnupg/gpg-agent.conf".source = ./home-files/gpg-agent-conf;
      ".config/terminal/my.terminal".source = ./home-files/terminal-theme;
    };
  };
}

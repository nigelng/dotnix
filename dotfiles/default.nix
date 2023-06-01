{ config, pkgs, ... }:
let
  apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
  # mac osx specific
  userApps = builtins.map (app: builtins.getAttr app pkgs) apps.commonOs;
in {
  imports = [
    ./direnv.nix
    ./exa.nix
    ./editors.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./shells.nix
    ./ssh.nix
    ./zoxide.nix
  ];

  programs = {
    home-manager.enable = true;
    man.enable = true;
    htop.enable = true;
    dircolors.enable = true;
  };

  editorconfig.enable = true;

  home = {
    stateVersion = "23.05";
    packages = userApps;

    shellAliases = {
      # Set all shell aliases programatically
      # Aliases for commonly used tools
      grep = "grep --color=auto";
      find = "fd";
      cls = "clear";

      # Nix garbage collection
      garbage = "nix-collect-garbage -d && docker image prune --force";
    };
  };
}

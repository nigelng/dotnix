{ pkgs, lib, ... }:
let
  gitConfig = builtins.fromJSON (builtins.readFile ../config/git.json);
  gitIgnore = builtins.fromJSON (builtins.readFile ../config/gitignore.json);
  userDetails = builtins.fromJSON (builtins.readFile ../config/user.json);
in {
  programs.gh = {
    enable = true;
    settings = {
      prompt = "enabled";
      editor = "vim";
      git_protocol = "ssh";
    };
    enableGitCredentialHelper = true;
    extensions = with pkgs; [ gh-eco gh-dash gh-markdown-preview ];
  };

  programs.git = lib.mergeAttrs gitConfig {
    enable = true;
    userName = userDetails.name;
    userEmail = userDetails.email;

    signing = {
      key = userDetails.defaultGpgKey;
      signByDefault = true;
    };

    ignores = gitIgnore;
  };
}

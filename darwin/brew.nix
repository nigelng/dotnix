{ pkgs, ... }:
let apps = builtins.fromJSON (builtins.readFile ../config/apps.json);
in {
  homebrew = {
    enable = true;
    brews = apps.brew;
    casks = apps.cask;
    brewPrefix = "/opt/homebrew/bin";
    global = { brewfile = true; };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = false;
    };
    masApps = apps.mas;
  };
}

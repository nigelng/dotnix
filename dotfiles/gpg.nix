{ pkgs, ... }:
let userDetails = builtins.fromJSON (builtins.readFile ../config/user.json);
in {
  services.gpg-agent = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    defaultCacheTtl = 360;
    enableFishIntegration = true;
    enableZshIntegration = true;
    pinentryFlavor = "${pkgs.pinentry}";
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = userDetails.defaultGpgKey;
      keyserver-options = "include-revoked";
    };
  };
}

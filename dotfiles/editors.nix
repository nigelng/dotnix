{ pkgs, ... }: {
  programs.vscode = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
    enableUpdateCheck = true;
    enableExtensionUpdateCheck = true;
  };
}

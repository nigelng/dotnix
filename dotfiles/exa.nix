{ ... }: {
  programs.exa = {
    enable = true;
    enableAliases = true;
    git = true;
    extraOptions = [ "--group-directories-first" "--header" ];
  };
}

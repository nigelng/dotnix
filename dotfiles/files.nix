{ ... }: {
  home.file = {
    ".gnupg/gpg-agent.conf".source = ./files/gpg-agent-conf;
    ".config/terminal/my.terminal".source = ./files/terminal-theme;
  };
}

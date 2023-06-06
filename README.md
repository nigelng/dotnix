# Deprecated - See [dotnix-flake](https://github.com/nigelng/dotnix-flake) for improved solution

# dotnix

Using nix to provisioning devices on Mac OSX (M-series chip). Inspect `app.json.example` for the default set of apps / packages will be installed.

System packages also installed.

- fish [Fish shell](https://fishshell.com)
- zsh
- Fonts: `hack-font`, `fira-code`, `open-sans`, `source-code-pro`, `jetbrains-mono`

Following are extra that will be added on to current-user scope:

- `direnv` / `git` / `ssh` (link to 1P) / `gpg`
- `vscode`
- [`exa`](https://the.exa.website)
- [`fzf`](https://github.com/junegunn/fzf)
- [`zoxide`](https://github.com/ajeetdsouza/zoxide)
- [`gh-cli`](https://cli.github.com) with extensions
  - [`gh-eco`](https://github.com/jrnxf/gh-eco)
  - [`gh-dash`](https://github.com/dlvhdr/gh-dash)
  - [`gh-markdown-preview`](https://github.com/yusukebe/gh-markdown-preview)

As mentioned, fish and zsh shells are available (asides from system provided shells).

- Fish shell extensions:
  - [`hydro theme`](https://github.com/jorgebucaran/hydro)
  - `grc`
  - [`colored-man-pages`](https://github.com/PatrickF1/colored_man_pages.fish)
  - `foreign-env`
  - [`sponge`](https://github.com/meaningful-ooo/sponge)
  - [`forgit`](https://github.com/wfxr/forgit)
  - [`pisces`](https://github.com/laughedelic/pisces)
  - [`puffer`](https://github.com/nickeb96/puffer-fish)
  - [`humantime-fish`](https://github.com/jorgebucaran/humantime.fish)
  - [`done`](https://github.com/franciscolourenco/done)
  - [`bass`](https://github.com/edc/bass)
  - [`github-copilot-cli`](https://github.com/z11i/github-copilot-cli.fish)

- Zsh shell extensions are (managed via [`zimfw`](https://zimfw.sh))
  - [`pure theme`](https://github.com/sindresorhus/pure)
  - [`environment`](https://github.com/zimfw/environment)
  - [`git`](https://github.com/zimfw/git)
  - [`input`](https://github.com/zimfw/input)
  - [`termtitle`](https://github.com/zimfw/termtitle)
  - [`utility`](https://github.com/zimfw/utility)
  - [`duration-info`](https://github.com/zimfw/duration-info)
  - [`git-info`](https://github.com/zimfw/git-info)
  - [`prompt-pwd`](https://github.com/zimfw/prompt-pwd)
  - [`archive`](https://github.com/zimfw/archive)

## 🏗️ Install Requirements

- 0. Install [brew](https://brew.sh)

  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

<!-- markdownlint-disable code-fence-style -->
- 1. Install nix (as multi-user) [nix-installer](https://github.com/DeterminateSystems/nix-installer)

  ```sh
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```

- 2. Install `nix-darwin`  [GitHub - LnL7/nix-darwin: nix modules for darwin](https://github.com/LnL7/nix-darwin)

  ```bash
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  ```

- 3. Install `home-manager` (vers 23.05)

  ```bash
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
  nix-channel --update
  ```

Notes:

- If `/etc/nix/nix.conf` already existed, move it to `~/.config/nix/nix.conf`
- If `/etc/shells` already existed, back up and remove
- If running into error `...ln: failed to create symbolic link '/run': Read-only file system`

  ```sh
  sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
  ```

- if running to warning `warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels' does not exist, ignoring`

  ```sh
  sudo cp -R /nix/var/nix/profiles/per-user/<username>/channels /nix/var/nix/profiles/per-user/root/
  ```

## 🗂️ Setup configurations

- Run `sh configure.sh` - this will copy all `.example` to `.json`
- Update `./config/<file>.json` with specific details

## 🏃 Run the specific script

- On MacOSX `sh darwin.sh`

## 🤡 Caveats

- Only brews / casks that specified in `./config/apps.json` will be installed. Non specified will be removed
- Mas refers to `Mac App Store` apps will be installed as extra. Existing Mas id can located via [mas-cli](https://github.com/mas-cli/mas)
- [Trusted uses](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-trusted-users) will be current user plus all specified in config
- [Allowed users](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-allowed-users) will be current user plus all specified in config
- By default, git will required [GPG setup](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key) to [sign commits](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work). `include` and `includeIf` are available for multiple git profiles. See `git.json.example` for details. Remove if not required.
- On MacOSX, reset current-user shell to

  ```sh
    # fish
    chsh -s /run/current-system/sw/bin/fish

    # zsh
    chsh -s /run/current-system/sw/bin/fish
  ```

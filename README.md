# dotnix

Using nix to provisioning devices on Mac OSX (M-series chip) / WSL

## Requirements
<!-- markdownlint-disable code-fence-style -->
1. Install nix (as multi-user) [nix-installer](https://github.com/DeterminateSystems/nix-installer)

  ```sh
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```

2. Install `nix-darwin`  [GitHub - LnL7/nix-darwin: nix modules for darwin](https://github.com/LnL7/nix-darwin)

  ```bash
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  ```

3. Install `home-manager` (vers 23.05)

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

## Setup configurations

- Run `sh configure.sh`
- Update `./config/<file>.json` with specific details

## Run the specific script

- On MacOSX `sh darwin.sh`
- On WSL `sh wsl.sh`
- On Linux `sh linux.sh`

## Caveats

- Only brews / casks that specified in `./config/apps.json` will be installed. Non specified will be removed
- Mas refers to `Mac App Store` apps will be installed as extra. Existing Mas id can located via [mas-cli](https://github.com/mas-cli/mas)

# dotnix

Using nix to provisioning devices on Mac OSX (M-series chip)

## Requirements

  1> Install nix (as multi-user) [Installation - Nix](https://nixos.org/download.html)

  ```sh
  sh <(curl -L https://nixos.org/nix/install) --daemon

  # setting up the build users
  groupadd -r nixbld
  for n in $(seq 1 10); do useradd -c "Nix build user $n" \
    -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
    nixbld$n; done
  ```

  2> Install `nix-darwin`  [GitHub - LnL7/nix-darwin: nix modules for darwin](https://github.com/LnL7/nix-darwin)

  ```bash
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  ```

  3> Install `home-manager` (vers 23.05)

  ```bash
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
  nix-channel --update
  ```

## Update configurations

- Run `sh configure.sh`
- Update `./config/<file>.json` with specific details

## Run the specific script

- On MacOSX `sh darwin.sh`
- On WSL `sh wsl.sh`
- On Linux `sh linux.sh`

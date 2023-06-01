#!/bin/sh
sh configure.sh

currentPath="$(realpath $(dirname $0))"
darwin-rebuild switch -I darwin-config=$currentPath/darwin/default.nix

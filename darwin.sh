#!/bin/sh
currentPath="$(realpath $(dirname $0))"

sh $currentPath/configure.sh
darwin-rebuild switch -I darwin-config=$currentPath/darwin/default.nix

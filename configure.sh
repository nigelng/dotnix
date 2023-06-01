#!/bin/sh
currentPath="$(realpath $(dirname $0))"

# Setup configs
configPath=$currentPath/config
configExamples=$(find $configPath -type f -name "*.example")

for file in $configExamples; do
  cp -n $file $configPath/$(basename $file ".example")
done

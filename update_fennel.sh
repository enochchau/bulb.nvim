#!/usr/bin/env bash

tar_name="fennel.tar.gz"
fennel_location="./lua/bulb/fennel.lua"
website='https://fennel-lang.org/downloads/'

curl $website | \
  grep --extended-regexp "fennel-[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}\.tar\.gz<" | \
  tail -1 | \
  awk -F '"' '{print $2}' | \
  sed "s#^#$website#" | \
  xargs wget -O $tar_name

out=$(tar -xvf $tar_name --wildcards "*/fennel.lua")
cp "$out" $fennel_location
rm -r "$(dirname "$out")"
rm $tar_name

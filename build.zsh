#! /usr/bin/env zsh

set -e

cd -- ${${(%):-%x}:h}
git add .
command sudo nixos-rebuild switch --flake . -L


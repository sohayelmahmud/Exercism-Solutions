#!/usr/bin/env bash

declare -ir black=0 brown=1 red=2 orange=3 yellow=4 green=5 blue=6 violet=7 grey=8 white=9
[[ -z ${!1} || -z ${!2} ]] && echo "invalid color" && exit 1
echo $(( ${!1}*10 + ${!2} ))

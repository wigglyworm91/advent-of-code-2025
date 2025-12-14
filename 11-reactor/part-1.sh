#!/bin/bash
set -euo pipefail

d=$(mktemp -d)

tr -d ':' | while read line; do
	devices=($line)
	src=${devices[0]}
	dsts=${devices[@]:1}
	mkdir -p $d/$src
	for dst in $dsts; do
		mkdir -p $d/$dst
		ln -s $d/$dst $d/$src/$dst
	done
done

find -L $d/you | grep out$ | wc -l

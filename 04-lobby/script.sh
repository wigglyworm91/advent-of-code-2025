#!/bin/bash

set -euo pipefail

cycle() {
	# 01234567a -> 70123456a
	gsed -E 's/\<(\S+)(\S)(\S)\>/\2\1\3/g'
}

clean() {
	sed 's/0 1/0 0/g; s/^1/0/'
}

probe() {
	tee >/dev/stderr; echo >/dev/stderr;
}

round() {
	sed 's/@/111111111 /g; s/\./111111110 /g' | 
	         clean | cycle |
	rotate | clean | cycle |
	rotate | clean | cycle |
	rotate | clean | cycle |
	rotate | clean | cycle |
	rotate | clean | cycle |
	rotate | clean | cycle |
	rotate | clean | cycle |
	rotate |
	cat |
	# remove accessible things and convert back to input format
	gsed 's/\<\S*0\S*0\S*0\S*0\S*0\S*1\>/x/g; s/\<\S*0\>/./g; s/\<\S*1\>/@/g' |
	tr -d ' ' |
	tee >(grep --color=always 'x\|$' >&2; echo >&2) |
	tee >(grep -o 'x' | wc -l >&3) |
	gsed 's/x/./g'
}

nest() {
	local cmd=$1
	local n=$2
	if (( $n <= 0 )); then return; fi;
	$cmd | nest $cmd $(($2-1))
}

# if this is 100 it fork resource unavailable's
cat | nest round 10 3> >(asum -c)

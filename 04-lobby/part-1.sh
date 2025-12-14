#!/bin/bash

set -euo pipefail

cycle() {
	# 01234567a -> 70123456a
	gsed -E 's/\<(\S+)(\S)(\S)\>/\2\1\3/g'
}

infect() {
	sed 's/1 0/1 1/g'
}

probe() {
	cat #tee /dev/stderr; echo >/dev/stderr;
}

echo;
sed 's/@/000000001 /g; s/\./000000000 /g' | 
	infect | cycle |
	rotate | infect | cycle |
	rotate | infect | cycle |
	rotate | infect | cycle |
	rotate | infect | cycle |
	rotate | infect | cycle |
	rotate | infect | cycle |
	rotate | infect | cycle |
	rotate |
cat |
	tr ' ' '\n' |
	grep '\<\S*0\S*0\S*0\S*0\S*0\S*1\>' |
	wc -l

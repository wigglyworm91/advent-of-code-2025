#!/bin/bash
#set -eufo pipefail
shopt -s nullglob

: <<comment
example input
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
comment

area() {
	while IFS=', ' read a b c d; do
		echo "(abs($c - $a)+1) * (abs($d - $b) + 1)"
	done | bc
}

f=$(mktemp -u)
input=$(mktemp)
cat > $input
join -j 2 $input $input | tee $f | area | pv -at | paste - $f | tee output | sort -nrk 1 | head

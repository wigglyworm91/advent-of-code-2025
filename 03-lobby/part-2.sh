#!/bin/bash

set -euo pipefail

maxchar() {
	echo "maxchar $1" >&2
	echo $1 | fold -w1 | sort -rn | head -n 1
}

get_max_joltage() {
	echo "get_max_joltage $1 $2" >&2
	input=$1
	n=${#input}
	k=$2
	if [[ $k == $n ]]; then echo $input; return; fi;
	if [[ $k == 0 ]]; then return; fi;

	# it's a recursive thing:
	# max character in the first N - k letters
	# plus the max joltage of the letters after that
	best=$(maxchar "${input:0:$(($n-$k+1))}")
	rest=${input#*$best}

	echo $best$(get_max_joltage $rest $(($k-1)) )
}

while read line; do get_max_joltage $line 12; done

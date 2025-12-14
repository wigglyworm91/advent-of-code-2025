#!/bin/bash

set -euo pipefail

map() {
	while IFS= read line; do $1 $line; done
}

getjoltages() {
	input=$1
	for a in $(seq 0 $((${#input}-1))); do
		for b in $(seq $(($a+1)) ${#input}); do
			echo ${input:a:1}${input:b:1}
		done
	done | sort -nr | head -n 1
}

map getjoltages

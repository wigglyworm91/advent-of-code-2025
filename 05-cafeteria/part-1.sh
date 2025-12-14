#!/bin/bash

set -euo pipefail

filter() {
	while read x; do
		if (( $1 <= $x && $x <= $2 )); then
			echo $x;
		fi;
	done
}

d=$(mktemp -d)
echo $d
while IFS='-' read a b; do
	[ -z "$a" ] && continue;
	if [ -z "$b" ]; then
		for f in $d/*; do echo $a > $f; done
	else
		f="$d/$a-$b"
		[ -p "$f" ] && continue;
		echo "consumer: a '$a' and b '$b'" >&2
		mkfifo $f
		sleep 10 >$f &
		echo $f >&2
		cat $f | filter $a $b &
	fi
done | sort -u | nl

wait

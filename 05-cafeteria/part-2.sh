#!/bin/bash
#
set -euo pipefail

max() {
	echo $(( $1 > $2 ? $1 : $2 ))
}

# system paste is buffered and makes me sad
paste() {
	while true; do
		read a<$1
		read b<$2
		echo $a $b
	done
}

tractor() {
	while read a b; do echo $((a-b)); done
}

f=fifo
mkfifo $f || true
exec 8<$f # need to set up a reader first

# fifo carries the current max
echo 0 >$f

while read line && [ -n "$line" ]; do echo $line; done | tr '-' ' ' |
while read a b; do echo $a $((b+1)); done | sort -nk 1 | 
paste $f /dev/stdin | while read end a b; do
	echo "end=$end a=$a b=$b" >&2
	echo $(max $end $a) $(max $end $b)
	echo $(max $end $b) >$f
done | tractor | asum -c

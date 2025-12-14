#!/bin/bash

set -eufo pipefail

probe() {
	tee >(column -t >&2; echo >&2)
}

count() {
	tee >(grep -o x | wc -l >&2)
}

math() {
	sed 's/$/ /' | tr ' ' '\n' | while read line; do
		if [[ $line =~ [0-9+]+ ]]; then echo $line | bc;
		else echo $line; fi
	done | tr '\n' ' ' | sed 's/  /\n/g'
}

(echo '1+2 3+4 X ^'; echo '^ 4+7') | math

d=$(mktemp -d)
for i in `seq 1 141`; do
	while read a; read b; do echo $((a+b)); done <
sed 's/./. /g' | 


round() {
	
	#transpose -c | sed 's/-\ /--/g; s/-\^/-x/g' | transpose -c | sed 's/ x/-x/g; s/x /x-/g'

	#transpose | sed -E 's/\<([0-9]+) 0 /\1 \1 /' | sed -E 's/\<([0-9]+) \^/ \1 \1^ /' | transpose | sed -E 's/0 ([0-9]+)\^/0+\1 \1^; s/([0-9]+)\^'

	#transpose | probe | gsed -E 's/\<([0-9]+) +0 /\1 \1 /g' | probe | gsed -E 's/\<([0-9]+) \^/ \1 x\1X\1x /g' | probe | transpose | gsed 's/x0X0x/^/g' | probe | gsed -E 's/([0-9]+) *x *([0-9]+)/\1+\2/g' | sed 's/X/ X /g' | math | probe

	# tr 'S.' '10' | sed 's/./& /g' | transpose | gsed -E 's/\<([0-9]+) 0 / \1 \1 /' | gsed -E 's/\<([0-9]+) \^ / \1 \1^ /' | transpose | sed -E 's/0 ([0-9]+)\^ 0/\1 x \1/g'

}

f=$(mktemp)

tr 'S.' '10' | sed 's/./& /g' > $f
cat $f | round | sponge $f
cat $f | round | sponge $f

: <<c
for i in `seq 1 100`; do
	cat $f | round | sponge $f
done
c

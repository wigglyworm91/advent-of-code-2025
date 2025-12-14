#!/bin/bash

set -eufo pipefail

probe() {
	tee >(transpose -c >&2; echo >&2)
}

count() {
	tee >(grep -o x | wc -l >&2)
}

round() {
	transpose -c | sed 's/-\ /--/g; s/-\^/-x/g' | transpose -c | sed 's/ x/-x/g; s/x /x-/g'
}

f=$(mktemp)
tr 'S.' '- ' > $f
while true; do
	cat $f | round | probe | count | sponge $f
done

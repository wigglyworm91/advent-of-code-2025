#!/bin/bash

#set -euo pipefail
shopt -s nullglob

dister() {
	tr ',' ' ' |
		awk '{printf("%8.3f\n", (($4 - $1)^2 + ($5 - $2)^2 + ($6 - $3)^2)^0.5)}'
}

# 3 is debug output which you can have or not
exec 3>&2
#exec 3>/dev/null

d=$(mktemp -d)
d=d
rm -rf $d/*
cat > $d/input

: <<example
162,817,812
57,618,57
906,360,560
592,479,940
example

# let me cook
cat $d/input | xargs -I{} touch $d/{}

join -j 2 $d/input $d/input | while read a b; do if [[ $a < $b ]]; then echo $a $b; fi; done > $d/joined

paste <(
	cat $d/joined | dister
) $d/joined |
sort -nk 1 |
head -n 1000 |
while read dist src dst; do
	echo "Joining $src to $dst at a cost of $dist" >&3
	realsrc=$(readlink -f $d/$src)
	realdst=$(readlink -f $d/$dst)
	if [ $realsrc != $realdst ]; then
		rm $realsrc
		ln -s "$realdst" $realsrc
	fi
done

readlink -f $d/* | sort | uniq -c | sort -nrk 1 | head -n 3 | awk '{print $1}' | amul -cn

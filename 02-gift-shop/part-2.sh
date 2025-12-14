#!/bin/bash

set -euo pipefail


repeat() {
	(yes $1 || true) | head -n $2 | tr -d '\n'
	echo
}

repeater() {
	while read x; do repeat $x $1; done
}

factors() {
	case $1 in
		1) ;;
		2) echo 1;;
		3) echo 1;;
		4) echo 1 2;;
		5) echo 1;;
		6) echo 1 2 3;;
		7) echo 1;;
		8) echo 1 2 4;;
		9) echo 1 3;;
		10) echo 1 2 5;;
	esac
}

indent() {
	sed 's/^/ /'
}

filter() {
	while read x; do 
		if [ $1 -le $x -a $x -le $2 ]; then
			echo $x; fi; done
}

countem() {
	a=$1
	b=$2

	for f in $(factors ${#a}); do
		echo $f >&2
		seq ${a:0:$f} ${b:0:$f} | repeater $(( ${#a} / $f )) | filter $a $b | indent
	done | sort | uniq
}


tr ',' '\n' | while IFS='-' read a b;
do
	echo $a $b >&2
	countem $a $b | indent
done

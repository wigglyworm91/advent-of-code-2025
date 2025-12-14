#!/bin/bash

set -euo pipefail


repeat() {
	dd if=/dev/zero bs=1 count=$2 2>/dev/null | tr '\0' $1
}

split() {
	len=${#1}
	mid=$((len / 2))
	echo ${1:0:mid}
}

leftpad() {
	n=$1
	len=$2
	printf "%0$len"d $n
}

twicetwice() {
	while read x; do echo $x$x; done
}

indent() {
	while IFS= read line; do echo "    $line"; done
}

countem() {
	a=$1
	b=$2

	if [ $(( ${#a} % 2 )) -eq 0 -a $(( ${#b} % 2 )) -eq 1 ]; then
		b=$(repeat 9 ${#a})
	elif [ $(( ${#a} % 2 )) -eq 1 -a $(( ${#b} % 2 )) -eq 0 ]; then
		a=1$(repeat 0 ${#a})
	fi

	if [ $(( ${#a} % 2 )) -ne 0 ]; then
		echo "odd length strings: $a-$b" >&2
		return
	fi

	#echo $a $b

	seq $(split $a) $(($(split $b))) | twicetwice | while read x; do if [ $a -le $x -a $x -le $b ]; then echo $x; fi; done | indent
}


tr ',' '\n' | while IFS='-' read a b;
do
	#echo $a $b;
	countem $a $b;
done | asum

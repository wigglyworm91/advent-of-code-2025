#!/bin/bash
set -euo pipefail

d=$(mktemp -d)
echo $d

tr -d ':' | while read line; do
	devices=($line)
	src=${devices[0]}
	dsts=${devices[@]:1}
	mkdir -p $d/$src
	touch $d/$src/paths.txt
	for dst in $dsts; do
		mkdir -p $d/$dst
		touch $d/$dst/paths.txt
		ln -s $d/$dst $d/$src/$dst
	done
done

dfs() {
	src=$1
	dst=$2
	avoid=${3:-"$^"}
	avoid="$^"
	if [ "$src" == "$dst" ]; then echo 1; return; fi
	if ! grep $dst $d/$src/paths.txt >/dev/null; then
		#echo "calculating $src -> $dst" >&2
		{
			echo -n $dst" "
			for child in $(ls -1 $d/$src | grep -v '\.txt' | grep -v "$avoid"); do
				dfs $child $dst
			done | asum
		} >> $d/$src/paths.txt
	fi
	grep $dst $d/$src/paths.txt | cut -f2 -d' '
}

{
	dfs 'svr' 'fft' 'dac'
	dfs 'fft' 'dac'
	dfs 'dac' 'out' 'fft'
} | amul

{
	dfs 'svr' 'dac' 'fft'
	dfs 'dac' 'fft'
	dfs 'fft' 'out' 'dac'
} | amul

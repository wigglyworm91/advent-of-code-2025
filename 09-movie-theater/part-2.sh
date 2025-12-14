#!/usr/bin/env bash
# this would work but it's sooooo slow, about 16-24h to run on my machine
set -eufo pipefail
shopt -s lastpipe

f=$(mktemp)
cat > "$f"
head -n 1 "$f" >> "$f"

min() {
	echo $(( $1 < $2 ? $1 : $2 ))
}
max() {
	echo $(( $1 < $2 ? $2 : $1 ))
}
pairwise() {
	fifo=$(mktemp -u)
	mkfifo $fifo
	tee >(tail -n +2 >$fifo) | paste - $fifo | sed '$d'
}
function is_valid {
	# my My mx Mx
	my=$1
	My=$2
	mx=$3
	Mx=$4
	cat "$f" | pairwise | tr ',' ' ' | while read y1 x1 y2 x2; do
		if ! ( [ $(max $x1 $x2) -le $mx ] ||
			[ $Mx -le $(min $x1 $x2) ] ||
			[ $(max $y1 $y2) -le $my ] ||
			[ $My -le $(min $y1 $y2) ] ); then
			# bad! there's an intersection
			echo "bad! ($my, $mx) -- ($My, $Mx) -- because of ($y1 $x1) - ($y2 $x2)" >&2
			return 255
		fi
	done
	return 0
}

join -j 2 $f $f | pv | grep -v '^\s*\(\S\+\) \1$' | tr ',' ' ' | while read y1 x1 y2 x2; do
	my=$(min $y1 $y2)
	My=$(max $y1 $y2)
	mx=$(min $x1 $x2)
	Mx=$(max $x1 $x2)
	echo $my $My $mx $Mx
done | sort -u > rects.txt
echo done sorting
	


best=0
pv rects.txt | while read y1 x1 y2 x2; do
	if is_valid $y1 $x1 $y2 $x2; then
		sz=$(( ($My - $my + 1) * ($Mx - $mx + 1) ))
		echo "($my, $mx) -- ($My, $Mx) -- $sz" >&2
		echo "$sz"
		best=$(max $sz $best)
		echo "best: $best"
	fi
done

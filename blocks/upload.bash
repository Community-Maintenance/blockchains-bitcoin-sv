#!/usr/bin/bash
num=0
while true
do
	blknum="$(printf %05i "$num").dat"
	if ! [ -e blk"$blknum" ]
	then
		break
	fi
	git annex add *"$blknum" &&
	git annex unlock *"$blknum" &&
	git annex copy *"$blknum" --to=skynet || exit -1
	while ! git annex fsck -f skynet *"$blknum"
	do
		git annex copy *"$blknum" --to=skynet
	done
	git commit -m "added $blknum"
	git annex sync origin
	num=$((num+1))
done

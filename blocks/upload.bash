#!/usr/bin/bash
num=0
while true
do
	blknum="$(printf %05i "$num").dat"
	if ! [ -e blk"$blknum" ]
	then
		break
	fi
	if ! git annex --debug fsck -f skynet blk"$blknum"
    then
	    git annex add blk"$blknum" &&
	    git annex unlock blk"$blknum" &&
	    git annex copy blk"$blknum" --to=skynet || exit -1
	    while ! git annex --debug fsck -f skynet blk"$blknum"
	    do
	    	git annex copy blk"$blknum" --to=skynet
	    done
	    git commit -m "added $blknum"
	    git annex sync origin
    fi
	num=$((num+1))
done

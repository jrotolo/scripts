#!/bin/sh

DIR=~/Downloads
vflag=off
filename=


if [ "$(ls -A $DIR)" ]; then			
	echo "Total size of $DIR in KB: $(du -k $DIR | sed 's/\([0-9][0-9]*\).*/\1/')"
	printf "Confirm deletions? (yes/no) "
	read ANSWER

	if [ $ANSWER = "yes" ]; then
		while [ $# -gt 0 ]
		do
			case "$1" in 
				-v) vflag=on;;
				-f) filename="$2"; shift;;
				-*)
					echo >&2 \
					"usage: $0 [-v] [-f ouputfile]"
					exit 1;;
				*) break;;
			esac
			shift
		done
		if [[ vflag == on ]]; then
			rm -vdi $DIR/*
		elif [ -n "$filename" ]; then
			rm -vd $DIR/* >> $filename
		else
			rm -vd $DIR/*
		fi
		echo "All clean! Have a swell day!"
	else
		exit
	fi
else
		echo "Directory is already cleaned. Have a swell day!"
fi

#!/bin/bash
echo "########################"
echo "## By Antonio Eduardo ##"
echo "########################"
echo ""
usage(){
	echo "Usage: $0 [path to LaravelSD export]"
	exit 1
}
if [ "$1" == "?" ]
then
	usage
fi

function readFolder ()
{
	echo "Enter LaravelSD files path: "
	read sdpath
}
function startCopy () {
		echo ""
	if [[ -z $1 ]]
	then
	echo $1
		readFolder
	else
		if [[ -z $sdpath ]]
		then
			sdpath="$1"
		else
			exit 1
		fi
	fi
	
	if [[ ! -f "$sdpath/routes.php" || ! -d "$sdpath/models" ]]
	then
		echo "This path does not correspond to a valid LaravelSD export"
		startCopy $1
		return 1
	fi
	if [ -L "$sdpath" ]
	then
		echo "Symlinks are not supported."
		startCopy $1
		return 1
	fi
	
	sdpath=$(realpath -L "`pwd`/$sdpath")
	outputf="$sdpath""_54"
	
	if [ ! -d "$outputf" ]
	then
		mkdir "$outputf"
		cp "$sdpath"/* "$outputf"/ -R
		sed -i 's/SoftDeletingTrait;/SoftDeletes;/g' "$outputf/models/"*.php
		sed -i 's/ extends Eloquent {/ extends Model {/g' "$outputf/models/"*.php
		sed -i '5i\
use Illuminate\\Database\\Eloquent\\Model;\
		' "$outputf/models/"*.php
	else
		echo "This project is already converted."
		startCopy $1
		return 1
	fi
}
startCopy $1
echo "DONE!"
echo ""
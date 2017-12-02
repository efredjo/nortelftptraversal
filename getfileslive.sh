#/bin/bash

url=ftp://nortel:nortel@8.14.1.41
level=0

function traverse()
{
    local dirout=`eval curl -s $url/$1 | tail -n +3 | cut -c 37-`
    local files=`eval echo -n '"$dirout"' | grep -v "<DIR>" | awk -F" " {'print $1'}`
    local folders=`eval echo -n '"$dirout"' | grep "<DIR>" | awk -F" " {'print $1'}`

    if [[ ! -z $files ]]; then
	printf "%${level}s"
	echo "copying file..."
	for f in $files; do
	    wget -q -nv --show-progress $url/$1$f
	done
    fi

    if [[ ! -z $folders ]]; then
	level=$((level+1))
	for d in $folders; do
	    printf "%${level}s"
	    echo "preparing to copy remote directory $d to local directory $1$d/..."
	    mkdir $d
	    cd $d
	    traverse $1$d/
	    cd ..
	done
	level=$((level-1))
    fi
}

traverse

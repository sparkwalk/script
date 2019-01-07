#!/bin/bash

output_file=''
input_file=''

if [ $# -lt 2 ]; then
    echo 'Usage: txz [outfile] [-l | -x] [input file1 file2 ...]'
    echo 'default :Compress a file or directory to xz file'
    echo ""
    echo '-l :list a couple of compress files'
    echo '-x :decomporess a couple of compress files'
    exit 0
fi

for file in "$@"
do
    if [ $file = $1 ]; then
        output_file="$1"
        continue
    fi

    if [ ! -e $file ]; then
        echo "txz: '$file': No such file or directory"
        exit -1
    else
        input_file+="$file "
    fi
done

if [ $output_file = '-l' -o $output_file = '-x' ]; then
    for file in $input_file; do
        echo "[ $(du -h -d0 $file) ]"

        ext=${file##*.}
        if [ $ext = 'xz' -o $ext = 'tar' ]; then
            if [ $output_file = '-l' ]; then
                tar -tf $file
            elif [ $output_file = '-x' ]; then
                tar -xvf $file
            fi

        else
            echo "$file is not a compress file"
        fi

        echo ""
    done
    exit 0
fi

output_file="${output_file%%.*}.tar"
# echo "output: $output_file.xz"
# echo "input: $input_file"

tar -cf $output_file $input_file
xz -z $output_file

exit 0



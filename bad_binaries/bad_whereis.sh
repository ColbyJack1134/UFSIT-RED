#!/bin/bash


if [ $# -eq 0 ]
        then
                echo "whereis: not enough arguments
Try 'whereis --help' for more information."
                exit
fi

echo "$1: /bin/$1"

#!/bin/zsh

version="1.0"
date="2020/11/20"
author="jason19970210"

help() {
    echo "Show alias in an effective way." 
    echo "Usage: alias.sh [ -l | -h | -v | -i ]" >&2
    echo
    echo "   -l, --list              Full information of alias"
    echo "   -h, --help              Show this help"
    echo "   -v, --version           Show script version"
    echo "   -i, --info              Show script information"
    echo
    exit 1
}

list(){
    echo
    while read line ; do
        #echo "$line"
        #grep -q "alias" $1
        grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; {print " " $1 $2}' | column -t -s "'"
    done < ~/.zshrc
    echo
}

normal(){
    echo
    while read line ; do
        grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; { print " " $1}' | column -t -s "'"
    done < ~/.zshrc
    echo
}

info(){
    echo
    echo "version "$version
    echo "Create: "$date
    echo "Author: "$author 
    echo
}

version(){
    echo "AliasTable version "$version
}


## If no argument
if [ $# = 0 ] 
    then
        normal
        exit 1
    elif [ $# = 1 ] 
        then 
            case "$1" in
                -h | --help)
                    help
                    exit 0
                    ;;

                -l | --list)
                    list
                    exit 0
                    ;;

                -v | --version)
                    version
                    exit 0
                    ;;

                -i | --info)
                    info
                    exit 0
                    ;;

                --)
                    shift
                    break
                    ;;
                -*)
                    echo "Error: Unknown option: $1" >&2
                    echo
                    help
                    exit 1 
                    ;;
                *) 
                    help
                    exit 1
                    ;;
            esac
    else
        # $@ get all arguments
        # $# get amount of arguments
        echo "Error: Multiple given arguments: $@" >&2
        echo "Hint : Only 1 argument is needed!" >&2
        echo
        help
        exit 1
fi
#!/bin/zsh

version="1.1"
create_date="2020/11/20"
last_mod_date="2020/11/25"
author="jason19970210"

help() {
    echo "Show alias in an effective way." 
    echo "Usage: alias.sh [ -l | -f | -h | -v | -i ]" >&2
    echo
    echo "   -a, --alias             Show information of alias"
    echo "   -l, --list              Full information of alias"
    echo "   -f, --function          Show information of functions"
    echo "   -h, --help              Show this help"
    echo "   -v, --version           Show script version"
    echo "   -i, --info              Show script information"
    echo
    exit 1
}

ali(){
    echo
    echo "+++ Alias +++"
    while read line ; do
        grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; { print " " $1}' 
    done < ~/.zshrc
    echo
}

list(){
    echo
    echo "+++ Alias +++"
    while read line ; do
        #echo "$line"
        #grep -q "alias" $1
        grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; {print " " $1 $2}' | column -t -s "'"
    done < ~/.zshrc
    echo
}

normal(){
    echo
    echo "+++ Alias +++"
    while read line ; do
        grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; { print " " $1}' 
        #grep ^function | cut -c 10- | awk 'BEGIN {FS="{"}; { print " " $1}'
    done < ~/.zshrc
    echo
    echo "+++ Functions +++"
    while read line ; do
        #grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; { print " " $1}' 
        grep ^function | cut -c 10- | awk 'BEGIN {FS="{"}; { print " " $1}'
    done < ~/.zshrc
    echo
}

func(){
    echo
    echo "+++ Functions +++"
    while read line ; do
        #grep ^alias | cut -c 7- | awk 'BEGIN {FS="="}; { print " " $1}' 
        grep ^function | cut -c 10- | awk 'BEGIN {FS="{"}; { print " " $1}'
    done < ~/.zshrc
    echo
}

info(){
    echo
    echo "version "$version
    echo "Create: "$create_date
    echo "Last Mod: "$last_mod_date
    echo "Author: "$author 
    echo
}

version(){
    echo "AliasTable version "$version
}


## If no argument
## `$#` shows the numbers of arguments
if [ $# = 0 ] 
    then
        normal
        exit 1
    elif [ $# = 1 ] 
        then 
            case "$1" in
                -a | --alias)
                    ali
                    exit 0
                    ;;

                -h | --help)
                    help
                    exit 0
                    ;;

                -l | --list)
                    list
                    exit 0
                    ;;
                -f | --function)
                    func
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

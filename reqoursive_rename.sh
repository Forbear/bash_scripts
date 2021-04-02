#! /bin/bash

do_rename() {
    local dir_list=$(find -maxdepth 1 -type d | grep "./")
    for element in $1; do
        if [[ "${dir_list[@]}" =~ "${element}" ]]; then
            if [ "$verbose" == true ]; then
                echo "Moving to $element."
            fi
            cd "$element"
	    if [[ "$extentions" != "null" ]]; then
		for extention in $extentions; do
                    rename "s/^([A-Z]+)\.$extention$/\L$1/" *
	        done
            else
                rename 's/^([A-Z]+)\.[a-z]*$/\L$1/' *
            fi
            rename 's/^([A-Z]+)$/\L$1/' *
            rename 's/^([A-Z])/\L$1/' *
            local dir_list_inside=$(find -maxdepth 1 -type d | grep "./")
            do_rename "$dir_list_inside"
            cd ..
        fi
    done
}

### MAIN ###
while [ -n "$1" ]; do
    case $1 in
	-l)
            list=$2
	    shift
	    ;;
	-ext)
	    extentions=$2
	    shift
	    ;;
	-v)
            verbose=true
	    ;;
    esac
    shift
done

do_rename "$list"


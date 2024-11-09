#!/bin/bash

source git-er-lib.sh

_git_er_done_completion() {
    if [[ "$1" =~ ^[A-Za-z]+-[0-9]*$ ]]; then
        local er_root=$(__git_er_get_dir)
        local options=$(ls "$er_root/todos" | sed 's/\([A-Za-z]\+-[0-9]\+\).*/\1/' | sort -u | tr '\n' ' ' | sed 's/ $//')
        COMPREPLY=( $(compgen -W "$options") )
        return 0
    elif [[ "$1" =~ ^[A-Za-z]*$ ]] || [[ "$1" == "--" ]]; then
        local er_root=$(__git_er_get_dir)
        local options=$(ls "$er_root/todos" | cut -d'-' -f1 | sort -u | tr '\n' ' ' | sed 's/ $//')
        COMPREPLY=( $(compgen -W "$options") )
        return 0
    fi
}


_git_er_completion() {
    # $1 - name of the command whose arguments are being completed (git)
    # $2 - the (partial) word being completed
    #    - seems like if this is empty it defaults to "--", but I can't find any documentation on that
    # $3 - the word preceding the word being completed
    # $COMP_WORDS - array of words in the current entire command
    # $COMP_CWORD - index on $COMP_WORDS of the word containing the current cursor position
    
    local cur=$2
    local prev=$3

    # complete argument
    if [[ "$COMP_CWORD" == 2 ]]; then
        COMPREPLY=( $(compgen -W "--done --did --didnt --do --doing") )
        return 0;
    fi

    if [[ "$COMP_CWORD" == 3 ]]; then
        if [[ "${COMP_WORDS[2]}" == "--done" ]]; then
            _git_er_done_completion $cur
            return 0;
        fi
    fi
    

    # useful for debugging: type "git er 0x<TAB>"
    # merged_comp_words=$(IFS=+; echo "${COMP_WORDS[*]}")
    # COMPREPLY=( $(compgen -W "0xfoo 0x1-$1 0x2-$2 0x3-$3 0xCL-$COMP_LINE 0xCW-$merged_comp_words 00-$command 0xWL-${#COMP_WORDS[@]} 0xCCW-${COMP_CWORD}") )
}


complete -F _git_er_completion git-er
complete -F _git_er_completion git er


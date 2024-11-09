#!/bin/bash

__git_er_generate_todo_id() {
    local er_root=$1
    local category=$2
    local count=$(ls "$er_root/todos" | grep -E "^${category}-" | wc -l)
    echo "${category}-$(($count + 2))"
}

__git_er_get_dir() {
    git rev-parse --is-inside-work-tree > /dev/null

    local git_root=$(git rev-parse --show-toplevel)
    local er_root="$git_root/.git-er"

    if [ ! -d "$er_root" ]; then
        mkdir "$er_root"
        mkdir "$er_root/todos"
        touch "$er_root/config.txt"
    fi

    echo "$er_root"
}

__git_er_mark_complete() {
    local er_root=$1
    local id=$2
    echo "COMPLETE" >> "$er_root/todos/$id-state.txt"
}

__git_er_mark_incomplete() {
    local er_root=$1
    local id=$2
    echo "INCOMPLETE" >> "$er_root/todos/$id-state.txt"
}

__git_er_list_complete() {
    local er_root=$1
    echo "Completed todos:"
    for todo_file in "$er_root/todos"/*-state.txt; do
        local status=$(tail -n 1 "$todo_file")
        if [ "$status" == "COMPLETE" ]; then
            echo "$(basename "$todo_file" -state.txt)"
        fi
    done
}

__git_er_list_incomplete() {
    local er_root=$1
    echo "Incomplete todos:"
    for todo_file in "$er_root/todos"/*-state.txt; do
        local status=$(tail -n 1 "$todo_file")
        if [ "$status" == "INCOMPLETE" ]; then
            echo "$(basename "$todo_file" -state.txt)"
        fi
    done
}

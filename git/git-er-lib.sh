#!/bin/bash

__git_er_generate_todo_id() {
    local er_root=$1
    local category=$2

    local highest_id=$(ls "$er_root/todos" | grep -E "^${category}-[0-9]+\.txt$" | \
        sed -E "s/^${category}-([0-9]+)\.txt$/\1/" | \
        sort -n | tail -n 1)

    if [ -z "$highest_id" ]; then
        echo "${category}-1"
    else
        echo "${category}-$((highest_id + 1))"
    fi
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
    for todo_file in "$er_root/todos"/*-state.txt; do
        if [ "$(tail -n 1 "$todo_file")" == "COMPLETE" ]; then
            echo "$(basename "$todo_file" -state.txt)"
        fi
    done
}

__git_er_list_incomplete() {
    local er_root=$1
    for todo_file in "$er_root/todos"/*-state.txt; do
        if [ "$(tail -n 1 "$todo_file")" == "INCOMPLETE" ]; then
            echo "$(basename "$todo_file" -state.txt)"
        fi
    done
}

__git_er_list() {
    local er_root=$1
    for todo_file in "$er_root/todos"/*-state.txt; do
        echo "$(basename "$todo_file" -state.txt)"
    done
}

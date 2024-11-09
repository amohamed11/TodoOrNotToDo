#!/bin/bash

source git-er-lib.sh
set -e
er_root=$(__git_er_get_dir)

show_help() {
    cat << EOF
Usage: git-er [OPTION] <target>

This script helps you manage the todos for your git repo.
It will store information in a folder at the root of your git repo named \`.git-er\`


Options:
  --help             Show this help text.
  --done <category>  Create a new todo item with the given category. The ID
                     for the item will be auto-numbered ("DOCS-1", "DOCS-2", etc).
                     If no category is given it will use the default category
                     TODO.
  --did <id>         Mark the todo item with the given ID as complete.
  --didnt <id>       Mark the todo item with the given ID as incomplete.
  --doing            List the todo items that are incomplete.
  --done             List the todo items that are complete.
  --do <id>          Edit the body of a todo item.


Examples:
  git er --done "DOCS"      # Creates a new todo item in the "DOCS" category
  git er --done "TODO-24"   # Marks item "TODO-24" as complete
  git er --didnt "DOCS-37"  # Marks item "DOCS-37" as incomplete
EOF
}

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "--done" ]]; then
    if [ -z "$2" ]; then
        echo "Completed todos:"
        __git_er_list_complete "$er_root" | sed 's/^/  /'
        exit 0
    fi

    category=$2
    new_id=$(__git_er_generate_todo_id "$er_root" "$category")
    __git_er_mark_incomplete "$er_root" "$new_id"

    todo_file="$er_root/todos/$new_id.txt"
    echo -e "$new_id\n----------" > "$todo_file"
    $EDITOR "$todo_file"

    echo "Created new todo: $new_id"
    exit 0
elif [[ "$1" == "--doing" ]]; then
    echo "Incomplete todos:"
    __git_er_list_incomplete "$er_root" | sed 's/^/  /'
    exit 0
elif [[ "$1" == "--did" ]]; then
    __git_er_mark_complete "$er_root" "$2"
    echo "Marked $2 as complete."
    exit 0
elif [[ "$1" == "--didnt" ]]; then
    __git_er_mark_incomplete "$er_root" "$2"
    echo "Marked $2 as incomplete."
    exit 0
elif [[ "$1" == "--do" ]]; then
    todo_file="$er_root/todos/$2.txt"
    $EDITOR "$todo_file"
    exit 0
fi

show_help

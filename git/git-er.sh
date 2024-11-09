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
  --done <id>        Mark the todo item with the given ID as complete.
  --did <id>         List the todo items are are complete.
  --didnt <id>       Mark the todo item with the given ID as incomplete.
  --do               List the todo items that are incomplete.
  --doing <id>       Edit the body of a todo item.


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
        echo "Error: Missing category or todo ID"
        exit 1
    fi

    if [[ "$2" =~ ^[A-Za-z]+-[0-9]+$ ]]; then
        __git_er_mark_complete "$er_root" "$2"
        echo "Marked $2 as complete."
        exit 0
    elif [[ "$2" =~ ^[A-Za-z]+$ ]]; then
        category=$2
        new_id=$(__git_er_generate_todo_id "$er_root" "$category")
        __git_er_mark_incomplete "$er_root" "$new_id"

        todo_file="$er_root/todos/$new_id.txt"
        echo -e "$new_id\n----------" > "$todo_file"
        $EDITOR "$todo_file"

        echo "Created new todo: $new_id"
        exit 0
    fi

    echo "Invalid format for category or unknown todo ID: $2"
    exit 1
fi

show_help

# Git-er

This script helps you manage the todos for your git repo.
It will store information in a folder at the root of your git repo named \`.git-er\`.

# Installation

Add the following to your `PATH`:

- `git-er`
- `git-er.sh`
- `git-er-lib.sh`

Optionally, if you want completion, source `git-er-completion.sh` in your `.bashrc`/`.zshrc`.

# Usage

Calling `git er` with no arguments will show the help text.

- Use `git er --done CAT` to create a new todo item.
- Use `git er --do CAT-123` to edit the body of the todo item
- Use `git er --done` to list incomplete todo items
- Use `git er --did CAT-123` to mark a todo item as done.

See the help text for other commands.

# TODO

Things that still need to be done but I am too lazy to fix:

- `git er --help` doesn't work, but `git-er --help` or `git er` will both show the help text.
- allow filtering `git er --doing` and `git er --done` by category
- verifying a todo actually exists before updating its status with `git er --did` or `git er --didnt` or editing it with `git er --do`
- allow configuration for the name and location fo the root dir

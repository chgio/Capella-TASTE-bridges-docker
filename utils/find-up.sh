#!/bin/bash
set -e
path="$1"
shift 1
while [[ $path != / ]];
do
    find "$path" -maxdepth 1 -mindepth 1 "$@"
    path="$(dirname "$path")"
done

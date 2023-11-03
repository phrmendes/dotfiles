#!/usr/bin/env bash

IFS=$'\n'

set -o noclobber -o noglob -o nounset -o pipefail

FILE_PATH=""
PREVIEW_WIDTH=10
PREVIEW_HEIGHT=10

while [ "$#" -gt 0 ]; do
    case "$1" in
        "--path")
            shift
            FILE_PATH="$1"
            ;;
        "--preview-width")
            shift
            PREVIEW_WIDTH="$1"
            ;;
        "--preview-height")
            shift
            PREVIEW_HEIGHT="$1"
            ;;
    esac
    shift
done

handle_mime() {
    local mimetype="${1}"

    case "$mimetype" in
        *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
            pandoc -s -t markdown -- "$FILE_PATH" | bat -l markdown \
                --color=always --paging=never \
                --style=plain \
                --terminal-width="$PREVIEW_WIDTH" && exit 0
            exit 1 ;;
        text/* | */xml)
            bat --color=always --paging=never \
                --style=plain \
                --terminal-width="$PREVIEW_WIDTH" \
                "$FILE_PATH" && exit 0
            exit 1 ;;

        image/*)
            flatpak run org.wezfurlong.wezterm imgcat "$FILE_PATH" && exit 0
            exit 1 ;;
    esac
}

MIMETYPE="$( file --dereference --brief --mime-type -- "$FILE_PATH" )"
handle_mime "$MIMETYPE"

exit 1

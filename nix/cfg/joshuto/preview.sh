#!/usr/bin/env bash

IFS=$'\n'

# Security measures:
# - noclobber prevents you from overwriting a file with `>`
# - noglob prevents expansion of wild cards
# - nounset causes bash to fail if an undeclared variable is used (e.g. typos)
# - pipefail causes a pipeline to fail also if a command other than the last one fails
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

handle_extension() {
	case "${FILE_EXTENSION_LOWER}" in
		a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
			atool --list -- "${FILE_PATH}" && exit 0
			exit 1
			;;
		rar)
			unrar lt -p- -- "${FILE_PATH}" && exit 0
			exit 1
			;;
		7z)
			7z l -p -- "${FILE_PATH}" && exit 0
			exit 1
			;;
		pdf)
			pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | fmt -w "${PREVIEW_WIDTH}" && exit 0
			zathura --fork "${FILE_PATH}" && exit 0
			exiftool "${FILE_PATH}" && exit 0
			exit 1
			;;
		torrent)
			deluge "${FILE_PATH}" && exit 0
			exit 1
			;;
		odt | ods | odp | sxw)
			pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
			exit 1
			;;
		xlsx)
			xlsx2csv -- "${FILE_PATH}" && exit 0
			exit 1
			;;
		htm | html | xhtml)
			pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
			;;
		json)
			jq --color-output . "${FILE_PATH}" && exit 0
			;;
		yaml)
			yq -C "${FILE_PATH}" && exit 0
			;;
	esac
}

handle_mime() {
	local mimetype="${1}"

	case "${mimetype}" in
		*wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
			pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown --color=always --paging=never --style=plain --terminal-width="${PREVIEW_WIDTH}" && exit 0
			exit 1
			;;

		*ms-excel)
			xls2csv -- "${FILE_PATH}" && exit 0
			exit 1
			;;

		text/* | */xml)
			bat --color=always --paging=never --style=plain --terminal-width="${PREVIEW_WIDTH}" "${FILE_PATH}" && exit 0
			exit 1
			;;

		image/*)
			exiftool "${FILE_PATH}" && exit 0
			exit 1
			;;

		video/* | audio/*)
			exiftool "${FILE_PATH}" && exit 0
			exit 1
			;;
	esac
}

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
handle_extension
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_mime "${MIMETYPE}"

exit 1

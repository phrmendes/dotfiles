#!/bin/bash

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

readonly PHOTO_EXIF_FIELDS="-DateTimeOriginal -SubSecTimeOriginal"
readonly VIDEO_EXIF_FIELDS="-DateTimeOriginal -CreateDate -MediaCreateDate"
readonly FILE_DATE_FIELD="-FileModifyDate"
readonly DEFAULT_SUBSEC="000"
readonly TARGET_PHOTO_EXT="jpg"
readonly TARGET_VIDEO_EXT="mp4"
readonly PHOTO_QUALITY="95"
readonly PHOTO_TYPE="photo"
readonly VIDEO_TYPE="video"

DRY_RUN="false"
PARALLEL_JOBS="$(nproc)"
TARGET_DIR="."

show_usage() {
    cat << EOF
$SCRIPT_NAME - Rename and convert media files based on metadata

USAGE:
    $SCRIPT_NAME [OPTIONS] [DIRECTORY]

OPTIONS:
    --dry-run, -n    Preview changes without executing
    --jobs, -j NUM   Parallel jobs (default: $(nproc))
    --help, -h       Show this help

EXAMPLES:
    $SCRIPT_NAME --dry-run       Preview changes
    $SCRIPT_NAME -j 4 ~/Photos   Process with 4 jobs

Renames files to YYYY-MM-DD_HH-MM-SS format. Converts photos to JPG, videos to MP4.
Requires: parallel, exiftool, ffmpeg, imagemagick
EOF
    exit 0
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|-n)
                DRY_RUN="true"
                shift
                ;;
            --jobs|-j)
                [[ -z "${2:-}" || "$2" =~ ^- ]] && { echo "Error: --jobs requires a number"; exit 1; }
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            --help|-h)
                show_usage
                ;;
            -*)
                echo "Error: Unknown option $1"
                echo "Use --help for usage information"
                exit 1
                ;;
            *)
                TARGET_DIR="$1"
                shift
                ;;
        esac
    done
}

validate_directory() {
    [[ -d "$TARGET_DIR" ]] || { echo "Error: Directory '$TARGET_DIR' does not exist"; exit 1; }
    [[ -r "$TARGET_DIR" ]] || { echo "Error: Directory '$TARGET_DIR' is not readable"; exit 1; }
    [[ -w "$TARGET_DIR" ]] || { echo "Error: Directory '$TARGET_DIR' is not writable"; exit 1; }
}

validate_dependencies() {
    local missing=()
    local deps=("parallel" "exiftool" "ffmpeg" "magick")

    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
    done

    [[ ${#missing[@]} -eq 0 ]] && return

    echo "Error: Missing dependencies: ${missing[*]}"
    exit 1
}

is_photo() {
    [[ "$1" =~ \.(jpg|JPG|jpeg|JPEG|png|PNG)$ ]]
}

is_video() {
    [[ "$1" =~ \.(mp4|MP4|mov|MOV|avi|AVI)$ ]]
}

get_file_type() {
    is_photo "$1" && echo "$PHOTO_TYPE" && return
    is_video "$1" && echo "$VIDEO_TYPE" && return
}

extract_photo_metadata() {
    exiftool -T "$PHOTO_EXIF_FIELDS" "$1" 2>/dev/null || echo "- -"
}

extract_video_metadata() {
    local file="$1"
    local datetime

    for field in -DateTimeOriginal -CreateDate -MediaCreateDate; do
        datetime=$(exiftool -T "$field" "$file" 2>/dev/null || echo "-")
        [[ "$datetime" != "-" ]] && { echo "$datetime|-"; return; }
    done

    echo "-|-"
}

extract_file_metadata() {
    exiftool -T "$FILE_DATE_FIELD" "$1" | sed 's/[+-][0-9]*:[0-9]*$//'
}

get_metadata() {
    local file="$1"
    local file_type="$2"

    [[ "$file_type" == "$PHOTO_TYPE" ]] && { extract_photo_metadata "$file"; return; }

    extract_video_metadata "$file"
}

parse_metadata() {
    echo "${1%|*}|${1#*|}"
}

has_subseconds() {
    [[ "$1" != "-" && -n "$1" && "$1" != "$DEFAULT_SUBSEC" ]]
}

format_datetime() {
    echo "$1" | awk '{gsub(/:/, "-", $1); gsub(/:/, "-", $2); print $1"_"$2}'
}

get_target_extension() {
    [[ "$1" == "$PHOTO_TYPE" ]] && echo "$TARGET_PHOTO_EXT" || echo "$TARGET_VIDEO_EXT"
}

build_filename() {
    local datetime="$1"
    local subsec="$2"
    local file_type="$3"
    local has_real_subsec="$4"
    local formatted_date ext

    formatted_date=$(format_datetime "$datetime")
    ext=$(get_target_extension "$file_type")

    if [[ "$has_real_subsec" == "true" ]] && has_subseconds "$subsec"; then
        echo "${formatted_date}-${subsec}.${ext}"
        return
    fi

    echo "${formatted_date}.${ext}"
}

resolve_conflict() {
    local target_name="$1"
    local original_file="$2"
    local target_dir full_path counter base ext

    target_dir=$(dirname "$original_file")
    full_path="$target_dir/$target_name"

    [[ ! -f "$full_path" || "$full_path" == "$original_file" ]] && { echo "$target_name"; return; }

    counter=1
    base="${target_name%.*}"
    ext="${target_name##*.}"

    while [[ -f "$target_dir/${base}_$(printf %03d "$counter").${ext}" ]]; do
        ((counter++))
    done

    echo "${base}_$(printf %03d "$counter").${ext}"
}

needs_conversion() {
    local input_file="$1"
    local file_type="$2"
    local input_ext target_ext

    input_ext=$(echo "${input_file##*.}" | tr '[:upper:]' '[:lower:]')
    target_ext=$(get_target_extension "$file_type")

    [[ "$input_ext" != "$target_ext" ]]
}

convert_photo() {
    magick "$1" -quality "$PHOTO_QUALITY" "$2" 2>/dev/null
}

convert_video() {
    ffmpeg -i "$1" -c:v libx264 -c:a aac -movflags +faststart "$2" -y 2>/dev/null
}

perform_conversion() {
    local input_file="$1"
    local temp_output="$2"
    local file_type="$3"

    [[ "$file_type" == "$PHOTO_TYPE" ]] && { convert_photo "$input_file" "$temp_output"; return; }

    convert_video "$input_file" "$temp_output"
}

execute_rename() {
    local original_file="$1"
    local target_path="$2"
    local file_type="$3"

    [[ "$target_path" == "$original_file" ]] && return

    mv "$original_file" "$target_path" 2>/dev/null
}

execute_conversion() {
    local input_file="$1"
    local target_name="$2"
    local file_type="$3"
    local input_dir target_path temp_output

    input_dir=$(dirname "$input_file")
    target_path="$input_dir/$target_name"
    temp_output="$input_dir/temp_$(basename "$target_name")"

    if ! perform_conversion "$input_file" "$temp_output" "$file_type"; then
        rm -f "$temp_output"
        return 1
    fi

    if ! mv "$temp_output" "$target_path" 2>/dev/null; then
        rm -f "$temp_output"
        return 1
    fi

    rm -f "$input_file"
}

extract_subseconds() {
    local meta="$1"
    local file_type="$2"
    local test_subsec

    [[ "$file_type" != "$PHOTO_TYPE" || "$meta" == "- -" ]] && { echo "false"; return; }

    test_subsec=$(echo "$meta" | cut -f2)
    [[ "$test_subsec" != "-" && -n "$test_subsec" ]] && echo "true" || echo "false"
}

get_datetime_from_metadata() {
    local file="$1"
    local file_type="$2"
    local meta datetime subsec has_real_subsec parsed

    meta=$(get_metadata "$file" "$file_type")
    has_real_subsec=$(extract_subseconds "$meta" "$file_type")

    parsed=$(parse_metadata "$meta")
    datetime="${parsed%|*}"
    subsec="${parsed#*|}"

    if [[ "$datetime" == "-" || -z "$datetime" ]]; then
        datetime=$(extract_file_metadata "$file")
        subsec="$DEFAULT_SUBSEC"
        has_real_subsec="false"
    fi

    echo "$datetime|$subsec|$has_real_subsec"
}

process_single_file() {
    local file="$1"
    local dry_run="$2"
    local file_type datetime_info datetime subsec has_real_subsec
    local new_name final_name conversion_needed target_path

    [[ ! -f "$file" ]] && return
    [[ "$(basename "$file")" =~ ^\. ]] && return

    file_type=$(get_file_type "$file")
    [[ -z "$file_type" ]] && return

    datetime_info=$(get_datetime_from_metadata "$file" "$file_type")
    datetime="${datetime_info%%|*}"
    subsec="${datetime_info#*|}"
    subsec="${subsec%|*}"
    has_real_subsec="${datetime_info##*|}"

    new_name=$(build_filename "$datetime" "$subsec" "$file_type" "$has_real_subsec")
    final_name=$(resolve_conflict "$new_name" "$file")

    conversion_needed=$(needs_conversion "$file" "$file_type")

    if [[ "$dry_run" == "true" ]]; then
        if [[ "$conversion_needed" == "true" ]]; then
            echo "WOULD CONVERT: $(basename "$file") -> $final_name"
            return
        fi

        [[ "$(dirname "$file")/$final_name" != "$file" ]] && echo "WOULD RENAME: $(basename "$file") -> $final_name"
        return
    fi

    if [[ "$conversion_needed" == "true" ]]; then
        execute_conversion "$file" "$final_name" "$file_type"
        return
    fi

    target_path="$(dirname "$file")/$final_name"
    execute_rename "$file" "$target_path" "$file_type"
}

show_header() {
    echo "Media File Processor - Parallel Rename & Convert"
    echo "Photos -> JPG | Videos -> MP4"
    echo "Target: $(realpath "$TARGET_DIR")"
    echo "Jobs: $PARALLEL_JOBS"
    [[ "$DRY_RUN" == "true" ]] && echo "DRY RUN MODE - No changes will be made"
    echo
}

find_media_files() {
    find "$TARGET_DIR" -maxdepth 1 \( \
        -name "*.jpg" -o -name "*.JPG" -o \
        -name "*.jpeg" -o -name "*.JPEG" -o \
        -name "*.png" -o -name "*.PNG" -o \
        -name "*.mp4" -o -name "*.MP4" -o \
        -name "*.mov" -o -name "*.MOV" -o \
        -name "*.avi" -o -name "*.AVI" \
    \) -type f
}

count_media_files() {
    find_media_files | wc -l
}

process_files() {
    local start_time end_time total_files
    start_time=$(date +%s)
    total_files=$(count_media_files)

    echo "Processing $total_files files..."
    echo

    if [[ "$total_files" -gt 0 ]]; then
        find_media_files | parallel -j "$PARALLEL_JOBS" --progress process_single_file {} "$DRY_RUN"
    else
        echo "No media files found to process."
    fi

    end_time=$(date +%s)
    echo
    echo "Completed in $((end_time - start_time)) seconds"
}

main() {
    parse_arguments "$@"
    validate_directory
    validate_dependencies
    show_header
    process_files
}

export -f process_single_file get_file_type get_metadata extract_photo_metadata extract_video_metadata
export -f extract_file_metadata parse_metadata build_filename resolve_conflict
export -f execute_conversion execute_rename perform_conversion convert_photo convert_video
export -f needs_conversion is_photo is_video has_subseconds
export -f format_datetime get_target_extension extract_subseconds get_datetime_from_metadata
export -f find_media_files count_media_files
export DEFAULT_SUBSEC PHOTO_EXIF_FIELDS VIDEO_EXIF_FIELDS FILE_DATE_FIELD
export TARGET_PHOTO_EXT TARGET_VIDEO_EXT PHOTO_QUALITY PHOTO_TYPE VIDEO_TYPE TARGET_DIR

main "$@"

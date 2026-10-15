#!/usr/bin/env bash
set -euo pipefail

source lib.sh

LOG_PREFIX=limine
MAX_SNAPSHOTS=${MAX_SNAPSHOTS:-$KEEP_OLD_ROOTS}
CONF=limine/limine.conf
GROUP_NAME='root snapshots'
MARKER_START='# root snapshots start'
MARKER_END='# root snapshots end'
STALE_PATHS=(
    loader
    EFI/systemd
    EFI/nixos
    EFI/BOOT
)

CONF_LINES=()
ENTRY_LABEL=()
ENTRY_BODY=()
NAMES=()

load_lines() {
    local line

    CONF_LINES=()

    while IFS= read -r line || [[ -n $line ]]; do
        if [[ $line == "$MARKER_START" ]]; then
            while IFS= read -r line && [[ $line != "$MARKER_END" ]]; do :; done
            continue
        fi

        CONF_LINES+=("$line")
    done <"$ESP_MNT/$CONF"
}

read_entries() {
    local body=''
    local have_cmdline=0
    local have_kernel=0
    local label=''
    local line

    ENTRY_LABEL=()
    ENTRY_BODY=()

    for line in "${CONF_LINES[@]}" "/"; do
        if [[ $line =~ ^/+\+?(.*)$ ]]; then
            if ((have_kernel && have_cmdline)); then
                ENTRY_LABEL+=("$label")
                ENTRY_BODY+=("$body")
            fi

            label=${BASH_REMATCH[1]}
            body=''
            have_cmdline=0
            have_kernel=0
            continue
        fi

        if [[ ! $line =~ ^[a-z_]+: ]]; then
            continue
        fi

        case $line in
            kernel_path:*) have_kernel=1 ;;
            cmdline:*) have_cmdline=1 ;;
        esac

        if [[ -z $body ]]; then
            body=$line
        else
            body+=$'\n'$line
        fi
    done
}

visible_headers() {
    local count=0
    local i
    local level
    local line
    local visible
    local -a open=()

    for line in "${CONF_LINES[@]}"; do
        if [[ ! $line =~ ^(/+)(\+?) ]]; then
            continue
        fi

        level=${#BASH_REMATCH[1]}
        visible=1

        for ((i = 1; i < level; i++)); do
            if [[ ${open[i]:-0} != 1 ]]; then
                visible=0
            fi
        done

        open[level]=0

        if [[ -n ${BASH_REMATCH[2]} ]]; then
            open[level]=1
        fi

        count=$((count + visible))
    done

    printf '%s\n' "$count"
}

list_names() {
    local name
    local path

    NAMES=()

    while IFS= read -r path; do
        name=${path##*/}

        case $name in
            "" | *[!A-Za-z0-9_.:-]*) continue ;;
        esac

        NAMES+=("$name")

        if ((${#NAMES[@]} >= MAX_SNAPSHOTS)); then
            break
        fi
    done < <(list_old_roots)
}

emit_block() {
    local index
    local line
    local mark=+
    local name

    printf '%s\n' "/+$GROUP_NAME"

    for index in "${!ENTRY_LABEL[@]}"; do
        printf '%s\n' "//$mark${ENTRY_LABEL[$index]}"
        mark=

        for name in "${NAMES[@]}"; do
            printf '%s\n' "///$name"

            while IFS= read -r line; do
                if [[ $line == cmdline:* ]]; then
                    printf '%s %s=%s\n' "$line" "$ROOT_TOKEN" "$name"
                else
                    printf '%s\n' "$line"
                fi
            done <<<"${ENTRY_BODY[$index]}"
        done
    done
}

write_conf() {
    local index=''
    local line
    local replaced=0
    local tmp=$ESP_MNT/$CONF.tmp

    if ((${#NAMES[@]} > 0)); then
        index=$(($(visible_headers) + 3))
    fi

    {
        for line in "${CONF_LINES[@]}"; do
            if [[ -n $index && $replaced == 0 && $line == default_entry:* ]]; then
                printf 'default_entry: %s\n' "$index"
                replaced=1
            else
                printf '%s\n' "$line"
            fi
        done

        printf '%s\n' "$MARKER_START"

        if ((${#NAMES[@]} > 0)); then
            emit_block
        fi

        printf '%s\n' "$MARKER_END"
    } >"$tmp"

    mv "$tmp" "$ESP_MNT/$CONF"
    sync

    if [[ -n $index && $replaced == 0 ]]; then
        log "warning: no default_entry line in $ESP_MNT/$CONF"
    fi

    log "wrote $((${#ENTRY_LABEL[@]} * ${#NAMES[@]})) root snapshot entries to $ESP_MNT/$CONF"
}

snapshots() {
    if [[ ! -f $ESP_MNT/$CONF ]]; then
        log "warning: $ESP_MNT/$CONF not found; skipping the Limine snapshot entries"
        return 0
    fi

    if [[ ! -d $OLD_ROOTS ]]; then
        log "warning: $OLD_ROOTS not found; skipping the Limine snapshot entries"
        return 0
    fi

    load_lines
    read_entries

    if ((${#ENTRY_LABEL[@]} == 0)); then
        log "warning: no Linux entry found in $ESP_MNT/$CONF; keeping it unchanged"
        return 0
    fi

    list_names
    write_conf
}

remove_stale_paths() {
    local path

    for path in "${STALE_PATHS[@]}"; do
        if [[ ! -e $ESP_MNT/$path ]]; then
            continue
        fi

        rm -rf -- "${ESP_MNT:?}/$path"
        log "removed /$path from the ESP"
    done

    return 0
}

remove_systemd_boot_entry() {
    local line
    local num

    while IFS= read -r line; do
        case $line in
            Boot[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]*"Linux Boot Manager"*)
                num=${line#Boot}
                num=${num:0:4}

                if efibootmgr --bootnum "$num" --delete-bootnum >/dev/null; then
                    log "removed the UEFI boot entry $num (Linux Boot Manager)"
                else
                    log "warning: could not remove the UEFI boot entry $num"
                fi
                ;;
        esac
    done < <(efibootmgr 2>/dev/null || true)

    return 0
}

cleanup() {
    if [[ ! -f $ESP_MNT/$CONF ]]; then
        log "warning: $ESP_MNT/$CONF not found; skipping the cleanup"
        return 0
    fi

    remove_stale_paths
    remove_systemd_boot_entry
}

command=${1:-}

if [[ $command == snapshots ]]; then
    snapshots
elif [[ $command == cleanup ]]; then
    cleanup
else
    echo "usage: $(basename "$0") {snapshots|cleanup}" >&2
    exit 2
fi

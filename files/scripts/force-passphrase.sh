#!/bin/sh
set -e

# Partition that holds the stamp file.
esp=${ESP:?}

# File on that partition with the time of the last boot that asked for the passphrase.
stamp=${STAMP:?}

# Seconds that the PIN works after a boot that asked for the passphrase.
interval=${INTERVAL:?}

# Value that the script adds to PCR 7 to make the TPM refuse the PIN.
poison=${POISON:?}

# Where the script mounts the partition to read the stamp.
mnt=/run/force-passphrase

# Flag that tells the running system that this boot asked for the passphrase.
forced_flag=/run/passphrase-forced

# Wait up to ten seconds for the TPM and the ESP to appear.
wait_for_devices() {
    waited=0
    while [ ! -e /dev/tpmrm0 ] || [ ! -e "$esp" ]; do
        [ "$waited" -lt 100 ] || return 0
        sleep 0.1
        waited=$((waited + 1))
    done
}

# Print the time of the last passphrase boot in seconds, or 0 when none is on record.
read_stamp() {
    last=0
    mkdir -p "$mnt"
    if mount -t vfat -o ro "$esp" "$mnt"; then
        if [ -r "$mnt/$stamp" ]; then
            last=$(cat "$mnt/$stamp")
        fi
        umount "$mnt"
    fi
    case $last in
    "" | *[!0-9]*) last=0 ;;
    esac
    printf '%s\n' "$last"
}

# Succeed when the age is over the interval, or negative because the clock went back.
passphrase_due() {
    [ "$1" -lt 0 ] || [ "$1" -ge "$interval" ]
}

# Change PCR 7 so that the TPM refuses the PIN for this boot, and leave a flag for the running system.
turn_pin_off() {
    tpm2_pcrextend "7:sha256=$poison"
    touch "$forced_flag"
    echo "force-passphrase: the last passphrase boot is too old, the PIN is off for this boot"
}

wait_for_devices

if [ ! -e /dev/tpmrm0 ]; then
    echo "force-passphrase: no TPM, nothing to gate"
    exit 0
fi

age=$(($(date +%s) - $(read_stamp)))

if ! passphrase_due "$age"; then
    echo "force-passphrase: the PIN stays on for $((interval - age)) more seconds"
    exit 0
fi

turn_pin_off

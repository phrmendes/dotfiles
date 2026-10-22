use lib.nu fail

# Encrypted disk that the commands use when the user gives none.
const DEFAULT_DEVICE = "/dev/disk/by-partlabel/disk-main-luks"

# TPM register that the PIN is bound to. PCR 7 holds the Secure Boot state.
const PCRS = "7"

# Flag that the boot sets when it changed PCR 7 on purpose to ask for the passphrase.
const FORCED_FLAG = "/run/passphrase-forced"

# File on the ESP with the time of the last boot that asked for the passphrase.
const STAMP = "/boot/luks-passphrase-stamp"

# Encrypted disk partitions, by partition label.
def "nu-complete pin device" []: nothing -> list<string> {
    glob /dev/disk/by-partlabel/*
}

# List the key slot types of the disk, for example password and tpm2.
def slot-types [
    device: string # encrypted disk to read
]: nothing -> list<string> {
    let result = sudo systemd-cryptenroll $device | complete

    if $result.exit_code != 0 {
        fail $"Cannot read the key slots of ($device)." $device --text disk
    }

    $result.stdout | lines | skip 1 | parse --regex '^\s*\d+\s+(?<type>\S+)' | get type
}

# Check whether systemd can see a TPM.
def has-tpm []: nothing -> bool {
    (systemd-cryptenroll --tpm2-device=list | complete).stdout | str contains /dev/tpm
}

# Stop with an error when no TPM is usable.
def require-tpm [
    device: string # encrypted disk, named in the error
]: nothing -> nothing {
    if not (has-tpm) {
        fail "No usable TPM found. The boot asks for the passphrase every time." $device --text disk
    }
}

# Time of the last boot that asked for the passphrase, or nothing when none is on record.
def last-passphrase []: nothing -> oneof<datetime, nothing> {
    let result = sudo cat $STAMP | complete

    if $result.exit_code != 0 {
        return null
    }

    let seconds = $result.stdout | str trim | into int

    $seconds * 1_000_000_000 | into datetime
}

# Seal the key to the TPM with a PIN, and replace any older PIN.
# Stop when this boot asked for the passphrase. PCR 7 differs on purpose now, so a new seal would never match.
def enroll [
    device: string # encrypted disk to seal the key of
]: nothing -> nothing {
    if ($FORCED_FLAG | path exists) {
        fail "This boot asked for the passphrase, so PCR 7 differs on purpose. Reboot first." $device --text disk
    }

    try {
        sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto $"--tpm2-pcrs=($PCRS)" --tpm2-with-pin=yes $device
    } catch {
        fail "Cannot seal the key to the TPM." $device --text disk
    }
}

# Set the PIN for the first time. Asks for the passphrase, then the PIN twice.
export def create [
  --device (-d): string@"nu-complete pin device" = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> nothing {
    require-tpm $device

    if "tpm2" in (slot-types $device) {
        fail "A PIN already exists. Use `pin edit` to change it." $device --text disk
    }

    enroll $device
}

# Change the PIN. Also use it after a firmware Secure Boot setting change, to seal the key again.
export def edit [
  --device (-d): string@"nu-complete pin device" = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> nothing {
    require-tpm $device

    if "tpm2" not-in (slot-types $device) {
        fail "No PIN yet. Use `pin create`." $device --text disk
    }

    enroll $device
}

# Remove the PIN. The boot asks for the passphrase again.
export def delete [
  --device (-d): string@"nu-complete pin device" = $DEFAULT_DEVICE # Encrypted disk to use
  --yes (-y) # Do not ask for confirmation
]: nothing -> nothing {
    let types = (slot-types $device)

    if "tpm2" not-in $types {
        print "No PIN set."
        return
    }

    if "password" not-in $types {
        fail "Refusing: no passphrase slot would remain." $device --text disk
    }

    if not $yes {
        let answer = (
            try { input "Delete the PIN? The boot will ask for the passphrase. [y/N] " } catch { fail "Cannot ask here. Use --yes." $device --text disk }
        )
        if $answer !~ '(?i)^y(es)?$' {
            print Cancelled.
            return
        }
    }

    try {
        sudo systemd-cryptenroll --wipe-slot=tpm2 $device
    } catch {
        fail "Cannot delete the PIN." $device --text disk
    }
    print "PIN deleted. The boot asks for the passphrase."
}

# Show whether a TPM, a PIN, and a passphrase slot exist, and when the passphrase was last asked.
export def status [
  --device (-d): string@"nu-complete pin device" = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> record {
    let types = (slot-types $device)
    {
        tpm: (has-tpm)
        pin: ("tpm2" in $types)
        passphrase: ("password" in $types)
        passphrase_boot: ($FORCED_FLAG | path exists)
        last_passphrase: (last-passphrase)
    }
}

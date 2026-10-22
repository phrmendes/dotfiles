use lib.nu fail

# Encrypted disk that the commands use when the user gives none.
const DEFAULT_DEVICE = "/dev/disk/by-partlabel/disk-main-luks"

# TPM register that the PIN is bound to. PCR 7 holds the Secure Boot state.
const PCRS = "7"

# Flag that the boot sets when it changed PCR 7 on purpose to ask for the passphrase.
const FORCED_FLAG = "/run/passphrase-forced"

# File on the ESP with the time of the last boot that asked for the passphrase.
const STAMP = "/boot/luks-passphrase-stamp"

# List the key slot types of the disk, for example password and tpm2.
def slot-types [
    device: string # encrypted disk to read
]: nothing -> list<string> {
    let result = (^sudo systemd-cryptenroll $device | complete)

    if $result.exit_code != 0 {
        fail $"Cannot read the key slots of ($device)." $device "disk"
    }

    $result.stdout | lines | skip 1 | parse --regex '^\s*\d+\s+(?<type>\S+)' | get type
}

# Check whether systemd can see a TPM.
def has-tpm []: nothing -> bool {
    (^systemd-cryptenroll --tpm2-device=list | complete).stdout | str contains "/dev/tpm"
}

# Stop with an error when no TPM is usable.
def require-tpm [
    device: string # encrypted disk, named in the error
]: nothing -> nothing {
    if not (has-tpm) {
        fail "No usable TPM found. The boot asks for the passphrase every time." $device "disk"
    }
}

# Time of the last boot that asked for the passphrase, or nothing when none is on record.
def last-passphrase []: nothing -> oneof<datetime, nothing> {
    let result = (^sudo cat $STAMP | complete)

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
        fail "This boot asked for the passphrase, so PCR 7 differs on purpose. Reboot first." $device "disk"
    }

    ^sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto $"--tpm2-pcrs=($PCRS)" --tpm2-with-pin=yes $device
}

# Set the PIN for the first time. Asks for the passphrase, then the PIN twice.
def "main create" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> nothing {
    require-tpm $device

    if "tpm2" in (slot-types $device) {
        fail "A PIN already exists. Use `pin edit` to change it." $device "disk"
    }

    enroll $device
}

# Change the PIN. Also use it after a firmware Secure Boot setting change, to seal the key again.
def "main edit" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> nothing {
    require-tpm $device

    if "tpm2" not-in (slot-types $device) {
        fail "No PIN yet. Use `pin create`." $device "disk"
    }

    enroll $device
}

# Remove the PIN. The boot asks for the passphrase again.
def "main delete" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
  --yes (-y) # Do not ask for confirmation
]: nothing -> nothing {
    let types = (slot-types $device)

    if "tpm2" not-in $types {
        print "No PIN set."
        return
    }

    if "password" not-in $types {
        fail "Refusing: no passphrase slot would remain." $device "disk"
    }

    if not $yes {
        let answer = (
            try { input "Delete the PIN? The boot will ask for the passphrase. [y/N] " } catch { fail "Cannot ask here. Use --yes." $device "disk" }
        )
        if ($answer | str lowercase) not-in ["y" "yes"] {
            print "Cancelled."
            return
        }
    }

    ^sudo systemd-cryptenroll --wipe-slot=tpm2 $device
    print "PIN deleted. The boot asks for the passphrase."
}

# Show whether a TPM, a PIN, and a passphrase slot exist, and when the passphrase was last asked.
def "main status" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
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

def main []: nothing -> nothing { }

const DEFAULT_DEVICE = "/dev/disk/by-partlabel/disk-main-luks"

# TPM register that the PIN is bound to. PCR 7 holds the Secure Boot policy.
const PCRS = "7"

# Stop with an error that points at the disk.
def fail [message: string, device: string]: nothing -> error {
    error make {
        msg: $message
        label: {
            text: "disk"
            span: (metadata $device).span
        }
    }
}

# List the key slot types of the disk, for example password and tpm2.
def slot-types [device: string]: nothing -> list<string> {
    let result = (^sudo systemd-cryptenroll $device | complete)

    if $result.exit_code != 0 {
        fail $"Cannot read the key slots of ($device)." $device
    }

    $result.stdout | lines | skip 1 | parse --regex '^\s*\d+\s+(?<type>\S+)' | get type
}

# Check whether systemd can see a TPM.
def has-tpm []: nothing -> bool {
    (^systemd-cryptenroll --tpm2-device=list | complete).stdout | str contains "/dev/tpm"
}

# Stop with an error when no TPM is usable.
def require-tpm [device: string]: nothing -> nothing {
    if not (has-tpm) {
        fail "No usable TPM found. The boot asks for the passphrase every time." $device
    }
}

# Seal the key to the TPM with a PIN, and replace any older PIN.
def enroll [device: string]: nothing -> nothing {
    ^sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto $"--tpm2-pcrs=($PCRS)" --tpm2-with-pin=yes $device
}

# Set the PIN for the first time. Asks for the passphrase, then the PIN twice.
def "main create" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> nothing {
    require-tpm $device

    if "tpm2" in (slot-types $device) {
        fail "A PIN already exists. Use `pin edit` to change it." $device
    }

    enroll $device
}

# Change the PIN. Also use it after a Secure Boot or firmware change, to seal the key again.
def "main edit" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> nothing {
    require-tpm $device

    if "tpm2" not-in (slot-types $device) {
        fail "No PIN yet. Use `pin create`." $device
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
        fail "Refusing: no passphrase slot would remain." $device
    }

    if not $yes {
        let answer = (
            try { input "Delete the PIN? The boot will ask for the passphrase. [y/N] " } catch { fail "Cannot ask here. Use --yes." $device }
        )
        if ($answer | str lowercase) not-in ["y" "yes"] {
            print "Cancelled."
            return
        }
    }

    ^sudo systemd-cryptenroll --wipe-slot=tpm2 $device
    print "PIN deleted. The boot asks for the passphrase."
}

# Show whether a TPM, a PIN, and a passphrase slot exist.
def "main status" [
  --device (-d): string = $DEFAULT_DEVICE # Encrypted disk to use
]: nothing -> record<tpm: bool, pin: bool, passphrase: bool> {
    let types = (slot-types $device)
    {
        tpm: (has-tpm)
        pin: ("tpm2" in $types)
        passphrase: ("password" in $types)
    }
}

def main []: nothing -> nothing { }

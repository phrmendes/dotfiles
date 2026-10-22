use std/log

# Time between two checks of the tray.
const INTERVAL = 500ms

# Succeed when a status notifier host, such as the Noctalia bar, owns the tray.
def host-registered []: nothing -> bool {
    let result = busctl --user get-property org.kde.StatusNotifierWatcher /StatusNotifierWatcher org.kde.StatusNotifierWatcher IsStatusNotifierHostRegistered | complete

    $result.exit_code == 0 and ($result.stdout | str trim) == "b true"
}

# Wait until the tray exists, so that a program started afterwards shows its tray icon.
def main [
    --timeout (-t): duration = 2min # how long to wait for the tray
]: nothing -> nothing {
    let attempts = $timeout // $INTERVAL

    for attempt in 1..$attempts {
        if (host-registered) {
            let waited = $INTERVAL * ($attempt - 1)

            log info $"the tray is ready after ($waited)"
            return
        }

        sleep $INTERVAL
    }

    log warning "no tray appeared, going on without one"
}

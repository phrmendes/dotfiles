# Capture with niri, then annotate the result with swappy.
def main [mode: string = "screenshot"] {
    let path = "/tmp/niri-screenshot.png"

    ^rm -f $path
    ^niri msg action $mode

    mut ticks = 0
    while (not ($path | path exists)) and $ticks < 600 {
        sleep 100ms
        $ticks = $ticks + 1
    }

    if not ($path | path exists) {
        exit 0
    }

    ^swappy -f $path
}

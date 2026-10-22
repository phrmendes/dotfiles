# Stop with an error that points at an argument of the caller.
export def fail [
    message: string # what went wrong
    culprit?: string # the argument of the caller that the label points at, or the message when empty
    --text (-t): string = "raised here" # the text of the label
]: oneof<nothing, record> -> error {
    $in | ignore

    let message_span = (metadata $message).span
    let culprit_span = (metadata $culprit).span
    let span = if $culprit == null { $message_span } else { $culprit_span }

    error make {
        msg: $message
        label: {text: $text, span: $span}
    }
}

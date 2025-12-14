set -l sessions (zellij list-sessions --no-formatting)
set -l session_count (count $sessions)

if test $session_count -le 1
    zellij attach --create "default"
else
    set -l formatted_sessions

    for session in $sessions
        set -l session_name (echo $session | string split ' ' | head -1)

        if string match -q "*EXITED*" $session
            set -a formatted_sessions "$session_name [󰚌]"
        else
            set -a formatted_sessions "$session_name"
        end
    end

    set -l selected (printf '%s\n' $formatted_sessions | fzf \
        --height=6 \
        --layout=reverse \
        --border=rounded \
        --prompt=" Select session: " \
        --info=inline)

    if test -n "$selected"
        set -l session_name (echo $selected | string split ' ' | head -1)
        zellij attach $session_name
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

# run yazi, keeping cwd from yazi when dropping back
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function fish_greeting
    # set_color magenta
    # echo "Welcome to fish :)"
    # set_color --reset
end

zoxide init fish | source

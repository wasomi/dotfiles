if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

if test -f ./custom.fish
    source ./custom.fish
end

function fish_greeting
    fastfetch
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'"                                   # show only dotfiles
alias h="start-hyprland"                                            # hyprland
alias cat="bat"                                                     # cat=bat
alias i="sudo pacman -S"                                            # install pkg
alias ia="paru -S"                                                  # install aur pkg
alias s="pacman -Ss"                                                # search pkg
alias sa="paru -Ss"                                                 # search aur pkg

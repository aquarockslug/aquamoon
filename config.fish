if status is-interactive
	set fish_greeting
	set -x BROWSER glide-bin
	set -x EDITOR neovide
	clear && ls
end

alias q="exit"
alias ls="eza"
alias lg="lazygit"
alias df="duf"
alias du="dust"
alias l="clear && ls"

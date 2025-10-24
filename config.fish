if status is-interactive
	set fish_greeting
	set -x BROWSER glide-bin
	set -x EDITOR neovide
	set -x LS_COLORS "$(vivid generate catppuccin-frappe)"
	clear && ls
end

alias q="exit"
alias ls="eza"
alias lg="lazygit"
alias df="duf"
alias du="dust"
alias cat="bat --theme fly16"
alias l="clear && ls"

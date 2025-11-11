if status is-interactive
	set fish_greeting
	set -x BROWSER glide-bin
	set -x EDITOR neovide
	set -x LS_COLORS "$(vivid generate catppuccin-frappe)"
	clear && ls
end

# highlight help messages
abbr -a --position anywhere -- --help '--help | bat -plhelp'
abbr -a --position anywhere -- -h '-h | bat -plhelp'

# alias
alias q="exit"
alias s="sudo"
alias ls="eza"
alias lg="lazygit"
alias df="duf"
alias du="dust"
alias cat="bat --theme fly16"
alias l="clear && ls"
alias yank="wl-copy"
alias put="wl-paste"
alias chmodx="sudo chmod u+x "

alias issues="gh issue view --comments (
	string split '\t' (
		string escape (
			gh issue list | peco --prompt ISSUES
		)
	)
)[1]"

# source (tv init fish)

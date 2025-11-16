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

# completions
tv init fish | source

# alias
alias cat="bat --theme fly16"
alias chmodx="sudo chmod u+x "
alias ddgr="ddgr --reverse"
alias df="duf"
alias du="dust"
alias l="clear && ls"
alias lg="lazygit"
alias ls="eza"
alias put="wl-paste"
alias q="exit"
alias s="sudo"
alias v="nvim"
alias yank="wl-copy"
alias f="tv files"
alias g="tv text"

alias issues="gh issue view --comments (
	string split '\t' (
		string escape (
			gh issue list | peco --prompt ISSUES
		)
	)
)[1]"

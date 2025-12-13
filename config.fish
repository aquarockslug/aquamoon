if status is-interactive
	set fish_greeting
	set -x LS_COLORS "$(vivid generate catppuccin-frappe)"
	clear && ls
end

# highlight help messages
abbr -a --position anywhere -- --help '--help | bat -plhelp'
abbr -a --position anywhere -- -h '-h | bat -plhelp'

set VISUAL /bin/neovide

# completions
tv init fish | source

# alias
alias cat="bat"
alias chmodx="sudo chmod u+x "
alias ddgr="ddgr --reverse"
alias df="duf"
alias du="dust"
alias g="tv text"
alias hist="history"
alias l="clear && ls"
alias lg="lazygit"
alias lo="libreoffice"
alias ls="eza"
alias rs="rsync -Pr"
alias put="wl-paste"
alias q="exit"
alias s="sudo"
alias top="htop"
alias serve="abduco -c http_server /bin/simple-http-server --nocache"
alias v="nvim"
alias yank="wl-copy"
alias r="pushd ( tv git-repos )"
alias b="pushd ( tv git-branches )"

alias issues="gh issue view --comments (
	string split '\t' (
		string escape (
			gh issue list | peco --prompt ISSUES
		)
	)
)[1]"

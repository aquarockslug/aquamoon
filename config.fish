if status is-interactive
	set fish_greeting
	set -x LS_COLORS "$(vivid generate catppuccin-frappe)"

	# highlight help messages
	abbr -a --position anywhere -- --help '--help | bat -plhelp'
	abbr -a --position anywhere -- -h '-h | bat -plhelp'

	# completions
	tv init fish | source
	cat ~/.aquamoon/etc/aura.fish | source

	# fish_vi_key_bindings
	
	# fish_config theme choose catppuccin-frappe
	# fish_config theme choose dracula

	clear && ls
end


# alias
alias cat="bat"
alias chmodx="sudo chmod u+x "
alias ddgr="ddgr --reverse"
alias df="duf"
alias du="dust"
alias l="clear && ls"
alias lg="lazygit"
alias ls="eza"
alias rs="rsync -Pr"
alias put="wl-paste"
alias q="exit"
alias s="sudo"
alias top="htop"
alias serve="abduco -c http_server /bin/simple-http-server --nocache"
alias v="nvim"
alias yank="wl-copy"
alias g="tv text"
alias r="pushd ( tv git-repos )"
alias b="pushd ( tv git-branches )"
alias issues="tv gh-issues"
alias jsinfo='ddgr --gb --np !jsinfo'

# The main file of the aqua_profile plugin

# settings
zstyle ':omz:update' mode auto
export EDITOR='nvim'
export BROWSER='firefox'
export OPENER='wsl-open'
export DISABLE_AUTO_TITLE='true'
export NAP_DEFAULT_LANGUAGE='md'
export ZELLIJ_CONFIG_FILE=~/.config/zellij/config.kdl
bindkey ' ' magic-space

# SYSTEM
alias q="exit"
alias s="sudo"
alias open="wsl-open"

# applications
alias b="buku --suggest"
alias f="felix"
alias fx="felix"
alias g="glow"
alias ddgr="ddgr --rev"
alias ld="lazydocker"
alias lg="lazygit"
alias mail="aerc"
alias p="python"
alias py="python"
alias v="nvim"
alias vnim="nvim"

# system info
alias ls="exa -l"
alias lss="exa *"
alias cls="clear && ls"
alias clss="clear && lss"
alias tasks="ps aux"
alias fd="sudo fdisk -l"
alias df="duf"
alias du="dust"
alias cat="bat"
alias top="htop"

# clipboard
# TODO: non-windows copy/paste
alias yank="wcopy"
alias put="wpaste"

# source other aqua plugin files
source ${0:A:h}/aqua_functions.zsh
source ${0:A:h}/aqua_theme.zsh
# source ${0:A:h}/aqua_tmux.zsh

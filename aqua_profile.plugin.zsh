# The main file of aqua`s profile plugin

# check for Windows Subsystem for Linux
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]];
then WSL=true; else WSL=false; fi


# ENVIRONMENT
export EDITOR='nvim';
export BROWSER='firefox'
[ $WSL = true ] && export OPENER='wsl-open'

export DISABLE_AUTO_TITLE='true'
export NAP_DEFAULT_LANGUAGE='md'
export ZELLIJ_CONFIG_DIR=/etc/zellij; export ZELLIJ_CONFIG_FILE=/etc/zellij/config.kdl
# export GDK_DPI_SCALE=1.5

# SYSTEM
zstyle ':omz:update' mode auto
bindkey ' ' magic-space

alias q="exit"
alias s="sudo"
[ $WSL = true ] && alias open="wsl-open"

# clipboard
alias yank="xclip -selection clipboard" && alias put="xclip -o -selection clipboard"
[ $WSL = true ] && alias yank="wcopy" && alias put="wpaste" # use wsl-clipboard if on WSL
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

# MOVEMENT
alias h="cd ~"
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

# APPLICATIONS
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
alias c="code"
alias v="nvim"
alias vnim="nvim"

alias zj="zellij"
alias zje="zellij action edit"
alias zjv="zje"
alias zjl="zellij run -- lf"
alias zjlf="zjl"

bindkey -s '^f' 'zellij run -- lf \n'

# source the other aqua plugin files
source ${0:A:h}/aqua_functions.zsh
source ${0:A:h}/aqua_theme.zsh

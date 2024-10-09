#!/bin/bash

# The main file of the aqua_profile plugin

# check for Windows Subsystem for Linux
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop || "$TERM_PROGRAM" = 'vscode' ]]
then WSL=true; else WSL=false; fi

# SETTINGS
zstyle ':omz:update' mode auto
export EDITOR='nvim';
export BROWSER='firefox'
[ $WSL = true ] && export BROWSER='wsl-open'
[ $WSL = true ] && export OPENER='wsl-open'

export DISABLE_AUTO_TITLE='true'
export NAP_DEFAULT_LANGUAGE='md'
export ZELLIJ_CONFIG_DIR=/etc/zellij; export ZELLIJ_CONFIG_FILE=/etc/zellij/config.kdl
# export GDK_DPI_SCALE=1.5
bindkey ' ' magic-space

# SYSTEM
alias q="exit"
alias s="sudo"
[ $WSL = true ] && alias open='"$OPENER"'

# CLIPBOARD
alias yank="xclip -selection clipboard" && alias put="xclip -o -selection clipboard"
[ $WSL = true ] && alias yank="wcopy" && alias put="wpaste" # use wsl-clipboard if on WSL

# SYSTEM INFO
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
alias h='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

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

alias e='"$EDITOR"'
alias v="nvim"
alias vnim="nvim"

alias zj="zellij"
alias zje="zellij action edit"
alias zjv="zellij action edit"
alias zjl="zellij run -- lf"
alias zjlf="zjl"

bindkey -s '^f' 'lfcd \n'

# source the other aqua plugin files
source "${0:A:h}"/aqua_functions.zsh
source "${0:A:h}"/aqua_theme.zsh

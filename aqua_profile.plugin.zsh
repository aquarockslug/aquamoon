# The main file of the aqua_profile plugin

# check for Windows Subsystem for Linux
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]];
then WSL=true; else WSL=false; fi

# SETTINGS
zstyle ':omz:update' mode auto
export EDITOR='nvim'
export BROWSER='firefox'
if [ $WSL ]; then export OPENER='wsl-open'; fi
export DISABLE_AUTO_TITLE='true'
export NAP_DEFAULT_LANGUAGE='md'
export ZELLIJ_CONFIG_DIR=/etc/zellij
export ZELLIJ_CONFIG_FILE=/etc/zellij/config.kdl
export GDK_DPI_SCALE=1.5
bindkey ' ' magic-space

# SYSTEM
alias q="exit"
alias s="sudo"
if [ $WSL ]; then alias open="wsl-open"; fi

# CLIPBOARD
alias yank="xclip -selection clipboard"; alias put="xclip -o"
if [ $WSL ]; then alias yank="wcopy"; alias put="wpaste"; fi # use wsl-clipboard if on WSL

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
alias ..='cd ../'
alias ../='cd ../'
alias ../../='cd ../../'
alias ../..='cd ../../'
alias ../../../='cd ../../../'
alias ../../..='cd ../../../'

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
alias v="nvim"
alias vnim="nvim"
alias zj="zellij"

# source the other aqua plugin files
source ${0:A:h}/aqua_functions.zsh
source ${0:A:h}/aqua_theme.zsh

source ${0:A:h}/aqua_functions.zsh
source ${0:A:h}/aqua_theme.zsh
source ${0:A:h}/aqua_tmux.zsh

zstyle ':omz:update' mode auto
export EDITOR='nvim'
export BROWSER='firefox'
# export PAGER='gum pager'
# export MANPATH="/usr/local/man"
export DISABLE_AUTO_TITLE='true'

# apps
alias p="python"
alias py="python"
alias s="sudo"
alias b="buku --suggest"
alias f="felix"
alias lg="lazygit"
alias ld="lazydocker"
alias g="glow"
alias glow="glow -s ~/aqua_arch/dracula/glow/dracula.json"
alias fx="felix"
alias mail="aerc"
alias open="wsl-open"

# nvim
alias v="nvim"
alias vi="nvim"
alias vnim="nvim"

# system
alias tasks="ps aux"
alias fd="sudo fdisk -l"
alias df="duf"
alias du="dust"
alias cat="bat"
alias top="htop"
alias clip="wcopy"

alias ls="exa -l"
alias lss="exa *"
alias cls="clear && ls"
alias clss="clear && lss"

bindkey ' ' magic-space

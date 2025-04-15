
ZSH_THEME="dracula"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting
source /home/aqua/.aquamoon/aqua_profile.plugin.zsh

autoload -Uz compinit && compinit
if [[ -z $ZELLIJ ]]; then
if [[ $ZELLIJ_AUTO_ATTACH == "true" ]];
then zellij attach -c;
else zellij -c /home/aqua/.aquamoon/zellij.kdl; fi;
if [[ $ZELLIJ_AUTO_EXIT == "true" ]]; then exit; fi; fi
# clear && ls

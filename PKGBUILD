#!/bin/bash

# Maintainer: Aquarock <aqua.rock.slug@gmail.com>
# My personal arch linux setup

pkgname=aqua_arch
pkgver=0.1
pkgrel=1
pkgdesc="My personal zsh and nvim configuration"
arch=('i686' 'x86_64')
url="https://github.com/aquarockslug/aqua_arch"
license=('GPL')
groups=('base-devel')
depends=('sudo' 'git' 'lazygit' 'zsh' 'zellij' 'neovim' 'glow' 'wget' 'bat' 'eza' 'duf' 'htop'
	'dust' 'ripgrep' 'peco' 'gum' 'p7zip' 'rsync' 'openssh' 'net-tools' 'openssh'
	'zsh-syntax-highlighting' 'zsh-autosuggestions' 'lf' 'ddgr')
makedepends=()
optdepends=('docker' 'lazydocker' 'aerc' 'nodejs' 'pnpm' 'python' 'github-cli' 'buku-git' 'tldr' 'nap-bin' 'geeqie')
source=("https://raw.githubusercontent.com/mafredri/zsh-async/main/async.zsh"
	"https://gist.githubusercontent.com/pwang2/a6b77bbc7f6e1f7016f6566fab774a77/raw/e4406aa664bde17baa406d35b63c78b5ca6e2065/dracula.zsh-theme"
	"https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
	# source files
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_functions.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_profile.plugin.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_theme.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/init.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/config.kdl"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/dracula.json"
)
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP')
package() {
	# % glow %
	mkdir -pv "${pkgdir}"/usr/share/glow
	cp "${srcdir}"/dracula.json "${pkgdir}"/usr/share/glow/
	{
		echo "style: '/usr/share/glow/dracula.json'"
		echo "mouse: false"
		echo "pager: false"
		echo "width: 120"
	} >"${pkgdir}"/usr/share/glow/glow.yml

	# % lf %
	mkdir -pv "${pkgdir}"/etc/lf
	echo
	(
		cat <<EOM
cmd toggle-preview %{{
    if [ \$lf_width -le 80 || \$lf_preview ]; then
        lf -remote "send \$id :set preview false; set ratios 1"
    else lf -remote "send \$id :set preview true; set ratios 1:2:3"; fi
}}
map zp toggle-preview
map e \$zellij run -c -d right -- nvim \$f
EOM
	) >>"${pkgdir}"/etc/lf/lfrc

	# % zsh %
	mkdir -pv "${pkgdir}"/usr/share/zsh/themes/lib
	cp "${srcdir}"/*.zsh "${pkgdir}"/usr/share/zsh                               # move all zsh files into /usr/share/zsh
	mv "${pkgdir}"/usr/share/zsh/async.zsh "${pkgdir}"/usr/share/zsh/themes/lib/ # then move theme files
	cp "${srcdir}"/dracula.zsh-theme "${pkgdir}"/usr/share/zsh/themes/dracula.zsh-theme

	# % zellij %
	mkdir -pv "${pkgdir}"/etc/zellij/
	cp "${srcdir}"/config.kdl "${pkgdir}"/etc/zellij/
	cp "${srcdir}"/zjstatus.wasm "${pkgdir}"/etc/zellij/

	# set zellij flag color by picking a random color from dracula.json
	# COLORS=COLORS "$(jq .document.color <./dracula.json)"
	# COLORS=COLORS "$(jq .block.color <./dracula.json)"
	# COLORS=COLORS "$(jq .paragraph.color <./dracula.json)"
	# use sed

	# create .zshrc
	{
		echo "source /usr/share/zsh/themes/lib/async.zsh"
		echo "source /usr/share/zsh/themes/dracula.zsh-theme"
		echo "source /usr/share/zsh/aqua_profile.plugin.zsh"
		echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
		echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
		echo "autoload -Uz compinit && compinit" # text completion
		echo "if [[ -z \"\$ZELLIJ\" ]]; then"
		echo "if [[ '\$ZELLIJ_AUTO_ATTACH' == 'true' ]];"
		echo "then zellij attach -c; else zellij -l /etc/zellij/config.kdl; fi;"
		echo "if [[ '\$ZELLIJ_AUTO_EXIT' == 'true' ]]; then exit; fi; fi"
		echo "clear && ls"
	} >"${pkgdir}"/etc/zshrc

	# % neovim %
	mkdir -pv "${pkgdir}"/etc/xdg/nvim/plugin
	cp "${srcdir}"/init.lua "${pkgdir}"/etc/xdg/nvim/plugin
}

# Maintainer: Aquarock <aqua.rock.slug@gmail.com>
pkgname=aqua_arch
pkgver=0.1
pkgrel=1
pkgdesc="My personal zsh and nvim configuration"
arch=('i686' 'x86_64')
url="https://github.com/aquarockslug/aqua_arch"
license=('GPL')
groups=('base-devel')
depends=('sudo' 'git' 'lazygit' 'zsh' 'neovim' 'wget' 'bat' 'eza' 'duf' 'peco' 'ddgr')
makedepends=()
optdepends=('lazydocker' 'aerc' 'nodejs' 'pnpm' 'github-cli' 'glow' 'gum' 'nap-bin')
source=("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	"https://raw.githubusercontent.com/mafredri/zsh-async/main/async.zsh"
	"https://gist.githubusercontent.com/pwang2/a6b77bbc7f6e1f7016f6566fab774a77/raw/e4406aa664bde17baa406d35b63c78b5ca6e2065/dracula.zsh-theme"
	# aqua source files
	"aqua_functions.zsh" "aqua_profile.plugin.zsh" "aqua_tmux.zsh" "aqua_theme.zsh"
	"init.lua" "clipboard.lua" "keymap.lua" "telescope.lua" "tmux.conf")
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP')
package() {

	# package zsh files
	mkdir -p "${pkgdir}"/usr/share/zsh
	cp "${srcdir}"/*.zsh "${pkgdir}"/usr/share/zsh/

	# create .zshrc file
	mkdir -p "${pkgdir}"/root
	echo "source /usr/share/zsh/aqua_profile.plugin.zsh" >"${pkgdir}"/root/.zshrc
	echo "source /usr/share/zsh/themes/dracula.zsh-theme" >>"${pkgdir}"/root/.zshrc
	echo "source /usr/share/zsh/async.zsh" >>"${pkgdir}"/root/.zshrc
	echo "clear && ls" >>"${pkgdir}"/root/.zshrc

	mv "${srcdir}"/tmux.conf "${pkgdir}"/root/.tmux.conf

	# TODO: add zsh highlighting and autocompletion

	# zsh theme
	mkdir -p "${pkgdir}"/usr/share/zsh/themes
	cp "${srcdir}"/dracula.zsh-theme "${pkgdir}"/usr/share/zsh/themes/dracula.zsh-theme

	# package neovim files
	mkdir -p "${pkgdir}"/usr/share/nvim_plugged/
	mkdir -p "${pkgdir}"/root/.config/nvim/plugin
	cp "${srcdir}"/*.lua "${pkgdir}"/root/.config/nvim/plugin
	cp "${srcdir}"/*.vim "${pkgdir}"/root/.config/nvim/plugin
}

# Maintainer: Aquarock <aqua.rock.slug@gmail.com>
pkgname=aqua_arch
pkgver=0.1
pkgrel=1
pkgdesc="My personal zsh and nvim configuration"
arch=('i686' 'x86_64')
url="https://github.com/aquarockslug/aqua_arch"
license=('GPL')
groups=('base-devel')
depends=('sudo' 'git' 'lazygit' 'zsh' 'zellij' 'neovim' 'wget' 'bat' 'eza' 'duf' 'dust' 'ripgrep' 'peco' 'gum' 'p7zip' 'rsync' 'ddgr' 'openssh')
makedepends=()
optdepends=('lazydocker' 'aerc' 'nodejs' 'pnpm' 'python' 'github-cli' 'glow' 'buku-git' 'nap-bin' 'geeqie')
source=("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	"https://raw.githubusercontent.com/mafredri/zsh-async/main/async.zsh"
	"https://gist.githubusercontent.com/pwang2/a6b77bbc7f6e1f7016f6566fab774a77/raw/e4406aa664bde17baa406d35b63c78b5ca6e2065/dracula.zsh-theme"
	# aqua source files
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_functions.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_profile.plugin.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_theme.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/init.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/keymap.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/telescope.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/clipboard.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/config.toml"
)
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP')
package() {

	# package zsh files
	mkdir -p "${pkgdir}"/usr/share/zsh
	cp "${srcdir}"/*.zsh "${pkgdir}"/usr/share/zsh/
	rm "${pkgdir}"/usr/share/zsh/async.zsh

	# zsh theme
	mkdir -p "${pkgdir}"/usr/share/zsh/themes/lib
	cp "${srcdir}"/async.zsh "${pkgdir}"/usr/share/zsh/themes/lib/
	cp "${srcdir}"/dracula.zsh-theme "${pkgdir}"/usr/share/zsh/themes/dracula.zsh-theme

	# zellij theme
	mkdir -p "${pkgdir}"/home/aqua/.config/zellij
	cp "${srcdir}"/config.toml "${pkgdir}"/home/aqua/.config/zellij/config.toml

	# create .zshrc file
	mkdir -p "${pkgdir}"/home/aqua/
	echo "source /usr/share/zsh/themes/lib/async.zsh" >"${pkgdir}"/home/aqua/.zshrc
	echo "source /usr/share/zsh/themes/dracula.zsh-theme" >>"${pkgdir}"/home/aqua/.zshrc
	echo "source /usr/share/zsh/aqua_profile.plugin.zsh" >>"${pkgdir}"/home/aqua/.zshrc
	# echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" >>"${pkgdir}"/home/aqua/.zshrc
	echo "" >>"${pkgdir}"/home/aqua/.zshrc
	echo "if [[ -z '\$ZELLIJ' ]]; then" >>"${pkgdir}"/home/aqua/.zshrc
	echo "if [[ '\$ZELLIJ_AUTO_ATTACH' == 'true' ]];" >>"${pkgdir}"/home/aqua/.zshrc
	echo "then zellij attach -c; else zellij; fi" >>"${pkgdir}"/home/aqua/.zshrc
	echo "if [[ '\$ZELLIJ_AUTO_EXIT' == 'true' ]]; then exit fi fi" >>"${pkgdir}"/home/aqua/.zshrc
	echo "" >>"${pkgdir}"/home/aqua/.zshrc
	echo "clear && ls" >>"${pkgdir}"/home/aqua/.zshrc

	# package neovim files
	mkdir -p "${pkgdir}"/home/aqua/.config/nvim/plugin
	mkdir -p "${pkgdir}"/usr/share/nvim_plugged/
	chmod 775 /usr/share/nvim_plugged/
	cp "${srcdir}"/*.lua "${pkgdir}"/home/aqua/.config/nvim/plugin
	cp "${srcdir}"/*.vim "${pkgdir}"/home/aqua/.config/nvim/plugin
}

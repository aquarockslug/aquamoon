# Maintainer: Aquarock <aqua.rock.slug@gmail.com>
pkgname=aqua_arch
pkgver=0.1
pkgrel=1
pkgdesc="My personal zsh and nvim configuration"
arch=('i686' 'x86_64')
url="https://github.com/aquarockslug/aqua_arch"
license=('GPL')
groups=('base-devel')
depends=('sudo' 'git' 'lazygit' 'zsh' 'zellij' 'neovim' 'glow' 'wget' 'bat' 'pandoc-cli'
	'eza' 'duf' 'dust' 'ripgrep' 'peco' 'gum' 'p7zip' 'rsync' 'openssh'
	'zsh-syntax-highlighting' 'zsh-autosuggestions')
makedepends=()
optdepends=('ddgr' 'docker' 'lazydocker' 'aerc' 'nodejs' 'pnpm' 'python' 'github-cli' 'buku-git' 'tldr' 'nap-bin' 'geeqie')
source=("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	"https://raw.githubusercontent.com/mafredri/zsh-async/main/async.zsh"
	"https://gist.githubusercontent.com/pwang2/a6b77bbc7f6e1f7016f6566fab774a77/raw/e4406aa664bde17baa406d35b63c78b5ca6e2065/dracula.zsh-theme"
	"https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
	# source files
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_functions.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_profile.plugin.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/aqua_theme.zsh"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/init.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/keymap.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/telescope.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/clipboard.lua"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/config.kdl"
	"https://github.com/aquarockslug/aqua_arch_configs/raw/main/dracula.json"
)
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP')
package() {

	# package zsh files
	mkdir -pv -m 775 "${pkgdir}"/home/aqua/.config/glow
	mkdir -pv -m 775 "${pkgdir}"/usr/share/zsh/themes/lib

	# glow theme
	# TODO: glow completion zsh
	# autoload -Uz compinit; compinit
	cp "${srcdir}"/dracula.json "${pkgdir}"/home/aqua/.config/glow/                            # move all zsh files into /usr/share/zsh
	echo "style: '~/.config/glow/dracula.json'" >"${pkgdir}"/home/aqua/.config/glow/glow.yml
	echo "mouse: false" >>"${pkgdir}"/home/aqua/.config/glow/glow.yml
	echo "pager: false" >>"${pkgdir}"/home/aqua/.config/glow/glow.yml
	echo "width: 120" >>"${pkgdir}"/home/aqua/.config/glow/glow.yml

	cp "${srcdir}"/*.zsh "${pkgdir}"/usr/share/zsh                                        # move all zsh files into /usr/share/zsh
	mv "${pkgdir}"/usr/share/zsh/async.zsh "${pkgdir}"/usr/share/zsh/themes/lib/          # then move theme files
	cp "${srcdir}"/dracula.zsh-theme "${pkgdir}"/usr/share/zsh/themes/dracula.zsh-theme

	# zellij theme
	# TODO: dont put any files in /home/aqua
	mkdir -pv -m 775 "${pkgdir}"/etc/zellij
	cp "${srcdir}"/config.kdl "${pkgdir}"/etc/zellij/config.kdl
	cp "${srcdir}"/zjstatus.wasm "${pkgdir}"/etc/zellij/zjstatus.wasm

	# create .zshrc file
	ZSHRC="${pkgdir}"/home/aqua/.zshrc
	echo "source /usr/share/zsh/themes/lib/async.zsh" > "$ZSHRC"
	echo "source /usr/share/zsh/themes/dracula.zsh-theme" >>"$ZSHRC"
	echo "source /usr/share/zsh/aqua_profile.plugin.zsh" >>"$ZSHRC"
	echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>"$ZSHRC"
	echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" >>"$ZSHRC"
	echo "autoload -Uz compinit && compinit" >>"$ZSHRC" # text completion
	echo "" >>"$ZSHRC"; echo "if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then" >>"$ZSHRC" # don't autostart zellij when using WSL
	echo "if [[ -z \"\$ZELLIJ\" ]]; then" >>"$ZSHRC"
	echo "if [[ '\$ZELLIJ_AUTO_ATTACH' == 'true' ]];" >>"$ZSHRC"
	echo "then zellij attach -c; else zellij; fi;" >>"$ZSHRC"
	echo "if [[ '\$ZELLIJ_AUTO_EXIT' == 'true' ]]; then exit; fi; fi; fi" >>"$ZSHRC"
	echo "" >>"$ZSHRC"; echo "clear && ls" >>"$ZSHRC"

	# package neovim files
	mkdir -pv -m 775 "${pkgdir}"/usr/share/nvim_plugged/
	mkdir -pv -m 775 "${pkgdir}"/etc/xdg/nvim/plugin
	cp "${srcdir}"/*.lua "${pkgdir}"/etc/xdg/nvim/plugin
	cp "${srcdir}"/*.vim "${pkgdir}"/etc/xdg/nvim/plugin
}

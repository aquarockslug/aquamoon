# aqua arch installer

build() {
	if [ -f /bin/updpkgsums ]; then /bin/updpkgsums; fi
	rm ./*.pkg.tar.lz4
	PKGEXT='.pkg.tar.lz4' gum spin --title "Building..." -- makepkg >>/dev/null
}

install() {
	msg="ERROR"
	if echo * | grep "$PKGEXT"; then # new package was created, install with pacman
		gum spin --title "Installing..." -- sudo pacman --noconfirm -U -- *.pkg.tar.lz4 >>/dev/null
		msg="aqua_arch installed!"
	fi >>/dev/null
	gum style --foreground 212 --align center --margin "1 2" "󰈿  $msg  󰈿"
}

if [ ! "$1" ] || [ "$1" = 'install' ]; then
	pacman -Q --info aqua_arch | grep 'Install Date'
	sudo echo
	build
	install
	pacman -Q --info aqua_arch | grep 'Install Date'
fi

if [ "$1" = "light" ] || [ "$2" = "light" ]; then
	sudo cp light_neovim.lua /etc/xdg/nvim/plugin/init.lua
	echo 'using light neovim'
fi

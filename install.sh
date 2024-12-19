# aqua arch installer

rm ./*.pkg.tar.lz4
PKGEXT='.pkg.tar.lz4' makepkg >>/dev/null

msg="ERROR"
if echo * | grep "$PKGEXT"; then # new package was created, install with pacman
	sudo pacman --noconfirm -U -- *"$PKGEXT" >>/dev/null
	msg="aqua_arch installed!"
fi >>/dev/null
printf "\n 󰈿 %s \n \n" "$msg"

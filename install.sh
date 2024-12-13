rm ./*.pkg.tar.lz4
source ./makepkg.conf
sudo pacman -U *.pkg.tar.lz4


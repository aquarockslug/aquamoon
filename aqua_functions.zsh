# zsh functions

# SYSTEM
hist() { peco < $HISTFILE } # search history
chmodx() { sudo chmod u+x $1 } # give execution privileges to file

# APPS
n() { nap $(nap list | peco) | glow } # quick open notes
nap_import() { cd $1; for f in  */*; do nap $f < $f; done } # import from given nap source directory
# TODO: make nap_export function, automatically run on close

docs() { $(gum choose "cht" "cheat" "cd /home/aqua/home/share/docs" "firefox overapi.com/" "firefox quickref.me" "tldr") }

cht() {
  cht.sh $(gum input --placeholder "language...") \
  $(gum input --placeholder "query...") | gum pager
}

# DOWNLOAD
dlp() { if [ -z ${*+x} ]; then yt-dlp $(gum write); else yt-dlp $*; fi } # download given file
dls() { wget -q -O - $2 | nap $1 }
activate() { source ./bin/activate } # activate python env


# EDITING
clip_video() {
	CLIP=$1; NAME=${CLIP%.*}; OUTPUT=$NAME.clip.mp4
	echo Start:; START=$(gum input --placeholder "00:00")
	echo Duration:; DURATION=$(gum input --placeholder "00:00")
	ffmpeg -y -i $CLIP -ss 00:$START -t 00:$DURATION -async -1 $OUTPUT
	echo Clipped $DURATION seconds from $NAME
}

gif() {
	CLIP=$1
	ffmpeg -y -i $CLIP -filter_complex "fps=12,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=32[p];[s1][p]paletteuse=dither=bayer" ${CLIP%.*}.gif
	echo Created ${CLIP%.*}
}

speedup() {
	ffmpeg -i $1 -vf "setpts=0.5*PTS" -filter:a "atempo=2" ${1%.*}_fast.mp4
}

optimg() {
	PNG=false; JPG=false;
	if gum confirm "Optimize $(ls **/*.png | wc -l) png files in $(pwd)?"; then PNG=true; fi;
	if gum confirm "Optimize $(ls **/*.jpg | wc -l) jpeg files in $(pwd)?"; then JPG=true; fi;
	if $PNG; then for f in **/*.png; do optipng $f; done; fi;
	if $JPG; then for f in **/*.jpg; do jpegoptim $f; done; fi;
}

# TODO: find duplicated images

if status is-interactive
	set fish_greeting
	set -x BROWSER glide-bin
	clear && ls
end

# add cargo to path for shpool
# using cargo because aur shpool broken

function l
	clear && ls $argv
end

function q
	exit
end

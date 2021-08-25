#!/bin/bash

# set -x # Run in debug mode.
# set -n # Run w\o execution.

kali(){
	{
		echo '
		"preload"
		"gdb"
		"cgdb"
		"bleachbit"
		"zsh"
		"neofetch"
		"bum"
		"gnome-do"
		"bum"
		"shutter"
		"scrub"
		"apt-file"
		"cmatrix"
		"lazy"
		"tree"
		"speedtest-cli"
		"cdebootstrap"
		"live-build"
		"git"
		"curl"
		"dnsutils"
		'
	} | xargs -I "{}" apt --assume-yes install {}  2> error.log 1> /dev/null

}


getUtils(){
	local source_url="https://dede.dev/run/"
	rc_files=(".zshrc" ".bashrc" ".vimrc" ".bash_aliases" "clean" ".screenrc")

	for rcFile in "${rc_files[@]}"
	do
		wget "$source_url""$rcFile" -O ~/."$rcFile" &> /dev/null
	done

	# Installing Oh My Zsh
	#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	# Install PowerLeve10K theme
	#git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

	# get Nerd fonts
	#wget "$source_url""Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf"
	#wget "$source_url""Fura\ Mono\ Regular\ Nerd\ Font\ Complete.otf"

	# Autosuggestion 
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM"/plugins/zsh-autosuggestions

	# syntax highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM"/plugins/zsh-syntax-highlighting
}

#main 
SYSTEM=$(uname)

if [ "$SYSTEM" = "kali" ]; then
	kali && getUtils 
else 
	getUtils
fi
# TODO:curl http://j.mp/spf13-vim3 -L -o - | sh


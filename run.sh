#!/bin/bash

# set -x # Run in debug mode.
# set -n # Run w\o execution.

# determine the Linux system environment.
system=$(uname -a | cut -d" " -f 2)

# If system is Kali
if [ "$system" = "kali" ]; then
	# Array list of the tools to install.
  # TODO tun below to a funtion.
	arr=(
		"preload"
		"cargo"
		"tor"
		"proxychains"
		"neofetch"
		"gdb"
		"cgdb"
		"bleachbit"
		"zsh"
		"neofetch"
		"bum"
		"gnome-do"
		"bum"
		#  "figlet"
		"shutter"
		"scrub"
		"apt-file"
		"cmatrix"
		"lazy"
		"tree"
		"speedtest-cli"
		"dnsutils"
	)
# curl https://raw.githubusercontent.com/linuxacademy/content-python3-sysadmin/master/helpers/bashrc -o ~/.bashrc

# curl https://raw.githubusercontent.com/linuxacademy/content-python3-sysadmin/master/helpers/vimrc -o ~/.vimrc

# Install tools.
for tools in "${arr[@]}"
do
	apt install "$tools"
done

fi

# Create run dir
mkdir ~/run

# url path
url="https://dede.dev/run/"

# Copy run and clean scripts, screenrc bash_aliases files.
curl "$url".bashrc -o ~/.bashrc
curl "$url".vimrc -o ~/.vimrc
curl "$url".screenrc -o ~/.screenrc
curl "$url".bash_aliases -o ~/.bash_aliases
curl "$url"clean -o ~/clean



#!/bin/bash

# set -x # Run in debug mode.
 set -n # Run w\o execution.

Install_tools(){
	# Array list of the tools to install.
	arr=(
		#"figlet"
		"preload"
		"cargo"
		"tor"
		"macchanger"
		"proxychains"
		"nmap"
		"proxychains"
		"neofetch"
		"gdb"
		"cgdb"
		"bleachbit"
		"zsh"
		"neofetch"
		"gnome-do"
		"bum"
		"shutter"
		"scrub"
		"apt-file"
		"cmatrix"
		"lazy"
		"tree"
		"speedtest-cli"
		"tmux"
		"dnsutils"
		)

	# Install tools.
	for tool in "${arr[@]}"
	do
		apt -y install "$tool" &> /dev/null
	done
}

# find the Linux system environment.
system=$(uname -a | cut -d" " -f1)

# If system is Kali
if [ "$system" = "kali" ]; 
then
	Install_tools;
elif [ "$system" = Darwin ];
	then
	continue
else
	read -p "Do you want to install Network tools and utils? (y/n) " answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ];
	then
		Install_tools;
	 else
		continue
	fi
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

	# TODO
	# curl https://raw.githubusercontent.com/linuxacademy/content-python3-sysadmin/master/helpers/bashrc -o ~/.bashrc
	# curl https://raw.githubusercontent.com/linuxacademy/content-python3-sysadmin/master/helpers/vimrc -o ~/.vimrc
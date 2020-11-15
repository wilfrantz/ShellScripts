#!/bin/bash


#set -x
#set -n


set -x
############################ Global Variables 
CURRENT_SHELL=$(echo $SHELL | cut -d"/" -f3)
SYSTEM=$(uname -a | cut -d" " -f1)

command_exists() {
    local ret=0
    command -v $1 > /dev/null 2>&1 { local ret=1}

    if [ "$ret" -ne 0 ]; then 
            return 1
    fi
}

# install ZSH shell on your operating system
setup_zsh(){
   if [ "$CURRENT_SHELL" != "zsh" ]
     then 
        if [ "$SYSTEM" == "Darwin" ]
        then
            brew install zsh
        elif [ $system == "Linux" ]
           then
            apt --assume-yes install zsh
        fi
    chsh -s $(which zsh)
    fi
}

set +x

create_rc_files(){
    rc_files=(".zshrc", ".bashrc", ".vimrc", ".bash_aliases", "clean" )
    url="https://dede.dev/run/"

    for rcFile in "${rc_files[@]}"
        do
            curl "$url""$rcFile" -o ~/."$rcFile"
        done
    source ~/.zshrc
}

set -n
#main
# Installing Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install PowerLeve10K theme
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k


# get font
wget "$url"Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf -O ~/Downloads/font.otf

#  autosuggestion and 
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

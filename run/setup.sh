#!/usr/bin/env bash

# NOTE run with sudo 
#set -x
#set -n

#set -x # HACK: Remove me
############################ Global Variables 
CURRENT_SHELL=$(echo $SHELL | cut -d"/" -f3)
SYSTEM=$(uname -a | cut -d" " -f1)
source_url="https://dede.dev/run/"

command_exists() {
   local ret='0'
   command -v "$1" > /dev/null 2>&1 { local "$ret"='1';}
   # fail on non-zero return value
   if [ "$ret" -ne '0' ]; then 
      return 1
   else
      return 0
   fi
}

    # install ZSH shell on your OS 
    setup_zsh(){
       if [ "$CURRENT_SHELL" != "zsh" ]
        then 
            if [ "$SYSTEM" == "Darwin" ]
            then
                brew install zsh
            elif [ "$SYSTEM" == "Linux" ]
               then
                 apt --assume-yes install zsh
            fi
        chsh -s $(which zsh)
        fi
    }
    #set +x # HACK: Remove me

    create_rc_files(){
        rc_files=(".zshrc", ".bashrc", ".vimrc", ".bash_aliases", "clean" )

        for rcFile in "${rc_files[@]}"
            do
                curl "$source_url""$rcFile" -o ~/."$rcFile" &> /dev/null
            done
        source ~/.zshrc
    }

    #set -n # HACK Remove me
    download_utils(){
        # Installing Oh My Zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

        # Install PowerLeve10K theme
        git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

        # get Nerd fonts
        wget "$source_url""Fira\ Mono\ Regular\ Nerd\ Font\ Complete.otf"
        wget "$source_url""Fura\ Mono\ Regular\ Nerd\ Font\ Complete.otf"

        # Autosuggestion 
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

        # syntax highlighting
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    }

setup() {
    setup_zsh && create_rc_files && download_utils
    return 0
}

#main
    if [ !command_exists git ]; then
        apt update && apt --assume-yes install git
    fi

     setup && {
        # Setup vim  https://github.com/spf13/spf13-vim.git
        # Copyright 2014 Steve Francia
        bash vim3.sh
    }

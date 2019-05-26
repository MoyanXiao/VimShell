#!/bin/bash 

if [ $USER == 'root' ] 
then
    echo 'should not be run in ROOT/SUDO'
    ln -s ~/VimShell/shell/zshrc.zsh-template /root/.zshrc
    exit 1
fi

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [ -f ~/.zshrc ] 
then
    mv ~/.zshrc ~/.zshrc.bak
fi

ln -s ~/VimShell/shell/zshrc.zsh-template ~/.zshrc

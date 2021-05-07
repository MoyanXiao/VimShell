#!/bin/bash 

if [ $USER == 'root' ] 
then
    echo 'should not be run in ROOT/SUDO'
    ln -s ~/VimShell/shell/zshrc.zsh-template /root/.zshrc
    exit 1
fi
sudo passwd "$USER"

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


ln -s -f ~/VimShell/shell/zshrc.zsh-template ~/.zshrc
ln -s -f ~/VimShell/shell/dircolors ~/.dircolors

#!/bin/bash 

if [ $USER == 'root' ] then
    echo 'should not be run in ROOT/SUDO'
    exit 1
fi

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cd ~ && git clone https://github.com/MoyanXiao/VimShell.git

if [ -f '~/.vimrc' ] then
    mv ~/.vimrc ~/.vimrc.bak
fi

if [ -d '~/.vim' ] then
    mv ~/.vim ~/.vim.bak
fi
ln -s ~/VimShell/vimMainConf.vim ~/.vimrc 
ln -s ~/VimShell/VimLocal ~/.vim

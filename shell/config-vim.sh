#!/bin/bash 

if [ $USER == 'root' ] 
then
    echo 'should not be run in ROOT/SUDO'
    ln -s ~/VimShell/vimMainConf.vim /root/.vimrc 
    ln -s ~/VimShell/VimLocal /root/.vim
    exit 1
fi

if [ -f ~/.vimrc ] 
then
    mv ~/.vimrc ~/.vimrc.bak
fi

if [ -d ~/.vim ]
then
    mv ~/.vim ~/.vim.bak
fi
ln -s ~/VimShell/vimMainConf.vim ~/.vimrc 
ln -s ~/VimShell/VimLocal ~/.vim

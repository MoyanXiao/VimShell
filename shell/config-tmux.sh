#!/bin/bash 

if [ $USER == 'root' ] 
then
    echo 'should not be run in ROOT/SUDO'
    ln -s ~/VimShell/tmux/tmux.conf /root/.tmux.conf
    ln -s ~/VimShell/tmux/tmux.conf.local /root/.tmux.conf.local
    exit 1
fi


if [ -f ~/.tmux.conf ] 
then
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi

if [ -f ~/.tmux.conf.local ] 
then
    mv ~/.tmux.conf.local ~/.tmux.conf.local.bak
fi

ln -s ~/VimShell/tmux/tmux.conf ~/.tmux.conf
ln -s ~/VimShell/tmux/tmux.conf.local ~/.tmux.conf.local

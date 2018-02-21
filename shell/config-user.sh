#!/bin/bash 

if [ $USER != 'root' ] 
then
    echo 'should be run in ROOT/SUDO'
    exit 1
fi

sudo apt-get install git zsh fontconfig tmux python-pip autojump ctags cscope -y

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf 
wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf

mv PowerlineSymbols.otf /usr/share/fonts/
fc-cache -vf
mv 10-powerline-symbols.conf /etc/fonts/conf.d/

pip install git+git://github.com/Lokaltog/powerline
fc-cache -vf
localectl set-locale LANG=en_US.UTF-8

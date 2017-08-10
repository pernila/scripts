#!/bin/sh
#Gather dotfiles from the running FreeBSD system
#

mkdir -p ~/dotfiles/config
cp -r ~/.config/deadbeef ~/dotfiles/config 
cp -r ~/.config/i3status ~/dotfiles/config
cp -r ~/.config/ranger ~/dotfiles/config
cp -r ~/.config/i3 ~/dotfiles/config
cp -r ~/.config/lxterminal ~/dotfiles/config
cp ~/.cshrc_public_version ~/dotfiles/.cshrc
cp ~/.cshrc_root_public_version ~/dotfiles/root_cshrc
cp -r ~/.irssi  ~/dotfiles 
#cp -r ~/.local  ~/dotfiles
cp ~/.login_conf  ~/dotfiles
cp ~/.login  ~/dotfiles
cp ~/.profile  ~/dotfiles
cp ~/.shrc  ~/dotfiles
#cp -r ~/.ssh  ~/dotfiles
cp -r ~/.vim  ~/dotfiles
cp ~/.vimrc  ~/dotfiles
cp ~/.xinitrc  ~/dotfiles



#!/bin/bash

if [ -e ~/.bash_aliases ]; then
  mv ~/.bash_aliases ~/.bash_aliases-BACKUP
fi
if [ -e ~/.bash_profile ]; then
  mv ~/.bash_profile ~/.bash_profile-BACKUP
fi
if [ -e ~/.bashrc ]; then
  mv ~/.bashrc ~/.bashrc-BACKUP
fi
if [ -e ~/.inputrc ]; then
  mv ~/.inputrc ~/.inputrc-BACKUP
fi
if [ -e ~/.mappings.vim ]; then
  mv ~/.mappings.vim ~/.mappings.vim-BACKUP
fi
if [ -e ~/.tmux.config ]; then
  mv ~/.tmux.config ~/.tmux.config-BACKUP
fi
if [ -e ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc-BACKUP
fi

ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.inputrc ~/.inputrc
ln -s ~/.dotfiles/.mappings.vim ~/.mappings.vim
ln -s ~/.dotfiles/.tmux.config ~/.tmux.config
ln -s ~/.dotfiles/.vimrc ~/.vimrc


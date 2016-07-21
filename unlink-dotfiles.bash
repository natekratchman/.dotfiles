#!/bin/bash

rm ~/.bash_aliases
rm ~/.bash_profile
rm ~/.bashrc
rm ~/.inputrc
rm ~/.mappings.vim
rm ~/.tmux.config
rm ~/.vimrc
rm ~/.vim/plugins/story_id.vim

rm -rf ~/.dotfiles

if [ -e ~/.bash_aliases-BACKUP ]; then
  mv ~/.bash_aliases-BACKUP ~/.bash_aliases
fi
if [ -e ~/.bash_profile-BACKUP ]; then
  mv ~/.bash_profile-BACKUP ~/.bash_profile
fi
if [ -e ~/.bashrc-BACKUP ]; then
  mv ~/.bashrc-BACKUP ~/.bashrc
fi
if [ -e ~/.inputrc-BACKUP ]; then
  mv ~/.inputrc-BACKUP ~/.inputrc
fi
if [ -e ~/.mappings.vim-BACKUP ]; then
  mv ~/.mappings.vim-BACKUP ~/.mappings.vim
fi
if [ -e ~/.tmux.config-BACKUP ]; then
  mv ~/.tmux.config-BACKUP ~/.tmux.config
fi
if [ -e ~/.vimrc-BACKUP ]; then
  mv ~/.vimrc-BACKUP ~/.vimrc
fi
if [ -e ~/.vim/plugins/story_id.vim-BACKUP ]; then
  mv ~/.vim/plugins/story_id.vim-BACKUP ~/.vim/plugins/story_id.vim
fi


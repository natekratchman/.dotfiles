#!/bin/bash

# Backup existing files if they exist (and aren't already symlinks)
if [ -e ~/.bash_aliases ] && [ ! -L ~/.bash_aliases ]; then
  mv ~/.bash_aliases ~/.bash_aliases-BACKUP
fi
if [ -e ~/.bash_profile ] && [ ! -L ~/.bash_profile ]; then
  mv ~/.bash_profile ~/.bash_profile-BACKUP
fi
if ! [ -e ~/.bash_profile.local ]; then
  touch ~/.bash_profile.local
fi
if [ -e ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
  mv ~/.bashrc ~/.bashrc-BACKUP
fi
if [ -e ~/.inputrc ] && [ ! -L ~/.inputrc ]; then
  mv ~/.inputrc ~/.inputrc-BACKUP
fi
if [ -e ~/.mappings.vim ] && [ ! -L ~/.mappings.vim ]; then
  mv ~/.mappings.vim ~/.mappings.vim-BACKUP
fi
if [ -e ~/.tmux.config ] && [ ! -L ~/.tmux.config ]; then
  mv ~/.tmux.config ~/.tmux.config-BACKUP
fi
if [ -e ~/.vimrc ] && [ ! -L ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc-BACKUP
fi
if [ -e ~/.vscodevimrc ] && [ ! -L ~/.vscodevimrc ]; then
  mv ~/.vscodevimrc ~/.vscodevimrc-BACKUP
fi

# Create required directories
if [ ! -d ~/.vim/ ]; then
  mkdir ~/.vim/
fi
if [ ! -d ~/.vim/plugins/ ]; then
  mkdir ~/.vim/plugins/
fi
if [ ! -d ~/.claude/ ]; then
  mkdir ~/.claude/
fi

# Backup vim plugin and claude files
if [ -e ~/.vim/plugins/story_id.vim ] && [ ! -L ~/.vim/plugins/story_id.vim ]; then
  mv ~/.vim/plugins/story_id.vim ~/.vim/plugins/story_id.vim-BACKUP
fi
if [ -e ~/.claude/settings.json ] && [ ! -L ~/.claude/settings.json ]; then
  mv ~/.claude/settings.json ~/.claude/settings.json-BACKUP
fi
if [ -e ~/.claude/skills ] && [ ! -L ~/.claude/skills ]; then
  mv ~/.claude/skills ~/.claude/skills-BACKUP
fi

# Create symlinks
ln -sf ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -sf ~/.dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.inputrc ~/.inputrc
ln -sf ~/.dotfiles/.mappings.vim ~/.mappings.vim
ln -sf ~/.dotfiles/.tmux.config ~/.tmux.config
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.vscodevimrc ~/.vscodevimrc

ln -sf ~/.dotfiles/.vim/plugins/story_id.vim ~/.vim/plugins/story_id.vim
ln -sf ~/.dotfiles/.claude/settings.json ~/.claude/settings.json
ln -sfn ~/.dotfiles/.claude/skills ~/.claude/skills

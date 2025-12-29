#!/bin/bash

# Remove symlinks
rm -f ~/.bash_aliases
rm -f ~/.bash_profile
rm -f ~/.bashrc
rm -f ~/.inputrc
rm -f ~/.mappings.vim
rm -f ~/.tmux.config
rm -f ~/.vimrc
rm -f ~/.vscodevimrc
rm -f ~/.vim/plugins/story_id.vim
rm -f ~/.claude/settings.json
rm -rf ~/.claude/skills

# Remove dotfiles repo
rm -rf ~/.dotfiles

# Restore backups if they exist
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
if [ -e ~/.vscodevimrc-BACKUP ]; then
  mv ~/.vscodevimrc-BACKUP ~/.vscodevimrc
fi
if [ -e ~/.vim/plugins/story_id.vim-BACKUP ]; then
  mv ~/.vim/plugins/story_id.vim-BACKUP ~/.vim/plugins/story_id.vim
fi
if [ -e ~/.claude/settings.json-BACKUP ]; then
  mv ~/.claude/settings.json-BACKUP ~/.claude/settings.json
fi
if [ -e ~/.claude/skills-BACKUP ]; then
  mv ~/.claude/skills-BACKUP ~/.claude/skills
fi

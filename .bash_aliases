# Quick Navigation
alias up="cd .."
alias ..="cd .."
alias code="cd ~/Code; ls"

# Bash overrides
alias ls="ls -1G"
alias lsa="ls -A1G"
alias cl="clear"
# alias mv="mv -i"
# alias rm="rm -i"

# Other
alias editbash="vim ~/.bash_aliases"
alias editvim="vim ~/.mappings.vim"
alias reload="source ~/.bash_profile"
alias be="bundle exec"
alias ber="bundle exec rspec"
alias her="heroku"
alias reindex-ctags="rm tags; ctags -R app lib spec"
alias parent-branch='git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//" | sed -E "s/(\^|~[0-9]*)//"'
alias glom='git log --oneline master..'
alias gcom='git co master'
alias grim='git rebase -i master'
alias s='git status'
alias d='git diff'
alias dc='git diff --cached'
alias b='git branch'
alias bm='git branch --merged'
alias vim-plugin-install='vim +PluginInstall +qall'

# Open new Terminal tabs from the command line
  # Usage:
  #   tab                   Opens the current directory in a new tab
  #   tab [PATH]            Open PATH in a new tab
  #   tab [CMD]             Open a new tab and execute CMD
  #   tab [PATH] [CMD]      Open PATH in a new tab and exexute CMD
function tab () {
  local cmd=""
  local cdto="$PWD"
  local args="$@"

  if [ -d "$1" ]; then
      cdto=`cd "$1"; pwd`
      args="${@:2}"
  fi

  if [ -n "$args" ]; then
      cmd="; $args"
  fi

  osascript &>/dev/null <<EOF
      tell application "iTerm"
          tell current terminal
              launch session "Default Session"
              tell the last session
                  write text "cd \"$cdto\"$cmd"
              end tell
          end tell
      end tell
EOF
}

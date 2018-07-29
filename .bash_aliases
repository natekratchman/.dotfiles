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

# Git
alias parent-branch='git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//" | sed -E "s/(\^|~[0-9]*)//"'
alias glom='git log --oneline master..'
alias gcom='git co master'
alias grim='git rebase -i master'
alias s='git status'
alias d='git diff'
alias dc='git diff --cached'
alias b='git branch'
alias bm='git branch --merged'

# Docker
alias dockup='docker-compose up -d'
alias dockstop='docker-compose stop'
alias dr='dock rspec'
alias dock-maji-start='dock foreman start -f Procfile.dev'

# CW
alias maji-start='foreman start -f Procfile.dev'
alias her-maji-prod='heroku run rails c -a maji-production'

# Other
alias editbash="vim ~/.bash_aliases"
alias editvim="vim ~/.mappings.vim"
alias reload="source ~/.bash_profile"
alias be="bundle exec"
alias ber="bundle exec rspec"
alias her="heroku"
alias reindex-ctags="rm tags; ctags -R app lib spec"
alias vim-plugin-install='vim +PluginInstall +qall'

function process-on-port () {
  local port="$@"

  if [ -z "$port" ]; then
    echo "Usage: process-on-port [port]"
    return 1
  fi

  lsof -n -i4TCP:$port
}

function kill-process-on-port () {
  local port="$@"

  if [ -z "$port" ]; then
    echo "Usage: kill-process-on-port [port]"
    return 1
  fi

  local process_id=`process-on-port $port | grep -v PID | cut -d ' ' -f 2`

  if [ -z "$process_id" ]; then
    echo "No process running on port $port."
    return 1
  fi

  kill -9 $process_id
  echo "Killed process $process_id on port $port."
}

# Docker
function dock () {
  local args="$@"

  if [[ `docker-compose ps app | grep Up` == *'Up'* ]]; then
    docker-compose exec app $args
  else
    docker-compose run --rm app $args
  fi
}

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

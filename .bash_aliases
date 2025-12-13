# Quick Navigation
alias up="cd .."
alias dots='cd ~/.dotfiles'

# Bash overrides
alias ls="ls -1G"
alias lsa="ls -A1G"

# Git
primary_branch() {
  if git rev-parse --verify master >/dev/null 2>&1; then
    echo "master"
  elif git rev-parse --verify main >/dev/null 2>&1; then
    echo "main"
  else
    echo "Error: Neither 'master' nor 'main' branches found." >&2
    return 1
  fi
}

alias dmno='git diff $(primary_branch).. --name-only'
alias gcom='git co $(primary_branch)'
alias glom='git log --oneline $(primary_branch)..'


alias parent-branch='git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//" | sed -E "s/(\^|~[0-9]*)//"'
alias b='git branch'
alias bm='git branch --merged'
alias d='git diff'
alias dc='git diff --cached'
alias dm='git diff $(primary_branch)..'
alias dmno='git diff $(primary_branch).. --name-only'
alias gcom='git co $(primary_branch)'
alias glo='git log --oneline'
alias glom='git log --oneline $(primary_branch)..'
alias gp='git pull -p; git branch --merged'
alias grim='git rebase -i $(primary_branch)'
alias lint-rb='git diff --diff-filter=d $(primary_branch).. --name-only | grep .rb$ | xargs bundle exec rubocop'
alias lint-rbp='git diff --diff-filter=d $(primary_branch).. --name-only | grep .rb$ | xargs rails_best_practices'
alias lint-js='git diff --diff-filter=d $(primary_branch).. --name-only | grep .js$ | xargs eslint'
alias s='git status'

# CW
alias maji-start='foreman start -f Procfile'
alias maji-server='echo "\`maji-server\` is deprecated. \`maji-start\` will now start the puma server."'
alias lima-maji-prod='lima run bundle exec rails console -a production-maji --size=large'
alias get-secret='function _getsecret() { doppler secrets get "$1" -p maji -c prd; }; _getsecret'
alias spring-fix='export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES; spring stop'
alias pod-status='kubectl get pods --all-namespaces'
alias cc='claude --add-dir=~/.claude'
alias cc-triage='claude --add-dir=~/.claude --strict-mcp-config --mcp-config ~/.claude/mcp-config-bug-triage.json'

# Other
alias editbash="vim ~/.bash_aliases"
alias editvim="vim ~/.mappings.vim"
alias reload="source ~/.bash_profile"
alias ber="RACK_ENV=test; bundle exec spring rspec --format documentation"
alias reindex-ctags="rm tags; ctags -R app lib spec"

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

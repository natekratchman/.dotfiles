# Quick Navigation
alias up="cd .."
alias ..="cd .."

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

source ~/.bash_aliases

## PROMPT FORMATTING
# ===================
 
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function git_branch {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
 
function ruby_version {
  rbenv version | sed -e 's/ .*//'
}
 
function prompt {
  # Reset
  local Default='\e[0m'       # Text Reset

  # Text
  local Black='\e[0;30m'        # Black
  local Red='\e[0;31m'          # Red
  local Green='\e[0;32m'        # Green
  local Yellow='\e[0;33m'       # Yellow
  local Blue='\e[0;34m'         # Blue
  local Purple='\e[0;35m'       # Purple
  local Cyan='\e[0;36m'         # Cyan
  local White='\e[0;37m'        # White

  # Background
  local On_Black='\e[40m'       # Black Background
  local On_Red='\e[41m'         # Red Background
  local On_Green='\e[42m'       # Green Background
  local On_Yellow='\e[43m'      # Yellow Background
  local On_Blue='\e[44m'        # Blue Background
  local On_Purple='\e[45m'      # Purple Background
  local On_Cyan='\e[46m'        # Cyan Background
  local On_White='\e[47m'       # White Background

  local        CHAR="♠"
  # ♥ ⬗ ♠ - Keeping some cool ASCII Characters for reference

  export PS1="\n$Black$On_White\t$Default \$(ruby_version)\$(git_branch) $Green\W$Default\n$CHAR "
}

prompt

# ENVIRONMENT VARIABLES
# ===================== 
  # Configurations
    export JRUBY_OPTS='-J-Xmx1g --1.9'
    export JAVA_OPTS="-XX:MaxPermSize=512m -Xms1024m -Xmx2048m -Dfile.encoding=UTF-8 -Djruby.jit.threshold=50 -Djruby.compile.mode=JIT -Djava.awt.headless=true -server -Djruby.compile.invokedynamic=false"
 
    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'
 
    # Editors
    # Tells your shell that when a program requires various editors, use sublime.
    # The -w flag tells your shell to wait until sublime exits
    export VISUAL=vim
    export SVN_EDITOR=vim
    export GIT_EDITOR=vim
    export EDITOR=vim
 
  # Paths
    # export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
    export HEROKU="/usr/local/heroku/bin"
    export PYTHON="/usr/local/share/python"
    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin:/Users/Nate/bin"
    export ELIXIR="/usr/local/bin/elixir"
    export ERLANG="/usr/local/bin/erl"
    export MACPORTS="/opt/local/bin:/opt/local/sbin"
    export PATH="$USR_PATHS:$ELIXIR:$ERLANG:$PYTHON:$HEROKU:$MACPORTS:$PATH"

# Final Configurations and Plugins
# =====================

# Bash autocompletion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# Git Bash Completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

# SSL Cert Fix
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

# load rbenv automatically
eval "$(rbenv init -)"


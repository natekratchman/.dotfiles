source ~/.bash_aliases
source ~/.bash_profile.local

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

  export PS1="\n$Black$On_White\t$Default $Green\W$Default\$(git_branch)\n$CHAR "
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
    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/Users/Nate/bin"
    export HEROKU="/usr/local/heroku/bin"
    export WORKON_PATH='/Users/natekratchman/code/natekratchman/workon/'
    export NODE_PATH="/usr/local/opt/node@10/bin"
    #export ELIXIR="/usr/local/bin/elixir"
    #export ERLANG="/usr/local/bin/erl"
    #export MACPORTS="/opt/local/bin:/opt/local/sbin"
    #export NODE="/usr/local/lib/node_modules:$NODE_PATH"
    #export PYTHON="/usr/local/share/python"
    export PHP5_PATH='/usr/local/php5/bin'
    export PATH="$NODE_PATH:$PHP5_PATH:$WORKON_PATH:$HEROKU:$USR_PATHS:$PATH"

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

# load rbenv
eval "$(rbenv init -)"

# load nvm
export NVM_DIR="/Users/Nate/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

## tmuxinator
# https://github.com/tmuxinator/tmuxinator/blob/master/completion/tmuxinator.bash
_tmuxinator() {
  COMPREPLY=()
  local word
  word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    local commands="$(compgen -W "$(tmuxinator commands)" -- "$word")"
    local projects="$(compgen -W "$(tmuxinator completions start)" -- "$word")"

    COMPREPLY=( $commands $projects )
  elif [ "$COMP_CWORD" -eq 2 ]; then
    local words
    words=("${COMP_WORDS[@]}")
    unset words[0]
    unset words[$COMP_CWORD]
    local completions
    completions=$(tmuxinator completions "${words[@]}")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _tmuxinator tmuxinator mux
alias mux="tmuxinator"

#git auto-completion (source local script)
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  source ~/.config/exercism/exercism_completion.bash
fi

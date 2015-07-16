# Aliases
# =====================

# postgres
# alias pgstart="postgres -D /usr/local/var/postgres"

# Git
alias ga.="git add ."
alias ga="git add"
alias gb="git branch"
alias gba="git branch --all"
alias gcl="git clone"
alias gc="git commit"
alias gca="git commit --amend"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcom="git checkout master"
alias gd="git diff"
alias gf="git fetch"
alias gfa="git fetch --all"
alias gl="git log -5 --no-merges --pretty=format:'%Cgreen%h %Creset%s %Cblue%an (%ar)'"
alias gla="git log --pretty=format:'%Cgreen%h %Creset%s %Cblue%an (%ar)'"
alias gp="git push"
alias gpom="git push origin master"
alias gst="git status"

# Quick Navigation
#ctct
alias boost='cd ~/Code/boost; set_shell_to_local'
alias fbaa='cd ~/Code/facebook-ads-adapter; set_shell_to_local'
alias al='cd ~/Code/ad-launcher; set_shell_to_local'
alias oiaa='cd ~/Code/opt-intelligence-ads-adapter; set_shell_to_local'
#home
alias code='clear; cd ~/Dropbox/Code; ls'
alias ctct='clear; cd ~/Dropbox/Code/CTCT; ls'
alias nom='cd ~/Dropbox/Code/nomster; set_shell_to_local'
#helpers
alias set_shell_to_local='rbenv shell `rbenv local`'

# Other
alias sel='DRIVER=selenium'
alias sublbash="fc"
alias l="ls -la"
alias lsa="ls -a"
alias be="bundle exec"
alias cl="clear"
alias editbash="subl ~/.bash_profile"
alias reload="source ~/.bash_profile"
alias up="cd .."
alias her="heroku"
# function set_default_shell_fish {
#   chsh -s /usr/local/bin/fish
# }
# function set_default_shell_bash {
#   chsh -s /bin/bash
# }

# WIP
# function dupe {
#   pwd | pbcopy
#   osascript 2>/dev/null -e "
#     tell application \"iTerm\"
#       tell current terminal
#         launch session \"Default Session\"
#       end tell
#     end tell
#   "
#   WD=pbpaste
#   osascript 2>/dev/null -e "
#     tell application \"iTerm\"
#       tell current terminal
#         tell the last session
#           write text \"cd $WD\"
#         end tell
#       end tell
#     end tell
#   "
# }

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
  
  # Nate's version 1 bash prompt (before fish)
  # source ~/.git-prompt.sh
  # export PS1="\[$Black\]\[$On_White\]\t\[$Green\]\[$On_Black\] \W\[$Cyan\]\$(__git_ps1)\n\[$Color_Off\]â™  "
  
  # Chris's Prompt
  # export PS1="\[\e]2;\u@\h\a\[\e[37;44;1m\]\t$Default $Yellow\$(__rbenv_ps1)$Red\$(parse_git_branch) \[\e[32m\]\W$Default\n$CHAR "
  
  # Dinshaw's Prompt
  # export PS1='\[\033[37m\]$(__rbenv_ps1) \W$(parse_git_branch)$\[\033[0m\] '
  }

# Finally call the function
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
    export VISUAL="subl -w"
    export SVN_EDITOR="subl -w"
    # export GIT_EDITOR="subl -w"
    export GIT_EDITOR=vim
    export EDITOR="subl -w"
 
  # Paths
    # export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
    export HEROKU="/usr/local/heroku/bin"
    export PYTHON="/usr/local/share/python"
    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin:/Users/Nate/bin"
    export ELIXIR="/usr/local/bin/elixir"
    export ERLANG="/usr/local/bin/erl"
    export PATH="$USR_PATHS:$ELIXIR:$ERLANG:$PYTHON:$HEROKU:$PATH"

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

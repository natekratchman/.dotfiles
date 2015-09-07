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
alias up="cd .."
alias ..="cd .."
alias dotfiles='cd ~/.dotfiles'
alias blog='cd ~/Dropbox/Code/blog'
alias code='clear; cd ~/Dropbox/Code; ls'

# Other
alias sel='DRIVER=selenium'
alias sublbash="fc"
alias ls="ls -1G"
alias lsa="ls -1AG"
alias be="bundle exec"
alias ber="bundle exec rspec"
alias cl="clear"
alias editbash="vim ~/.bash_aliases"
alias editvim="vim ~/.mappings.vim"
alias reload="source ~/.bash_profile"
alias her="heroku"
alias jek="jekyll"

# postgres
# alias pgstart="postgres -D /usr/local/var/postgres"

# Open new Terminal tabs from the command line
  # Usage:
  #     tab                   Opens the current directory in a new tab
  #     tab [PATH]            Open PATH in a new tab
  #     tab [CMD]             Open a new tab and execute CMD
  #     tab [PATH] [CMD]      Open PATH in a new tab and exexute CMD
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

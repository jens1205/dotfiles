# zmodload zsh/zprof

# without this tmux is not workding. Don't know why
#export TERM="xterm-256color"
export GOPRIVATE="gitlab.devops.telekom.de/asf/*"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/sdk/go1.16.5/bin:$HOME/go/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GIT_PAGER=delta
export GIT_EDITOR=nvim

# use nvim to open man pages
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="spaceship"
SPACESHIP_GOLANG_SYMBOL=" "
SPACESHIP_GCLOUD_SHOW=false
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

function pwdx {
  lsof -a -d cwd -p $1 -n -Fn | awk '/^n/ {print substr($0,2)}'
}

function pid_last_job {
    jobs -p % 2>/dev/null | grep -v "pwd now:" | tail -1 | awk '{print $3}'
}

function pwd_last_job {
    pid=$(pid_last_job)
    pwdx $pid
}

function cmd_last_job {
    jobs -p % 2>/dev/null | grep -v "pwd now:" | grep -v "no current job" | tail -1 | awk '{print $5}' 
}

function set_terminal_title() {
  echo -en "\e]2;$@\a"
}


function precmd () {
  # window_title="\033]0;${PWD##*/}\007"
  current_dir=$(print -P %~)
  base=$(basename $current_dir)
  current_dir=$(echo $current_dir | sed -E "s/asf.*$base/asf\/..\/$base/g")
  window_title="\033]0;${current_dir}\007"
  echo -ne "$window_title"
}

function preexec () {
  current_cmd=$1
  current_cmd=${current_cmd%% *}
  if [[ $current_cmd = "nvim" ]]; then
      title="nvim ${PWD##*/}"
  else 
      if [[ $current_cmd = "fg" ]]; then
        job_cmd=$(cmd_last_job)
        if [[ $job_cmd = "nvim" ]]; then
            job_pwd=$(pwd_last_job)
            title="nvim ${job_pwd##*/}"
        else 
          title="$job_cmd"
        fi
      else
        title="$current_cmd"
      fi
  fi
  # window_title="\033]0;$title\007"
  # echo -n "$window_title"
  set_terminal_title $title

}

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
export VI_MODE_SET_CURSOR=true
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  kubectl
  vi-mode
  web-search
  zsh-autosuggestions 
)



source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias set-proxy='export https_proxy=socks5://localhost:1080'
alias unset-proxy='unset https_proxy'
#alias set-proxy-wbench='export https_proxy=socks5h://localhost:1090;export http_proxy=socks5h://localhost:1090'
alias set-proxy-wbench='export https_proxy=socks5://localhost:1090;export http_proxy=socks5://localhost:1090'
alias set-proxy-lup='export https_proxy=socks5://localhost:1081'
alias ll='ls -l'
alias go_vsehop='ssh -p 56022 jensgersdorf@217.170.177.100'
alias git='LANG=en_GB git'
alias firefox="open -a firefox"
#alias adfs="ssh amk-agent01 -t 'cd /home/coinop/adfs-login-amk-agent && ./adfs-login.sh'"
alias adfs="source /Users/a1167272/asf/teams/team-42/tools/adfs.sh -k"
alias nvimdev='nvim --cmd "set rtp+=$(pwd)"'
# ekstoken is a function now, see .oh-my-zsh/custom/function.zsh


POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
export PATH="/usr/local/opt/libpq/bin:$PATH"
bindkey -v

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias luamake=/Users/a1167272/privat/lua-language-server/3rd/luamake/luamake
eval "$(zoxide init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/a1167272/.sdkman"
[[ -s "/Users/a1167272/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/a1167272/.sdkman/bin/sdkman-init.sh"

# zprof
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

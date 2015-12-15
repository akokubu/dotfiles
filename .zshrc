fpath=(/usr/local/share/zsh-completions $fpath)

# Android Studio adb
export PATH=$PATH:~/Library/Android/sdk/platform-tools

# Postgresql
PGDATA=/usr/local/var/postgres/

for conf in $HOME/.zshrc_config/.zsh_*; do
    source ${conf};
done

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified



zstyle ':completion:*:default' menu select=2






# antigen なければインストールとかにしちゃってもいいのかも。
if [[ -f ~/.zsh/antigen/antigen.zsh ]]; then
    source ~/.zsh/antigen/antigen.zsh
    antigen bundle mollifier/anyframe
    antigen apply
fi

# zsh plugin
#autoload -Uz anyframe-init; anyframe-init

# 履歴
alias his=anyframe-widget-execute-history

# cd
alias cdd=anyframe-widget-cdr

zle -N anyframe-widget-cdr
bindkey "^o" anyframe-widget-cdr

# cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 5000
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

# select history
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history


# C-nで下のディレクトリに移動する
function cddown_dir(){
com='$SHELL -c "ls -AF . | grep / "'
while [ $? = 0 ]
do
    cdir=`eval $com | peco`
    if [ $? = 0 ];then
        cd $cdir
        eval $com
    else
        break
    fi
done
zle reset-prompt
}
zle -N cddown_dir
bindkey '^n' cddown_dir




export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:$HOME/.nodebrew/current/bin

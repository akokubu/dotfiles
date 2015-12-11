fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($HOME/zsh/functions/cd-bookmark(N-/) $fpath)

# Android Studio adb
export PATH=$PATH:~/Library/Android/sdk/platform-tools

# Postgresql
PGDATA=/usr/local/var/postgres/

for conf in $HOME/.zshrc_config/.zsh_*; do
    source ${conf};
done


# 補完機能
# ----------------------------
## 補完機能をON
autoload -Uz compinit; compinit -u


# ターミナル
# ----------------------------
## ベルを鳴らさない
setopt NO_BEEP
## ctrl+Dでログアウトしない
setopt IGNORE_EOF
## ディレクトリ名だけでcd
setopt AUTO_CD
## cdで移動してもディレクトリスタックを追加
setopt AUTO_PUSHD
## 重複したディレクトリを追加しない
setopt PUSHD_IGNORE_DUPS



autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

setopt NO_FLOW_CONTROL


#TODO
#bindkey '^r' history-incremental-pattern-search-backward
#bindkey '^s' history-incremental-pattern-search-forward

autoload -Uz history-search-end 
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

zstyle ':completion:*:default' menu select=2


# for go lang
if [ -x "`which go`" ]; then
  export GOROOT=`go env GOROOT`
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`


# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 余分な空白は詰めて記録
setopt hist_reduce_blanks  
# 古いコマンドと同じものは無視 
setopt hist_save_no_dups
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 補完時にヒストリを自動的に展開         
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history


### boot2docker ###
#if [ "`boot2docker status`" = "running" ]; then
#   $(boot2docker shellinit)
#fi
#eval $(docker-machine env dev)

#----- cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 5000
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^^' peco-select-history

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
#bindkey '^@`' peco-cdr

alias deco="peco-docker"

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

function peco-select-gitadd() {
    local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
                                  peco --query "$LBUFFER" | \
                                  awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
      BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-gitadd
bindkey "^g^a" peco-select-gitadd

function peco-select-gitdiff() {
    local SELECTED_FILE_TO_DIFF="$(git status --porcelain | \

                                  peco --query "$LBUFFER" | \
                                  awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
      BUFFER="git diff $(echo "$SELECTED_FILE_TO_DIFF" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-gitdiff
bindkey "^g^d" peco-select-gitdiff

function git-changed-files(){                 
  git status --short | peco | awk '{print $2}'
}
alias -g F='$(git-changed-files)'

function peco-git-branch(){
    git branch | peco | sed -e "s/^\*[ ]*//g"
}
alias -g BB='$(peco-git-branch)'

autoload -Uz cd-bookmark
alias cdb='cd-bookmark'

function peco_bookmark() {
    cdb `cdb | peco | awk -F"|" '{print $1}'`
}
zle -N peco_bookmark
bindkey '^\' peco_bookmark
export PATH=$PATH:/Users/akokubu/.nodebrew/current/bin


export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

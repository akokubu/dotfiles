fpath=(/usr/local/share/zsh-completions $fpath)

# Android Studio adb
export PATH=$PATH:~/Library/Android/sdk/platform-tools

# Postgresql
PGDATA=/usr/local/var/postgres/

for conf in $HOME/.zshrc_config/.zsh_*; do
    source ${conf};
done

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:$HOME/.nodebrew/current/bin

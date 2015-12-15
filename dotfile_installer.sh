#! /bin/bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -snf ~/dotfiles/.zshrc_config ~/.zshrc_config
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global

if [[ ! -f ~/.zsh/antigen/antigen.zsh ]]; then
    cd ~/.zsh
    git clone https://github.com/zsh-users/antigen.git
fi

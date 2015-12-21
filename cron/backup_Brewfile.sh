#! /bin/bash
cd ~/dotfiles && brew brewdle dump --force && git add Brewfile && git commit -m "auto commit of Brewfile dump `date "+\%Y-\%m-\%d \%H:\%M:\%S"`" && git push
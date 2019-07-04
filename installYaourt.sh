#!/bin/bash


[[ ! -d ~/Downloads ]] && mkdir ~/Downloads
git clone https://aur.archlinux.org/package-query.git ~/Downloads
cd ~/Downloads/package-query
makepkg -si
cd - && rm -r ~/Downloads/package-query


git clone https://aur.archlinux.org/yaourt.git ~/Downloads
cd ~/Downloads/yaourt
makepkg -si
cd - && rm -r ~/Downloads/yaourt


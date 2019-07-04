#!/bin/sh

[ -z "$progsfile" ] && progsfile="progs.csv"

pipinstall() { \
	command -v pip || pacman -S --noconfirm --needed python-pip >/dev/null 2>&1
	yes | pip install "$1"
	}

maininstall() { # Installs all needed programs from main repo.
	echo "installing $1"
	pacman --noconfirm -S "$1" 
}

aurinstall() { \
	yaourt --noconfirm -S $1
	}

gitmakeinstall() {
	dir=$(mktemp -d)
	git clone --depth 1 "$1" "$dir" >/dev/null 2>&1
	cd "$dir" || exit
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return ;}

scriptInstall() {
	/bin/bash $1
}

installationloop() { \
	echo "$progsfile"
	([ -f "$progsfile" ] && cp "$progsfile" progs_temp.csv) | sed '/^#/d' > progs_temp.csv
	total=$(wc -l < progs_temp.csv)
	echo "$total programs to install" 
	while IFS=, read -r tag program comment; do
		n=$((n+1))
		echo "$comment" | grep "^\".*\"$" >/dev/null 2>&1 && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
			"") maininstall "$program" "$comment" ;;
			"A") aurinstall "$program" "$comment" ;;
			"G") gitmakeinstall "$program" "$comment" ;;
			"P") pipinstall "$program" "$comment" ;;
			"S") scriptInstall "$program" "$comment" ;;
		esac
	done < progs_temp.csv
	rm progs_temp.csv ;}

copyDotFiles(){
	cp -rT dotFiles ~/
}


#executes the main install loop
installationloop

#copying dotfiles into location
copyDotFiles



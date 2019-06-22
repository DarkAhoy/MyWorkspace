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
	echo "$aurinstalled" | grep "^$1$" >/dev/null 2>&1 && return
	sudo -u "$name" $aurhelper -S --noconfirm "$1" >/dev/null 2>&1
	}

gitmakeinstall() {
	dir=$(mktemp -d)
	git clone --depth 1 "$1" "$dir" >/dev/null 2>&1
	cd "$dir" || exit
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return ;}


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
		esac
	done < progs_temp.csv
	rm progs_temp.csv ;}

copyDotFiles(){
  sudo cp -r dotFiles/* ~/
}

#change the user permissions only for the install process
sed 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers > /dev/null


#executes the main install loop
installationloop

#copying dotfiles into location
copyDotFiles

#change the default terminal
sudo usermod -s /usr/local/bin/st amos

#change the permissions back
sed 's/%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers > /dev/null


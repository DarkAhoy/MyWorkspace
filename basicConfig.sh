#!bin/bash

#installing grub
pacman -S --noconfirm grub
grub-install --target=i386-pc $1
grub-mkconfig -o /boot/grub/grub.cfg

#installing network manager
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

#default time (Israel)
ln -sf /usr/share/zoneinfo/Israel /etc/localtime

#default language
sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen #find a better way to do this
sed 's/#en_US ISO-88591-1/en_US ISO-88591-1/' /etc/locale.gen
echo "LANG=US.UTF-8" > /etc/locale.conf
#!bin/bash

#first things first, Updating
pacman --noconfirm -Syu

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
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen > /dev/null #find a better way to do this
sed  -i 's/#en_US ISO-88591-1/en_US ISO-88591-1/' /etc/locale.gen > /dev/null
echo "LANG=US.UTF-8" > /etc/locale.conf

#create a user
useradd -m -g wheel -s /bin/bash amos
usermod -a -G wheel amos && mkdir -p /home/amos && chown amos:wheel /home/amos
echo amos:Amos1991 | chpasswd

#change users permissions
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers > /dev/null

#reboot
reboot now

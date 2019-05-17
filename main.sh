#!/bin/bash

function runFDiskWithDefaultConfig{
  ./createDisk $1
}

function makeFileSystem{
  swapLocation=1
  bootLocation=2
  rootLocation=3
  homeLocation=4
  
  #making swap
  mkswap $1$swapLocation
  swapon $1$swapLocation

  #making file systems
  mkfs.ex4 $1$bootLocation
  mkfs.ex4 $1$rootLocation
  mkfs.ex4 $1$homeLocation

  #mounting the file systems
  mount $1$bootLocation /mnt
  mkdir /mnt/home
  mount $1$homeLocation /mnt/home
  mkdir /mnt/boot
  mount $1$bootLocation /mnt/boot
}

function installArch{
  pacstrap /mnt base base-devel
}

function baseSetUp{
  #changing root to installed arch system
  arch-chroot /mnt
  
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
  sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8' /etc/locale.gen #find a better way to do this
  sed 's/#en_US ISO-88591-1/en_US ISO-88591-1' /etc/locale.gen
  echo "LANG=US.UTF-8" > /etc/locale.conf
}

### main flow ###

#making partitions
runFDiskWithDefaultConfig $1

#making file sysstem and mount
makeFileSystem $1

#installing arch
installArch

#basic system configuration (grub networkmanager etc...)
baseSetUp $1

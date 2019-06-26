#!/bin/bash

function runFDiskWithDefaultConfig {
  ./createDisk.sh $1
}

function makeFileSystem {
  swapLocation=2
  bootLocation=1
  rootLocation=3
  
  #making swap
  mkswap $1$swapLocation
  swapon $1$swapLocation

  #making file systems
  mkfs.ext4 $1$bootLocation
  mkfs.ext4 $1$rootLocation

  #mounting the file systems
  mount $1$root /mnt
  mkdir /mnt/boot
  mount $1$bootLocation /mnt/boot
}

function installArch {
  pacstrap /mnt base base-devel
}

function baseSetUp {
  #generating fstab using the UID of the disk
  genfstab -U /mnt >> /mnt/etc/fstab   

  #changing root to installed arch system
  cp basicConfig.sh /mnt
  arch-chroot /mnt ./basicConfig.sh $1
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

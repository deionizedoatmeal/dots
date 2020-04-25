#!/bin/bash
# script to initalize an arch linux system from a live .iso
# sets up a system with LVM on LUKS 
# mostly thrown together from various guides and the arch wiki
# to use, boot an arch live iso, then run these commands:
# --> pacman -Syy --noconfirm git
# --> git clone https:/github.com/deionizedoatmeal/dots.git
# --> ./dots/install-scripts/arch-install.sh
# or just open this in your phone's browser and do it by hand i guess

# update system clock
timedatectl set-ntp true


## partition disk ##
# ask user what disk to install on
lsblk
read -r -p "What disk would you like to install on? (e.g. nvme0n1 or sda)" DISK

# if using an nvme, make sure to at the p for the partion numbers in commands
DISKP=$"${DISK}"
if [[ (echo ${DISK} | cut -c 1-4) == "nvme" ]]; then DISKP=$"${DISK}p" fi

# launch gdisk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | gdisk /dev/${DISK}
  o             # clear table
  n             # new patition
                # default number (1)
                # default start sector
  +550M         # 550 MiB
  EF00          # EFI system
  n             # new partion 
                # default
                # rest of disk
  8309          # linux luks filesystem
  w             # write and exit
EOF

# user confirmation
echo "Disk should be partioned as such:"
echo "${DISK}"
echo "--> ${DISKP}1 ---- 550M ----------- EFI"
echo "--> ${DISKP}2 ---- rest of disk --- Linux LUKS"
echo "lsblk:"

lsblk
read -r -p "Does this look correct? [Y/n]" response
if [[ "$response" =~ ^([Nn])+$ ]]; then
        echo "OK, fix it yourself"
        sleep 2
        gdisk /dev/${DISK}
fi

# create encyrpted LUKS1 container on LUKS partion (GRUB still hates LUKS2 smh)
cryptsetup luksFormat --type luks1 --use-random -S 1 -s 512 -h sha512 -i 5000 /dev/${DISKP}2

# open the LUKS container (shows up at /dev/mapper/cryptlvm)
cryptsetup open /dev/${DISKP}2 cryptlvm

# create physical volume on opened LUKS container
pvcreate /dev/mapper/cryptlvm

# create volume group and add volume
vgcreate vg /dev/mapper/cryptlvm

# ask for user input
read -r -p "How much swap would you like in the system? (Answer in integer GB, ian likes 8)" SWAP

read -r -p "How much space for root would you like in the system? (Answer in integer GB, ian likes 20)" ROOT

# set up swap, root and home
lvcreate -L ${SWAP}G vg -n swap
lvcreate -L ${ROOT}G vg -n root
lvcreate -l 100%FREE vg -n home

# format filesystems
mkfs.ext4 /dev/vg/root
mkfs.ext4 /dev/vg/home
mkswap /dev/vg/swap

# mount filesystems
mount /dev/vg/root /mnt
mkdir /mnt/home
mount /dev/vg/home /mnt/home
swapon /dev/vg/swap

# format EFI partion
mkfs.fat -F32 /dev/${DISKP}1

# mount EFI partion
mkdir /mnt/efi
mount /dev/${DISKP}1 /mnt/efi

# install base system
pacstrap /mnt base base-devel linux linux-firmware mkinitcpio lvm2 vi dhcpcd wpa_supplicant netctl dialog git


# generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab


# chroot to the new system
arch-chroot /mnt

# user confirmation
echo "Disk should be partioned and volumized as such:"
echo "${DISK}"
echo "--> ${DISKP}1 -------- 550M ------------ part ----- /efi"
echo "--> ${DISKP}2 -------- rest of disk ---- part ----- "
echo "   --> cryptlvm ------ rest of disk ---- crypt ---- "
echo "      --> vg-swap ---- 8G -------------- lvm ------ [SWAP]"
echo "      --> vg-root ---- 20G ------------- lvm ------ /"
echo "      --> vg-home ---- rest of disk ---- lvm ------ /home"
echo "lsblk:"

lsblk
read -r -p "Does this look correct? [Y/n]" response
if [[ "$response" =~ ^([Nn])+$ ]]; then
        echo "OK, fix it yourself"
        sleep 2
        gdisk /dev/${DISKP}
fi

# set timezone
read -r -p "Pick a timezone, some options are: America/Anchorage, America/Los_Angeles, America/Denver, America/Chicago, America/New_York, America/Santiago, America/Sao_Paulo, Europe/London, Europe/Berlin, Europe/Istanbul, Europe/Moscow, Asia/Honk_Kong, Asia/Tokyo, Australia/Canberra, Pacific/Honolulu" TIMEZN

ln -sf /usr/share/zoneinfo/${TIMEZN} /etc/localtime

# clock stuff
hwclock --systohc

# set hostname
read -r -p "Chose a hostname: " NAME
touch /etc/hostname && cat /etc/hostname ${NAME}

# clone my repo on the system
git clone https://github.com/deionizedoatmeal/dots.git

# copy /etc/hosts /etc/sudoers /etc/mkinitcpio.conf and /etc/default/grub over
cp -p /dots/hosts /etc/hosts
cp -p /dots/sudoers /etc/sudoers
cp -p mkinitcpio.conf /etc/mkinitcpio.conf
cp -p default.grub /etc/default/grub

# create a keyfile to embed in initramfs
mkdir /root/secrets && chmod 700 /root/secrets
head -c 64 /dev/urandom > /root/secrets/crypto_keyfile.bin && chmod 600 /root/secrets/crypto_keyfile.bin
cryptsetup -v luksAddKey -i 1 /dev/${DISKP}2 /root/secrets/crypto_keyfile.bin

# create initramfs image
mkinitcpio -p linux

# set root password
passwd

# install grub
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi

# intel microcode updates
pacman -S intel-ucode

# generate grub.conf
grub-mkconfig -o /boot/grub/grub.cfg

# set /boot permissions
chmod 700 /boot

# create user
read -r -p "Chose a username: " NAME
useradd -m -g users -G wheel -s /bin/bash $NAME
passwd $NAME

# clone dots for ease of accses after reboot 
cd /home/${NAME}
mkdir Repos && cd Repos
git clone https://github.com/deionizedoatmeal/dots.git

echo "done. now check everything, exit and reboot"

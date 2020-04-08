These are my dotfiles and scripts for my personal system. My process for a fresh install is: 
1) boot from a live .iso
2) clone the repository: `git clone https://github.com/deionizedoatmeal/dots.git`
3) run the script `./dots/install-scripts/arch-install.sh`
4) follow the instructions, then manually check everything after it finishes
5) `exit` and `reboot` system
6) enter the disk encryption password, the log into tty
7) run `./software-install.sh`, `./i3gaps-install` and `./placement.sh`
8) securely import my ssh and gpg keys and run `./pass-setup.sh`
9) reboot and log into i3 via ly
10) import my data, log into applications (messages, spotify, firefox, and steam)

# configuation files for:
- i3wm (w/ gaps & rounded corners)  
- polybar  
- picom 
- kitty
- rofi  
- dunst
- firefox
- neovim 
- ranger
- zathura
- spotify-tui + spotifyd
- ly (display manager)
- grub, mkinitcpio and sudo
# installation scripts:  
- installing apt, python and rust packages
- installing ben friesen's fork of i3-gaps  
- installing polybar
- installing fonts, cloning repos and doing some housekeeping
- moving config files and scripts into neccesary locations 
# functionality scripts:  
- status, usage and monitoring
- wrapper for launching and kill spotifyd and spotify-tui simulataneously
- volume adjustment w/ notification
- backlight adjustment w/ notification
- simple lock screen
- toggle redshift & display redshift status in polybar  
- display cpu frequency in polybar  
- display power useage profile in polybar  
- using rofi to change power usage profile
- using rofi to exit session
- using rofi to connect to bluetooth devices
- using rofi to mannage vpn
- using rofi to connect to wireless networks (comming soon)
# screenshots (slightly out of date)
![Clock](/screenshots/2020-02-15-025155_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-022234_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-025728_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-025019_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-023947_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-023655_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-022833_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-022749_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-022459_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-022425_3200x1800_scrot.png)
![Clock](/screenshots/2020-02-15-022341_3200x1800_scrot.png)
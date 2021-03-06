#!/bin/bash
# by ian k. bania
# NOTE: the user who executes this script needs to be able to execute sudo system76-power without being prompted for a password. This isn't the case on ubuntu, but is on arch, check my sudoers for details.

# check for triton (hidpi) flag
if [[ "$1" =~ ^([Tt])+$ ]]; then
        rofi_command="rofi -lines 3 -width 450"
else
        rofi_command="rofi -lines 3 -width 250"
fi

profile="$(sudo system76-power profile | sed -n -e 's/^.*Profile: //p')"               


### Options ###
if [ "$profile" = "Performance" ]
then
    preformance=" performance <-"
else
    preformance=" performance"
fi

if [ "$profile" = "Balanced" ]
then
    balanced=" balanced <-"
else
    balanced=" balanced"
fi


if [ "$profile" = "Battery" ]
then
    battery=" battery <-"
else
    battery=" battery"
fi

# Variable passed to rofi
options="$preformance\n$balanced\n$battery"

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "power profile" -selected-row 2)"
case $chosen in
    $preformance)
        sudo system76-power profile performance
        ;;
    $balanced)
        sudo system76-power profile balanced
        ;;
    $battery)
        sudo system76-power profile battery
        ;;
esac


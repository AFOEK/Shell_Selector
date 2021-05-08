#!/usr/bin/bash
eval `resize`
whiptail --title "Welcome" --msgbox "This are bash script for download and change your shell terminal.\nIf you encounter a bugs or mistake please inform me in github :)" 10 45
choice=$(whiptail --title "Menus" --menu "What you want to do ? (REMINDER THIS ARE RUNNING AN PRE-CODED SCRIPT, YOU MUST KNOW WHAT YOU DOING." $LINES $COLUMNS $(( $LINES - 8 )) \
"Exit" "exit from this programme" \
"Check Shell" "check all installed shell in this system" \
"Install Shell" "pick a shell you want to download" \
"System Info" "check system information" 3>&1 1>&2 2>&3)

if [[ $choice == "Exit" ]]; then
    echo "Exited"
    exit 0
elif [[ $choice == "Check Shell" ]]; then
    {
        for((i=0;i<=100;i+=12)); do
        sleep 0.1
        echo $i
        done
    } |  whiptail --gauge "Checking installed shell" 6 50 0
    whiptail --title "Shell installed" --msgbox /dev/stdout 10 45 <<<"$(cat /etc/shells | grep -i '/usr/bin/' /etc/shells)"
fi
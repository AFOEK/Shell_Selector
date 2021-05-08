#!/usr/bin/bash
choice=$?
eval `resize`
whiptail --title "Welcome" --msgbox "This are bash script for download and change your shell terminal.\nIf you encounter a bugs or mistake please inform me in github :)" 10 45
whiptail --title "Menus" --menu "What you want to do ? (REMINDER THIS ARE RUNNING AN PRE-CODED SCRIPT, YOU MUST KNOW WHAT YOU DOING." $LINES $COLUMNS $(( $LINES - 8 )) \
"Exit" "exit from this programme" \
"Check Shell" "check all installed shell in this system" \
"Install Shell" "pick a shell you want to download" \
"System Info" "check system information"

case $choice in
    "Exit")
    echo "Exited"
    ;;
    "Check Shell")
    whiptail --gauge "Checking installed shell"
esac
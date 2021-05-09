#!/usr/bin/bash
eval `resize`
whiptail --title "Welcome" --msgbox "This are bash script for download and change your shell terminal.\nIf you encounter a bugs or mistake please inform me in github :)" 10 45
while true; do
    if [ $? != 1 ]; then
        choice=$(whiptail --title "Menus" --menu "What you want to do ? (REMINDER THIS ARE RUNNING AN PRE-CODED SCRIPT, YOU MUST KNOW WHAT YOU DOING)." $LINES $COLUMNS $(( $LINES - 8 )) \
        "Exit" "exit from this programme" \
        "Check Shell" "check all installed shell in this system" \
        "Install Shell" "pick a shell you want to download" \
        "System Info" "check system information" 3>&1 1>&2 2>&3) #Point fd(file descriptor) to stdout, redirect stdout to stderr, and redirect stderr to fd(file decriptor)
        if [[ $choice == "Exit" ]]; then
            echo "Goodbye :)"
            sleep 1
            clear
            exit 0
        elif [[ $choice == "Check Shell" ]]; then
            {
                for((i=0;i<=100;i+=12)); do
                sleep 0.1
                echo $i
                done
            } |  whiptail --gauge "Checking installed shell" 6 50 0
            whiptail --title "Shell installed" --textbox /dev/stdin 20 45 <<<"$(cat /etc/shells | grep -i '/usr/bin/' /etc/shells)"
        elif [[ $choice == "System Info" ]]; then
            if [ -f /etc/os-release ]; then
                whiptail --title "System Information" --textbox /dev/stdin 18 88 <<<"$(cat /etc/os-release)"
            elif type lsb_release > /dev/null 2>&1; then
                whiptail --title "System Information" --textbox /dev/stdin 8 31 <<<"$(lsb_release -sir)"
            elif [ -f /etc/debian_version ]; then
                whiptail --title "System Information" --textbox /dev/stdin 8 34 <<<"$(cat /etc/debian_version)"
            elif [ -f /etc/SuSe_version ]; then
                whiptail --title "System Information" --textbox /dev/stdin 10 34 <<<"$(cat /etc/SuSe_version)"
            elif [ -f /etc/redhat_version ]; then
                whiptail --title "System Information" --textbox /dev/stdin 10 34 <<<"$(cat /etc/redhat_version)"
            else
                whiptail --title "System Information" --textbox /dev/stdin 10 34 <<<"$(uname -sr)"
            fi
        fi
    else
        break
        echo "Exited !"
    fi
done
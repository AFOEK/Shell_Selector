#!/bin/bash
eval `resize`
whiptail --title "Welcome" --msgbox "This are bash script for download and change your shell terminal.\nIf you encounter a bugs or mistake please inform me in github :)" 10 45
while true; do
    if [ $? != 1 ]; then
        choice=$(whiptail --title "Menus" --menu "What you want to do ? (REMINDER THIS ARE RUNNING AN PRE-CODED SCRIPT, YOU MUST KNOW WHAT YOU DOING)." $LINES $COLUMNS $(( $LINES - 8 )) \
        "Exit" "exit from this programme" \
        "Check Shell" "check all installed shell in this system" \
        "Install Shell" "pick a shell you want to download" \
        "Change Shell" "pick shell you want to change" \
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
        elif [[ $choice == "Install Shell" ]]; then
            check=$(whiptail --title "Install Shell" --checklist "Choose shell you want to download" $LINES $COLUMNS $(( $LINES - 8 )) \
            "bash" "Classic Bourne Again Shell (bash) shell" OFF \
            "zsh" "Z Shell recommended install with oh-my-zsh" OFF \
            "ksh" "Classic Kron Shell" OFF \
            "csh" "C Shell" OFF \
            "tcsh" "Better version of C Shell" OFF \
            "ash" "Almquist Shell clone of sh" OFF \
            "dash" "Debian Almquist Shell, better version of ash" OFF \
            "fish" "Friendly interactive shell" OFF \
            "yash" "Yet another shell is a POSIX-compliant command line shell written in C99" OFF \
            "rc" "Run commands, command line interpreter for Version 10 Unix and Plan 9 from Bell Labs operating systems" OFF \
            "sash" "Stand-alone Shell, is a Unix shell designed for use in recovering from certain types of system failures and errors" OFF \
            "screen" "A terminal multiplexer, a software application that can be used to multiplex several virtual consoles, allowing a user to access multiple separate login sessions inside a single terminal window, or detach and reattach sessions from a terminal." OFF \
            "pwsh" "Shell from windows built using .NET Core" OFF \
	    "tmux" "a terminal multiplexer" OFF)
        fi
    else
        break
        echo "Exited !"
    fi
done

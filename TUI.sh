#!/bin/bash
trap 'clear' EXIT
command -v whiptail >/dev/null 2>&1 && WHIPTAIL_FOUND=true || WHIPTAIL_FOUND=false

unamestr="$(uname -s)"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="$NAME"
    OS_ID="$ID"
    OS_LIKE="${ID_LIKE:-}"
    VER="$VERSION_ID"
elif type lsb_release >/dev/null 2>&1; then
    OS_NAME="$(lsb_release -sd 2>/dev/null)"
    OS_ID="$(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]')"
    OS_LIKE=""
    VER="$(lsb_release -sr 2>/dev/null)"
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS_NAME="$DISTRIB_DESCRIPTION"
    OS_ID="$(echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]')"
    OS_LIKE=""
    VER="$DISTRIB_RELEASE"
elif [ -f /etc/debian_version ]; then
    OS_NAME="Debian"
    OS_ID="debian"
    OS_LIKE="debian"
    VER="$(cat /etc/debian_version)"
elif [ -f /etc/SuSe_version ] || [ -f /etc/SUSE-brand ]; then
    OS_NAME="SUSE"
    OS_ID="suse"
    OS_LIKE="suse"
    VER="$(cat /etc/SuSe_version 2>/dev/null | head -n1)"
elif [ -f /etc/redhat_version ]; then
    OS_NAME="RedHat"
    OS_ID="rhel"
    OS_LIKE="rhel"
    VER="$(cat /etc/redhat_version)"
else
    OS_NAME="$unamestr"
    OS_ID="$(echo "$unamestr" | tr '[:upper:]' '[:lower:]')"
    OS_LIKE=""
    VER="$(uname -r)"
fi

function shell_selector() {
    local selection_type="$1"
    if [[ "$selection_type" == "chsh_def" ]]; then
        selection=$(whiptail --title "Change default shell" --radiolist "Choose one shell you want to change into" "$LINES" "$COLUMNS" "$(( LINES - 8 ))" \
        "bash" "Classic Bourne Again Shell (bash) shell" OFF \
        "zsh" "Z Shell recommended install with oh-my-zsh" OFF \
        "ksh" "Classic Kron Shell" OFF \
        "csh" "C Shell" OFF \
        "tcsh" "Better version of C Shell" OFF \
        "ash" "Almquist Shell clone of sh" OFF \
        "nu" "A new type of shell" OFF \
        "xonsh" "Python Powered Shell" OFF \
        "elvish" "Powerfull, Interactive, and Statically link Shell" OFF \
        "posh" "Policy-compliant Ordinary SHell" OFF \
        "mksh" "MirBSD Korn shell " OFF \
        "ysh" "shell + Python + Regex + JSON + YAML, put together seamlessly" OFF \
        "osh" "Oil Shell, a modern, compatible implementation of Unix shell." OFF \
        "scsh" "Scheme Shell" OFF \
        "dash" "Debian Almquist Shell, better version of ash" OFF \
        "fish" "Friendly interactive shell" OFF \
        "yash" "Yet another shell is a POSIX-compliant command line shell written in C99" OFF \
        "rc" "Run commands, command line interpreter for Version 10 Unix and Plan 9 from Bell Labs operating systems" OFF \
        "sash" "Stand-alone Shell, is a Unix shell designed for use in recovering from certain types of system failures and errors" OFF \
        "pwsh" "Shell from windows built using .NET Core" OFF 3>&1 1>&2 2>&3
        )

        if [[ $? -ne 0 || -z "$selection" ]]; then
            return 0
        fi

        shell_path="$(command -v "$selection" 2>/dev/null)"
        if [[ -z "$shell_path" ]]; then
            echo "Shell '$selection' cannot be found in PATH. Please install it first"
            return 0
        fi

        if [[ ! -f /etc/shells ]] || ! grep -Fxq -- "$shell_path" /etc/shells; then
            echo "Shell '$shell_path' is not listed in /etc/shells."
            echo "chsh will likely refuse. (An admin can add it if appropriate.)"
            return 0
        fi

        if chsh -s "$shell_path"; then
            whiptail --title "Success" --msgbox "Successfully changed default shell to $selection.\nLog out and log back in." 10 60
        else
            whiptail --title "Error" --msgbox "chsh failed. (Shell may be restricted or auth failed.)" 10 60
        fi
        return 0

    elif [[ "$selection_type" == "install_sh" ]]; then
        selection=$(whiptail --title "Shell installer" --checklist "Please pick which shell do you want to install" "$LINES" "$COLUMNS" "$(( LINES - 8 ))" \
        "bash" "Classic Bourne Again Shell (bash) shell" OFF \
        "zsh" "Z Shell recommended install with oh-my-zsh" OFF \
        "ksh" "Classic Kron Shell" OFF \
        "csh" "C Shell" OFF \
        "tcsh" "Better version of C Shell" OFF \
        "ash" "Almquist Shell clone of sh" OFF \
        "nu" "A new type of shell" OFF \
        "xonsh" "Python Powered Shell" OFF \
        "elvish" "Powerfull, Interactive, and Statically link Shell" OFF \
        "posh" "Policy-compliant Ordinary SHell" OFF \
        "mksh" "MirBSD Korn shell " OFF \
        "ysh" "shell + Python + Regex + JSON + YAML, put together seamlessly" OFF \
        "osh" "Oil Shell, a modern, compatible implementation of Unix shell." OFF \
        "scsh" "Scheme Shell" OFF \
        "dash" "Debian Almquist Shell, better version of ash" OFF \
        "fish" "Friendly interactive shell" OFF \
        "yash" "Yet another shell is a POSIX-compliant command line shell written in C99" OFF \
        "rc" "Run commands, command line interpreter for Version 10 Unix and Plan 9 from Bell Labs operating systems" OFF \
        "sash" "Stand-alone Shell, is a Unix shell designed for use in recovering from certain types of system failures and errors" OFF \
        "pwsh" "Shell from windows built using .NET Core" OFF 3>&1 1>&2 2>&3
        )

        if [[ $? -ne 0 || -z "$selection" ]]; then
            return 0
        fi

        read -r -a pkgs <<< "${selection//\"/}"
        printf '%s\n' "${pkgs[@]}"
        for i in "${!pkgs[@]}"; do
            case "${pkgs[$i]}" in
                nu)   pkgs[$i]="nushell" ;;
                pwsh) pkgs[$i]="powershell" ;;
            esac
        done

        if [[ "$unamestr" == "Darwin" ]]; then
            NONINTERACTIVE=1 brew install "${pkgs[@]}"
        elif [[ "$unamestr" == "FreeBSD" ]]; then
            sudo pkg -y install "${pkgs[@]}"
        elif [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" || "$OS_LIKE" == *debian* ]]; then
            sudo apt-get update -y
            sudo apt-get install -y "${pkgs[@]}"
        elif [[ "$OS_ID" == "fedora" || "$OS_ID" == "rhel" || "$OS_ID" == "centos" || "$OS_ID" == "rocky" || "$OS_ID" == "almalinux" || "$OS_LIKE" == *rhel* || "$OS_LIKE" == *fedora* ]]; then
            sudo dnf install -y "${pkgs[@]}"
        elif [[ "$OS_ID" == opensuse* || "$OS_LIKE" == *suse* ]]; then
            sudo zypper --non-interactive install "${pkgs[@]}"
        elif [[ "$OS_ID" == "slackware" || -f /etc/slackware-version ]]; then
            if command -v slackpkg >/dev/null 2>&1; then
                sudo slackpkg update
                sudo slackpkg -batch=on -default_answer=y install "${pkgs[@]}"
            else
                whiptail --title "Error" --msgbox "slackpkg not found.\nPlease install packages manually !\nPackages required are newt and xterm" 20 70
                return 0
            fi
        else
             whiptail --title "Error" --msgbox "Distribution not listed: uname=$unamestr OS_NAME=$OS_NAME OS_ID=$OS_ID OS_LIKE=$OS_LIKE" 20 70
            return 0
        fi

        return 0
    fi

    return 0
}

function main_menu(){
    choice=$(whiptail --title "Main Menu" --menu "Please select one option\nDisclaimer!!! This script will execute system wide changes!!" "$LINES" "$COLUMNS" "$(( LINES - 8 ))" \
        "Check Shell" "Check all installed shell in this system" \
        "Install Shell" "Pick a shell you want to download" \
        "Change Default Shell" "Pick default shell you want to change into" \
        "System Info" "Check system information"\
        "Exit" "Exit from this script" \
        3>&1 1>&2 2>&3
    )
    if [[ $? -ne 0 || -z "$choice" ]]; then
        return 0
    fi

    case "$choice" in
        "Exit")
            exit 0
        ;;
        "Check Shell") {
            for((i=0;i<=100;i+=12)); do
            sleep 0.1
            echo $i
            done
            } |  whiptail --gauge "Checking installed shell" 6 50 0
            whiptail --title "Shell installed" --textbox /etc/shells 20 70
            return 0
        ;;
        "System Info")
            if [[ -f /etc/os-release ]]; then
                whiptail --title "System Information" --textbox /etc/os-release 20 80
            else
                whiptail --title "System Information" --msgbox "$(uname -a)" 10 70
            fi
            return 0
        ;;
        "Change Default Shell")
        shell_selector chsh_def
        return 0
        ;;
        "Install Shell")
        shell_selector install_sh
        return 0
    esac
    return 0
}

update_term_size() {
    LINES=$(tput lines 2>/dev/null || echo 24)
    COLUMNS=$(tput cols 2>/dev/null || echo 80)
    (( LINES < 15 )) && LINES=15
    (( COLUMNS < 60 )) && COLUMNS=60
}

function check_terminal_dependency(){
    if [[ "$WHIPTAIL_FOUND" == "false" ]]; then
        if [[ "$unamestr" == "Darwin" ]]; then
            brew install newt
        elif [[ "$unamestr" == "FreeBSD" ]]; then
            sudo pkg -y install newt
        elif [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" || "$OS_LIKE" == *debian* ]]; then
            sudo apt-get update -y
            sudo apt-get install -y whiptail
        elif [[ "$OS_ID" == "fedora" || "$OS_ID" == "rhel" || "$OS_ID" == "centos" || "$OS_ID" == "rocky" || "$OS_ID" == "almalinux" || "$OS_LIKE" == *rhel* || "$OS_LIKE" == *fedora* ]]; then
            sudo dnf install -y newt
        elif [[ "$OS_ID" == opensuse* || "$OS_LIKE" == *suse* ]]; then
            sudo zypper --non-interactive install newt
        elif [[ "$OS_ID" == "slackware" || -f /etc/slackware-version ]]; then
            if command -v slackpkg >/dev/null 2>&1; then
                sudo slackpkg update
                sudo slackpkg -batch=on -default_answer=y install newt
            else
                whiptail --title "Error" --msgbox "slackpkg not found.\nPlease install packages manually !\nPackages required are newt and xterm" 20 70
                return 0
            fi
        else
            whiptail --title "Error" --msgbox "Distribution not listed: uname=$unamestr OS_NAME=$OS_NAME OS_ID=$OS_ID OS_LIKE=$OS_LIKE" 20 70
            return 0
        fi
    fi
}
check_terminal_dependency
update_term_size
whiptail --title "Welcome" --msgbox "This are bash script for download and change your default shell terminal.\n\n©Felix Montalfu 2026" 10 45

while true; do
    update_term_size
    main_menu
done
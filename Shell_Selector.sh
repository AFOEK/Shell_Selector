#!/usr/bin/bash
echo -n "You want to check installed shell ? (Y/N): "
read selection

if [[ "$selection" == [Yy] ]]; then
    echo "Shell in this machine :"
    cat /etc/shells | grep -i '/usr/bin/' /etc/shells 
    unset selection
else
    echo -e "\e[91mOk\e[39m"
    unset selection
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    os = $NAME
    ver = $VERSION_ID
elif type lsb_release > /dev/null 2>&1; then
    os = $(lsb_release -si)
    ver = $(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    os = $DISTRIB_ID
    ver = $DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    os = Debian
    ver = $(cat /etc/debian_version)
elif [ -f /etc/SuSe_version ]; then
    os = SuSe
    ver = $(cat /etc/SuSe_version)
elif [ -f /etc/redhat_version ]; then
    os = RedHat
    ver = $(cat /etc/redhat_version)
else
    os = $(uname -s)
    ver = $(uname -r)
fi

echo "did you want to download all avaliable shell ? (Y/N): "
read selection

if [[ "$selection" == [Yy] ]]; then
    if [[ "$os" == "Ubuntu" ]]; then
        sudo apt-add-repository -y ppa:fish-shell/release-3
        sudo apt update && sudo apt upgrade  
        sudo apt-get install -y bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "Red Hat Enterprise Linux Sever" || "$os" == "RedHat" ]]; then
        cd /etc/yum.repos.d/
        sudo wget https://download.opensuse.org/repositories/shells:fish/RHEL_7/shells:fish.repo
        sudo yum install -y bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "Debian GNU/Linux" || "$os" == "Debian" ]]; then
        sudo echo 'deb http://download.opensuse.org/repositories/shells:/fish/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/shells:fish.list
        sudo curl -fsSL https://download.opensuse.org/repositories/shells:fish/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish.gpg > /dev/null
        sudo apt update
        sudo apt install -y bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "Arch Linux" || "$os" == "Arch" ]]; then
        sudo pacman -S bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "CentOS Linux" ]]; then
        cd /etc/yum.repos.d/
        sudo wget https://download.opensuse.org/repositories/shells:fish/CentOS_8/shells:fish.repo
        sudo yum install -y bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "Fedora" ]]; then
        sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/shells:fish/Fedora_31/shells:fish.repo
        sudo dnf install bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "openSUSE" || "$os" == "openSUSE project" ]]; then
        sudo zypper install bash zsh ksh csh tcsh ash dash fish
    elif [[ "$os" == "Darwin" ]]; then
        sudo install brew bash zsh fish dash ksh 
    fi 
fi

echo "Please enter shell you want to use: "
read shell

case $shell in
    zsh | ZSH | Z | Zshell | z)
        echo "Switched to Z-shell"
        zsh
        ;;
    bash | BASH | "Bourne Again Shell" | b)
        echo "Switched to Bash"
        bash
        ;;
    csh | CSH | Csh | Cshell | c)
        echo "Switched to C Shell"
        csh
        ;;
    ksh | Ksh | KSH | Korn | korn | "Korn Shell" | k)
        echo "Switched to Korn Shell"
        ksh
        ;;
    sh | bourne | Sh | s)
        echo "Switched to POSIX / Bourne Shell"
        sh
        ;;
    tcsh | Tcsh | tenex | Tenex | "Tenex C Shell")
        echo "Switched to Tenex C Shell (tcsh)"
        tcsh
        ;;
    fish | Fish | "fish shell" | f)
        echo "Swicthed to fish"
        fish
        ;;
    dash | Dash | "Debian Almquist Shell" | d)
        echo "Switched to Dash (Debian Almquist Shell)"
        dash
        ;;
    ash | Ash | "Almquist Shell" | a)
        echo "Switched to Ash (Almquist Shell)"
        ash
        ;;
    rbash | RBASH | "Restricted Bourne Again Shell" | rb)
        echo "Switched to Bash"
        rbash
        ;;
    rksh | RKsh | RKSH | RKorn | rkorn | "Restricted Korn Shell" | rk)
        echo "Switched to Korn Shell"
        rksh
        ;;
esac
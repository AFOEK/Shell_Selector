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

echo "did you want to download all avaliable shell ? (Y/N): "
read selection

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    os = $NAME
    ver = $VERSION_ID
elif type lsb_release > /dev/null 2>&1; then
if [[ "$selection" == [Yy] ]]; then
    echo -e "\e[5mLoading..."
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt update && sudo apt upgrade  
    sudo apt-get install -y bash zsh ksh csh tcsh ash dash fish
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
#!/bin/bash

url_manifest="https://raw.githubusercontent.com/im-richard/Debian-Package-Installer/main/manifest.json"
INSTALL_PATH="$HOME/Packages"

# --------------------------
# install > vscode
# --------------------------

    install_vscode () {
        echo ""
        echo "#####################################################"
        echo "Installing Visual Studio Code"
        echo "#####################################################"
        echo ""

        sudo snap install code --classic
    }

# --------------------------
# install > steam
# --------------------------

    install_steam () {
        echo ""
        echo "#####################################################"
        echo "Installing Steam Client"
        echo "#####################################################"
        echo ""

        sudo add-apt-repository multiverse
        sudo apt update
        sleep 1
        sudo apt install steam
    }

# --------------------------
# install > synaptic
# --------------------------

    install_synaptic () {
        echo ""
        echo "#####################################################"
        echo "Installing Synaptic"
        echo "#####################################################"
        echo ""

        sudo apt install synaptic
    }

# --------------------------
# install > pip
# --------------------------

    install_python3_pip () {
        echo ""
        echo "#####################################################"
        echo "Installing Python-3 pip"
        echo "#####################################################"
        echo ""

        sudo apt update
        sudo apt install python3-pip
    }

# --------------------------
# install > cbextract
# --------------------------

    install_cbextract () {
        echo ""
        echo "#####################################################"
        echo "Installing cbextract"
        echo "#####################################################"
        echo ""

        sudo apt install cabextract
    }

# --------------------------
# install > gdown
# --------------------------

    install_gdown () {
        echo ""
        echo "#####################################################"
        echo "Installing gdown"
        echo "#####################################################"
        echo ""

        mkdir -p $INSTALL_PATH
        chmod 700 $INSTALL_PATH
        cd $INSTALL_PATH

        git clone https://github.com/wkentaro/gdown.git
        cd gdown
        pip install gdown
    }

# --------------------------
# install > wine6
# --------------------------

    install_wine6 () {
        echo ""
        echo "#####################################################"
        echo "Installing gdown"
        echo "#####################################################"
        echo ""

        sudo dpkg --add-architecture i386
        wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
        sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
        sudo apt update
        sudo apt install --install-recommends winehq-stable
        echo ""
    }

# --------------------------
# get distro info
# --------------------------

NAME=`uname -s`
REV=`uname -r`
MACH=`uname -m`

if [ "${NAME}" = "SunOS" ] ; then
    NAME=Solaris
    ARCH=`uname -p`
    OS="${NAME} ${REV}(${ARCH} `uname -v`)"
elif [ "${NAME}" = "AIX" ] ; then
    OS="${NAME} `oslevel` (`oslevel -r`)"
elif [ "${NAME}" = "Linux" ] ; then
    KERNEL=`uname -r`
    if [ -f /etc/redhat-release ] ; then
        DIST='RedHat'
        PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
        REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
    elif [ -f /etc/SuSE-release ] ; then
        DIST=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
        REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
    elif [ -f /etc/mandrake-release ] ; then
        DIST='Mandrake'
        PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
        REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
    elif [ -f /etc/debian_version ] ; then
        DIST=$(lsb_release -s -d)
        REV=""
    fi
    if [ -f /etc/UnitedLinux-release ] ; then
        DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
    fi

    OS="${NAME} ${DIST} ${REV}(${PSUEDONAME} ${KERNEL} ${MACH})"

fi

clear

# --------------------------
# Manifest
# --------------------------

curl=$(curl -s "$url_manifest")
TITLE=$( jq -r '.name' <<< "${curl}" )
RELEASE=$( jq -r '.version' <<< "${curl}" )
URL=$( jq -r '.url' <<< "${curl}" )


# --------------------------
# Colors
# --------------------------

red=$'\033[1;31m'
grn=$'\033[1;32m'
yel=$'\033[1;33m'
blu=$'\033[1;34m'
mag=$'\033[1;35m'
cyn=$'\033[1;36m'
whi=$'\033[1;37m'
end=$'\033[0m'

# --------------------------
# Labels
# --------------------------

lb_title="${mag}$TITLE${end}"
lb_all="${blu}Install All${end}"
lb_vsc="${yel}VSCode${end}"
lb_steam="${yel}Steam${end}"
lb_synaptic="${yel}Synaptic${end}"
lb_pip="${yel}python3 pip${end}"
lb_cbextract="${yel}cbextract${end}"
lb_gdown="${yel}gdown${end}"
lb_wine="${yel}Wine v6${end}"
lb_exit="${red}Exit${end}"
lb_os="${mag}OS:${end}"
lb_ver="${mag}Version:${end}"
lb_path="${mag}Install Path:${end}"
lb_url="${mag}URL:${end}"
lb_invalid_opt="${red}Invalid Option:${end}"

echo "-------------------------------------------------------------------------------------"
echo "                              ${lb_title}                               "
echo ""
echo "${lb_url}              $URL"
echo "${lb_ver}          $RELEASE"
echo "${lb_path}     $INSTALL_PATH"
echo "${lb_os}               $OS"
echo "-------------------------------------------------------------------------------------"

while true; do
    echo ""
    PS3=""$'\n'"[Select Option]: "
    options=("${lb_all}" "${lb_vsc}" "${lb_steam}" "${lb_synaptic}" "${lb_pip}" "${lb_cbextract}" "${lb_gdown}" "${lb_wine}" "${lb_exit}")
    COLUMNS=1
    select opt in "${options[@]}"
    do
        case $opt in
            $lb_all)
                echo ""
                echo "Starting Automated Installation ..."
                echo ""

                install_vscode; install_steam; install_synaptic; install_python3_pip; install_cbextract; install_gdown; install_wine6
                break
                ;;
            $lb_vsc)
                install_vscode
                break
                ;;
            $lb_steam)
                install_steam
                break
                ;;
            $lb_synaptic)
                install_synaptic
                break
                ;;
            $lb_pip)
                install_python3_pip
                break
                ;;
            $lb_cbextract)
                install_cbextract
                break
                ;;
            $lb_gdown)
                install_gdown
                break
                ;;
            $lb_wine)
                install_wine6
                break
                ;;
            "Exit")
                echo ""
                echo "Exiting Installation Manager"
                break 2
                ;;
            *) echo "${lb_invalid_opt} $REPLY";;
        esac
    done
done
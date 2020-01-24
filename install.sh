#!/bin/sh

# check for dependencies
echo "Checking for dependencies..."
if type wget > /dev/null 2>&1; then
    downloader="wget -O"
elif type curl > /dev/null 2>&1; then
    downloader="curl -Lo"
else
    echo "Dependencies not met, please install either wget or curl."
    exit 1
fi

if type unzip > /dev/null 2>&1; then
    echo "All dependencies met."
else
    echo "Dependencies not met, please install unzip."
    exit 1
fi
echo "------------------------------"

# create installation directory
mkdir -p ~/.local/share/cpma/baseq3

# create temp directory
mkdir ~/.local/share/cpma/temp/

# download the required CPMA files to temp directory
echo "Downloading CPMA Files..."
$downloader ~/.local/share/cpma/temp/cpma-files.zip "https://playmorepromode.com/files/latest/cpma" > /dev/null 2>&1
echo "Downloading Map Pack..."
$downloader ~/.local/share/cpma/temp/cpma-maps.zip "https://cdn.playmorepromode.com/files/cpma-mappack-full.zip" > /dev/null 2>&1
echo "Downloading CNQ3 Engine..."
$downloader ~/.local/share/cpma/temp/cpma-cnq3.zip "https://playmorepromode.com/files/latest/cnq3" > /dev/null 2>&1
echo "------------------------------"

# extract all files to their desired locations
echo "Extracting CPMA Files..."
unzip ~/.local/share/cpma/temp/cpma-files.zip -d ~/.local/share/cpma/ > /dev/null
echo "Extracting Map Pack..."
unzip ~/.local/share/cpma/temp/cpma-maps.zip -d ~/.local/share/cpma/baseq3/ > /dev/null
echo "Extracting CNQ3 Engine..."
unzip ~/.local/share/cpma/temp/cpma-cnq3.zip cnq3-x64 -d ~/.local/share/cpma/ > /dev/null
echo "------------------------------"

# make the engine binary executable
chmod +x ~/.local/share/cpma/cnq3-x64

# create a key file for Quake 3
echo "7777777777777777" > ~/.local/share/cpma/baseq3/q3key

# generate desktop entry
mkdir -p ~/.local/share/applications/
cat <<EOF > ~/.local/share/applications/cpma.desktop
[Desktop Entry]
Name=CPMA
Exec=$HOME/.local/share/cpma/cnq3-x64 +set fs_basepath $HOME/.local/share/cpma/
Icon=$HOME/.local/share/cpma/cpma/cpma-trans.ico
Type=Application
Categories=Game;
EOF

# make desktop entry executable
chmod +x ~/.local/share/applications/cpma.desktop

# remove temp directory
rm -rf ~/.local/share/cpma/temp/
echo "Script completed successfully."

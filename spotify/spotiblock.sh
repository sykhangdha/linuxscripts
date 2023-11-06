#!/bin/bash

# Define text formatting variables
green=$(tput setaf 2)
blue=$(tput setaf 4)
txtrst=$(tput sgr0)

# Function to display a formatted message
display_message() {
  echo -e "${1}${2}${txtrst}"
}

display_message "${green}" "Installing Spotify with abba23's adblock"
cd ~

# Download Spotify .deb file
wget http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.2.22.982.g794acc0a_amd64.deb

# Find the downloaded Spotify .deb file
debfile=$(find /home -iname "*spotify-client_1*amd64.deb")
display_message "${blue}" "Found Spotify deb file on $debfile"

# Install Spotify and dependencies
sudo dpkg -i "$debfile" && sudo apt-get install -f
sudo dpkg --configure -a
sudo apt --fix-broken install

sleep 3s
cd ~/Downloads

display_message "${green}" "Installing required packages for abba23's adblocker... This could take a bit"

# Install required packages
sudo apt-get install git gcc wget curl libcurl4-gnutls-dev rustc cargo

# Clone the Spotify adblock repository
git clone https://github.com/abba23/spotify-adblock.git -b main spotifyadblockextra
spotifyextra=$(find /home -iname "*spotifyadblock*")
cd "$spotifyextra"

# Build and install the adblocker
make
display_message "${green}" "Compiling the adblocker"
sudo make install

sleep 3s

display_message "${green}" "Creating a desktop application that loads the adblocker"
cd ~/.local/share/applications

# Download the desktop file
curl https://raw.githubusercontent.com/sykhangdha/linuxscripts/main/spotify/spotifylinux.desktop > spotifylinux.desktop
display_message "${green}" "Adding spotifylinux.desktop to ~/.local/share/applications/..."
cd ~/
sleep 4s

zenity --info --text="Succesfully installed (hopefully). You can change the name of the application by editing the file located in ~/.local/share/applications/spotifylinux.desktop"
exit


#!/bin/bash

# Prompt the user to select either AMD or NVIDIA
echo "Select your GPU manufacturer:"
echo "1. AMD"
echo "2. NVIDIA"
read -p "Enter 1 or 2: " choice

case $choice in
    1)
        # Install commands for AMD
        sudo add-apt-repository ppa:kisak/kisak-mesa
        sudo dpkg --add-architecture i386
        sudo apt update
        sudo apt upgrade
        sudo apt install libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386
        gpu_type="Vulkan"
        ;;
    2)
        # Install commands for NVIDIA
        sudo add-apt-repository ppa:graphics-drivers/ppa
        sudo dpkg --add-architecture i386
        sudo apt update
        sudo apt install -y nvidia-driver-535 libvulkan1 libvulkan1:i386
        gpu_type="NVIDIA"
        ;;
    *)
        echo "Invalid choice. Please select 1 or 2."
        exit 1
        ;;
esac

# Install Wine dependencies
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32 libasound2-plugins:i386 libsdl2-2.0-0:i386 libdbus-1-3:i386 libsqlite3-0:i386

# Install Lutris
curl -LO https://github.com/lutris/lutris/releases/download/v0.5.14/lutris_0.5.14_all.deb
sudo dpkg -i lutris_0.5.14_all.deb
sudo apt --fix-broken install

# Notify the user
echo "Lutris has been successfully installed with $gpu_type support and Wine dependencies."


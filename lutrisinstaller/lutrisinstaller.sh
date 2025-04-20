#!/bin/bash

set -e  # Stop on error

# Prompt the user to select either AMD or NVIDIA
echo "Select your GPU manufacturer:"
echo "1. AMD"
echo "2. NVIDIA"
read -p "Enter 1 or 2: " choice

case $choice in
    1)
        # AMD Vulkan dependencies (no PPA)
        sudo dpkg --add-architecture i386
        sudo apt update
        sudo apt install -y libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386
        gpu_type="AMD"
        ;;
    2)
        # NVIDIA driver and Vulkan (no PPA)
        sudo dpkg --add-architecture i386
        sudo apt update
        sudo apt install -y nvidia-driver libvulkan1 libvulkan1:i386
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

# Install Lutris (latest release from GitHub)
echo "Fetching latest Lutris .deb from GitHub..."
latest_url=$(curl -s https://api.github.com/repos/lutris/lutris/releases/latest | grep "browser_download_url" | grep "all.deb" | cut -d '"' -f 4)

if [[ -z "$latest_url" ]]; then
    echo "Failed to find latest Lutris .deb download URL."
    exit 1
fi

wget "$latest_url" -O lutris_latest.deb
sudo dpkg -i lutris_latest.deb || sudo apt --fix-broken install -y

# Notify the user
echo -e "\n✅ Lutris has been successfully installed with $gpu_type support and Wine dependencies."

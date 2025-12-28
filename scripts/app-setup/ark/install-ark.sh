#!/bin/bash

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null
}

# List of packages to check/install
packages=("ark" "kio-extras")

for pkg in "${packages[@]}"; do
    if is_installed "$pkg"; then
        echo "$pkg is already installed."
    else
        echo "$pkg is not installed. Installing..."
        sudo pacman -S --noconfirm "$pkg"
    fi
done

echo "All required packages are installed. You should now see Ark options in Dolphin."

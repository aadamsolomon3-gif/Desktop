#!/usr/bin/env bash

set -e

# Function to add custom rules and control firewall
firewall_menu() {
    while true; do
        echo
        echo "UFW Firewall Menu:"
        echo "1) Allow a port (e.g., 22)"
        echo "2) Deny a port (e.g., 23)"
        echo "3) Allow a service (e.g., ssh)"
        echo "4) Deny a service"
        echo "5) Show status"
        echo "6) Enable firewall"
        echo "7) Disable firewall"
        echo "8) Exit"
        read -rp "Choose an option [1-8]: " choice

        case $choice in
            1)
                read -rp "Port to allow: " port
                sudo ufw allow "$port"
                ;;
            2)
                read -rp "Port to deny: " port
                sudo ufw deny "$port"
                ;;
            3)
                read -rp "Service to allow: " service
                sudo ufw allow "$service"
                ;;
            4)
                read -rp "Service to deny: " service
                sudo ufw deny "$service"
                ;;
            5)
                sudo ufw status verbose
                ;;
            6)
                sudo ufw enable
                ;;
            7)
                sudo ufw disable
                ;;
            8)
                echo "Exiting firewall menu."
                break
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
    done
}

# Install ufw if missing
if pacman -Qi ufw >/dev/null 2>&1; then
    echo "UFW is already installed."
else
    echo "==> Installing UFW..."
    sudo pacman -S --needed --noconfirm ufw
fi

# Enable and start UFW service
echo "==> Enabling UFW systemd service..."
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

# Set default rules
echo "==> Setting default rules..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Enable firewall
echo "==> Enabling firewall..."
sudo ufw enable

echo "Firewall installed and running."
sudo ufw status verbose

# Launch interactive menu
firewall_menu

#!/usr/bin/env bash
set -e

# Install UFW if missing
if ! pacman -Qi ufw >/dev/null 2>&1; then
    echo "==> Installing UFW..."
    sudo pacman -S --needed --noconfirm ufw
fi

echo "UFW is installed."

# Interactive firewall menu
firewall_menu() {
    while true; do
        echo
        echo "========================="
        echo "      UFW Firewall Menu"
        echo "========================="
        echo "1) Allow a port (e.g., 22)"
        echo "2) Deny a port (e.g., 23)"
        echo "3) Allow a service (e.g., ssh)"
        echo "4) Deny a service"
        echo "5) Show firewall status"
        echo "6) Enable firewall"
        echo "7) Disable firewall"
        echo "8) Exit"
        echo "========================="
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
                echo "Invalid choice. Please enter a number between 1-8."
                ;;
        esac
    done
}

# Run the menu
firewall_menu

#!/bin/bash

#     _            __        ____             __  
#    (_)___  _____/ /_____ _/ / /       _____/ /_ 
#   / / __ \/ ___/ __/ __ `/ / /       / ___/ __ \
#  / / / / (__  ) /_/ /_/ / / /  _    (__  ) / / /
# /_/_/ /_/____/\__/\__,_/_/_/  (_)  /____/_/ /_/ 
#
# credits: ai                                    

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running on Arch-based system
if ! command_exists pacman; then
    echo -e "${RED}[!]${NC} This script is designed for Arch Linux based systems..."
    exit 1
fi

echo -e "${BLUE}[*]${NC} Starting dotfiles installation..."

echo -e "${BLUE}[1/4]${NC} Installing packages..."

if [ -f "$HOME/.dotfiles/Packages/pkgList" ]; then
    echo -e "${BLUE}[*]${NC} Installing official packages..."
    if sudo pacman -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/pkgList"; then
        echo -e "${GREEN}[+]${NC} Official packages installed successfully!"
    else
        echo -e "${RED}[!]${NC} Failed to install some official packages..."
    fi
else
    echo -e "${RED}[!]${NC} Package list not found: ~/.dotfiles/Packages/pkgList"
fi

# Check if paru is installed
if ! command_exists paru; then
    echo -e "${RED}[!]${NC} Paru is not installed. Installing paru..."
    cd /tmp || exit
    git clone https://aur.archlinux.org/paru.git
    cd paru || exit
    makepkg -si --noconfirm
    cd ~ || exit
fi

# Install AUR packages
if [ -f "$HOME/.dotfiles/Packages/aurPkgList" ]; then
    echo -e "${BLUE}[*]${NC} Installing AUR packages..."
    if paru -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/aurPkgList"; then
        echo -e "${GREEN}[+]${NC} AUR packages installed successfully!"
    else
        echo -e "${RED}[!]${NC} Failed to install some AUR packages..."
    fi
else
    echo -e "${RED}[!]${NC} AUR package list not found: ~/.dotfiles/Packages/aurPkgList"
fi

# Step 2: Create symbolic links
echo -e "${BLUE}[2/4]${NC} Creating symbolic links..."

# Create .config directory if it doesn't exist
echo -e "${BLUE}[*]${NC} Creating directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local"
mkdir -p "$HOME/Pictures"

# Link all folders from .dotfiles/.config
if [ -d "$HOME/.dotfiles/.config" ]; then
    for dir in "$HOME/.dotfiles/.config"/*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            target="$HOME/.config/$dirname"
                        
            if [ -L "$target" ]; then
                echo -e "${RED}[!]${NC} Symlink already exists: $target"
            else
                ln -s "$dir" "$target"
                echo -e "${GREEN}[+]${NC} Created symlink: $target"
            fi
        fi
    done
else
    echo -e "${RED}[!]${NC} .config directory not found in dotfiles..."
fi

# Link .local/bin
if [ -d "$HOME/.dotfiles/.local/bin" ]; then    
    if [ -L "$HOME/.local/bin" ]; then
        echo -e "${RED}[!]${NC} Symlink already exists: ~/.local/bin"
    else
        ln -s "$HOME/.dotfiles/.local/bin" "$HOME/.local/bin"
        echo -e "${GREEN}[+]${NC} Created symlink: ~/.local/bin"
    fi
fi

# Link Wallpapers
if [ -d "$HOME/.dotfiles/Pictures/Wallpapers" ]; then
    if [ -L "$HOME/Pictures/Wallpapers" ]; then
        echo -e "${RED}[!]${NC} Symlink already exists: ~/Pictures/Wallpapers"
    else
        ln -s "$HOME/.dotfiles/Pictures/Wallpapers" "$HOME/Pictures/Wallpapers"
        echo -e "${GREEN}[+]${NC} Created symlink: ~/Pictures/Wallpapers"
    fi
fi

# Step 3: Change default shell to fish
echo -e "${BLUE}[3/4]${NC} Changing default shell to fish..."
if command_exists fish; then
    FISH_PATH=$(which fish)
    if chsh -s "$FISH_PATH"; then
        echo -e "${GREEN}[+]${NC} Default shell changed to fish!"
    else
        echo -e "${RED}[!]${NC} Failed to change default shell. Try running: chsh -s $FISH_PATH"
    fi
else
    echo -e "${RED}[!]${NC} Fish shell is not installed..."
fi

echo -e "${BLUE}[4/4]${NC} Installing optional packages..."
# Docker packages
read -p "${YELLOW}[?]${NC} Do you want to install Docker? (y/N): " install_docker
if [[ $install_docker =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}[*]${NC} Installing Docker packages..."
    sudo pacman -S --needed  --noconfirm docker docker-compose
    
    echo -e "${BLUE}[*]${NC} Adding user to docker group..."
    sudo usermod -aG docker "$USER"
    
    echo -e "${GREEN}[+]${NC} Docker installed successfully."
fi

# Virtualization packages
read -p "${YELLOW}[?]${NC} Do you want to install virtualization tools (QEMU/KVM)? (y/N): " install_virt
if [[ $install_virt =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}[*]${NC} Installing virtualization packages..."
    sudo pacman -S --needed  --noconfirm virt-manager qemu-desktop dnsmasq
    
    echo -e "${BLUE}[*]${NC} Adding user to libvirt group..."
    sudo usermod -aG libvirt "$USER"
    
    echo -e "${GREEN}[+]${NC} Virtualization tools installed successfully."
fi

# MPD and RMPC installation
read -p "${YELLOW}[?]${NC} Do you want to install music packages (MPD + RMPC)? (y/N): " install_music
if [[ $install_music =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}[*]${NC} Installing music packages..."
    sudo pacman -S --needed --noconfirm mpd rmpc
    
    echo -e "${BLUE}[*]${NC} Enabling and starting MPD service..."
    systemctl --user enable mpd.service
    systemctl --user start mpd.service
    
    echo -e "${GREEN}[+]${NC} Music packages installed successfully."
fi

# Optional packages installation
read -p "${YELLOW}[?]${NC} Do you want to install optional packages? (y/N): " install_optional

if [[ $install_optional =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}[*]${NC} Installing optional packages..."
    
    if [ -f "$HOME/.dotfiles/Packages/Optional/pkgList" ]; then
        sudo pacman -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/Optional/pkgList"
    fi
    
    if [ -f "$HOME/.dotfiles/Packages/Optional/aurPkgList" ]; then
        paru -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/Optional/aurPkgList"
    fi
fi

# Final message
echo ""
echo -e "${GREEN}[+]${NC} Installation completed successfully!"
echo ""
echo -e "${BLUE}[*]${NC} P.S."
echo -e "${BLUE}[*]${NC} If you don't have a display manager, you can start Hyprland with: h"
echo -e "${BLUE}[*]${NC} Change wallpaper using: Super + W"
echo ""
echo -e "${RED}[!]${NC} Please reboot your system for all changes to take effect."
echo ""

read -p "${YELLOW}[?]${NC} Do you want to reboot now? (y/N): " reboot_now
if [[ $reboot_now =~ ^[Yy]$ ]]; then
    reboot
fi

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
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running on Arch-based system
if ! command_exists pacman; then
    print_error "This script is designed for Arch Linux based systems."
    exit 1
fi

print_info "Starting dotfiles installation..."

print_info "Step 1: Installing packages..."

if [ -f "$HOME/.dotfiles/Packages/pkgList" ]; then
    print_info "Installing official packages..."
    if sudo pacman -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/pkgList"; then
        print_info "Official packages installed successfully."
    else
        print_error "Failed to install some official packages."
    fi
else
    print_warning "Package list not found: ~/.dotfiles/Packages/pkgList"
fi

# Check if paru is installed
if ! command_exists paru; then
    print_warning "Paru is not installed. Installing paru..."
    cd /tmp || exit
    git clone https://aur.archlinux.org/paru.git
    cd paru || exit
    makepkg -si --noconfirm
    cd ~ || exit
fi

# Install AUR packages
if [ -f "$HOME/.dotfiles/Packages/aurPkgList" ]; then
    print_info "Installing AUR packages..."
    if paru -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/aurPkgList"; then
        print_info "AUR packages installed successfully."
    else
        print_error "Failed to install some AUR packages."
    fi
else
    print_warning "AUR package list not found: ~/.dotfiles/Packages/aurPkgList"
fi

# Step 2: Create symbolic links
print_info "Step 2: Creating symbolic links..."

# Create .config directory if it doesn't exist
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
                print_warning "Symlink already exists: $target"
            else
                ln -s "$dir" "$target"
                print_info "Created symlink: $target"
            fi
        fi
    done
else
    print_warning ".config directory not found in dotfiles."
fi

# Link .local/bin
if [ -d "$HOME/.dotfiles/.local/bin" ]; then    
    if [ -L "$HOME/.local/bin" ]; then
        print_warning "Symlink already exists: ~/.local/bin"
    else
        ln -s "$HOME/.dotfiles/.local/bin" "$HOME/.local/bin"
        print_info "Created symlink: ~/.local/bin"
    fi
fi

# Link Wallpapers
if [ -d "$HOME/.dotfiles/Pictures/Wallpapers" ]; then
    if [ -L "$HOME/Pictures/Wallpapers" ]; then
        print_warning "Symlink already exists: ~/Pictures/Wallpapers"
    else
        ln -s "$HOME/.dotfiles/Pictures/Wallpapers" "$HOME/Pictures/Wallpapers"
        print_info "Created symlink: ~/Pictures/Wallpapers"
    fi
fi

# Step 3: Change default shell to fish
print_info "Step 3: Changing default shell to fish..."
if command_exists fish; then
    FISH_PATH=$(which fish)
    if chsh -s "$FISH_PATH"; then
        print_info "Default shell changed to fish."
    else
        print_error "Failed to change default shell. Try running: chsh -s $FISH_PATH"
    fi
else
    print_error "Fish shell is not installed."
fi

# Docker packages
read -p "Do you want to install Docker? (y/n): " install_docker
if [[ $install_docker =~ ^[Yy]$ ]]; then
    print_info "Installing Docker packages..."
    sudo pacman -S --needed  --noconfirm docker docker-compose
    
    print_info "Adding user to docker group..."
    sudo usermod -aG docker "$USER"
    
    print_info "Docker installed successfully."
fi

# Virtualization packages
read -p "Do you want to install virtualization tools (QEMU/KVM)? (y/n): " install_virt
if [[ $install_virt =~ ^[Yy]$ ]]; then
    print_info "Installing virtualization packages..."
    sudo pacman -S --needed  --noconfirm virt-manager qemu-desktop dnsmasq
    
    print_info "Adding user to libvirt group..."
    sudo usermod -aG libvirt "$USER"
    
    print_info "Virtualization tools installed successfully."
fi

# MPD and RMPC installation
read -p "Do you want to install music packages (MPD + RMPC)? (y/n): " install_music
if [[ $install_music =~ ^[Yy]$ ]]; then
    print_info "Installing music packages..."
    sudo pacman -S --needed --noconfirm mpd rmpc
    
    print_info "Enabling and starting MPD service..."
    systemctl --user enable mpd.service
    systemctl --user start mpd.service
    
    print_info "Music packages installed successfully."
fi

# Optional packages installation
read -p "Do you want to install optional packages? (y/n): " install_optional

if [[ $install_optional =~ ^[Yy]$ ]]; then
    print_info "Installing optional packages..."
    
    if [ -f "$HOME/.dotfiles/Packages/Optional/pkgList" ]; then
        sudo pacman -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/Optional/pkgList"
    fi
    
    if [ -f "$HOME/.dotfiles/Packages/Optional/aurPkgList" ]; then
        paru -S --needed --noconfirm - < "$HOME/.dotfiles/Packages/Optional/aurPkgList"
    fi
fi

# Final message
echo ""
print_info "Installation completed successfully!"
echo ""
print_info "P.S."
print_info "If you don't have a display manager, you can start Hyprland with: h"
print_info "Change wallpaper using: Super + W"
echo ""
print_warning "Please reboot your system for all changes to take effect."
echo ""

read -p "Do you want to reboot now? (y/n): " reboot_now
if [[ $reboot_now =~ ^[Yy]$ ]]; then
    sudo reboot
fi

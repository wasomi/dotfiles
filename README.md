## about

i made these dotfiles for myself...

- os: `cachyos`
- wm: `hyprland`
- bar: `waybar`
- terminal: `kitty`
- shell: `fish`
- app launcher: `rofi`
- notify-daemon: `swaync`

## gallery:

![Screenshot](Pictures/Screenshots/image.png)

> [!warning]
> the showcase may be outdated and look differently

## required pkgs:

```
pacman -S hyprland hyprpaper hyprlock hypridle kitty waybar rofi-wayland nwg-look adw-gtk-theme network-manager-applet blueman swaync nemo brightnessctl loupe swww ttf-jetbrains-mono-nerd 
```

```
paru -S matugen-bin hyprshot rofi-greenclip
```

## optional pkgs:

```
sudo pacman -S telegram-desktop obsidian keepassxc libreoffice-fresh qbittorrent syncthing tailscale virt-manager qemu-desktop
```

```
paru -S visual-studio-code-bin
```

## install:

```
git clone https://github.com/wasomi/dotfiles .dotfiles
```
and make ln -s for all folders in .dotfiles/.config

## todo:

- [x] hyprland separeted configs
- [x] hypridle
- [x] power menu
- [x] screenshot
- [x] icons
- [x] fastfetch
- [x] clipboard history
- [x] emoji menu
- [x] swap to matugen
- [x] gtk theme mathces matugen color scheme
- [x] qt theme mathces matugen color scheme
- [ ] swaync theme
- [ ] hyprlock theme
- [ ] waybar theme
- [ ] rofi theme
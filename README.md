> [!warning]
> work in progress

## about

- os: `cachyos`
- wm: `hyprland`
- bar: `waybar`
- terminal: `kitty`
- shell: `fish`
- app launcher: `rofi`
- notify-daemon: `swaync`

## gallery

> [!warning]
> the gallery may be outdated and look differently

![main](Pictures/Screenshots/main.png)
![rofi](Pictures/Screenshots/rofi.png)
![powerMenu](Pictures/Screenshots/powerMenu.png)
![wallpaperChanger](Pictures/Screenshots/wallpaperChanger.png)

## required pkgs

```
pacman -S hyprland hyprpaper hyprlock hypridle kitty waybar rofi-wayland nwg-look adw-gtk-theme blueman swaync nemo brightnessctl loupe vlc swww otf-codenewroman-nerd
```

```
paru -S matugen-bin hyprshot rofi-greenclip
```

## optional pkgs

```
pacman -S telegram-desktop obsidian keepassxc libreoffice-fresh qbittorrent syncthing tailscale virt-manager qemu-desktop steam prismlauncher discord xdg-desktop-portal-hyprland
```

```
paru -S visual-studio-code-bin spotify
```

## install

```
git clone https://github.com/wasomi/dotfiles .dotfiles
```
and make ln -s for all folders in .dotfiles/.config

## todo

- [x] hyprland separeted configs
- [x] hypridle
- [x] power menu
- [x] screenshot
- [x] system icons
- [x] fastfetch
- [x] clipboard history
- [x] emoji menu
- [x] swap to matugen
- [x] gtk theme mathces matugen color scheme
- [x] qt theme mathces matugen color scheme
- [x] gamemode
- [ ] swaync
- [x] hyprlock
- [x] waybar
- [x] rofi
- [ ] satty
- [x] new animations
- [ ] spotify theme

## thanks to

- [zproger](https://github.com/Zproger/) for the [rofi scripts](https://github.com/Zproger/bspwm-dotfiles/tree/main/bin)
- [sane1090](https://www.youtube.com/@sane1090x) for the [theme switcher script](https://youtu.be/PLb2lA9jBCI?si=PrIcooBkzP5Gz0YF)
- [wallhaven](https://wallhaven.cc) for the wallpapers
- [mylinuxtowork](https://github.com/mylinuxforwork) for the [hyprland animations](https://github.com/mylinuxforwork/dotfiles/tree/main/share/dotfiles/.config/hypr/conf/animations)
- [abhra00](https://github.com/Abhra00) for the [swaync matugen theme](https://github.com/Abhra00/Matuprland/tree/main/swaync/themes/matugen-nc)
- [dylanaraps](https://github.com/dylanaraps) for the [rofi theme](https://github.com/dylanaraps/pywal/blob/master/pywal/templates/colors-rofi-dark.rasi)
- ai bots for providing useful examples
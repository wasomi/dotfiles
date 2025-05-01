> [!warning]
> work in progress
> 
> i made this dotfiles for my device, if you have problems i will try to help you

## about

- os: `arch`
- wm: `hyprland`
- bar: `waybar`
- terminal: `kitty`
- shell: `fish`
- app launcher: `rofi`
- notify-daemon: `swaync`
- wallpaper-daemon: `swww`

## gallery

> [!warning]
> the gallery may be outdated and look differently

![main](Pictures/Screenshots/main.png)
![rofi](Pictures/Screenshots/rofi.png)
![powerMenu](Pictures/Screenshots/powerMenu.png)
![wallpaperChanger](Pictures/Screenshots/wallpaperChanger.png)

## install

1. `git clone https://github.com/wasomi/dotfiles ~/.dotfiles`
2. `pacman -S - < pkgList`
3. `paru -S - < aurPkgList`
4. `ln -s` for all folders in .dotfiles/.config
    
    example: `ln -s ~/.dotfiles/.config/hypr/ ~/.config/`
5. `ln -s ~/.dotfiles/.local/bin/ ~/.local/`
6. `ln -s ~/.dotfiles/Pictures/Wallpapers/ ~/Pictures/`
7. download [papirus icons with grey folders](https://www.gnome-look.org/p/1166289/) & place in `~/.local/share/icons`
8. download [bibata modern ice cursor](https://www.gnome-look.org/p/1197198) & place in `~/.local/share/icons`
9. start hyprland
10. select wallpaper

## optional pkgs

> i'm just using these packages

- `pacman -S - < optionalPkgList`

- `paru -S - < optionalAurPkgList`

## hotkeys

> i'll write it someday...

## features

> i'll write it someday...

## todo

- [ ] write features
- [ ] hotkey list in readme.md
- [ ] add all needed pkgs

## thanks to

- [zproger](https://github.com/Zproger/) for the [rofi scripts](https://github.com/Zproger/bspwm-dotfiles/tree/main/bin)
- [sane1090](https://www.youtube.com/@sane1090x) for the [theme switcher script](https://youtu.be/PLb2lA9jBCI?si=PrIcooBkzP5Gz0YF)
- [wallhaven](https://wallhaven.cc) for the wallpapers
- [mylinuxtowork](https://github.com/mylinuxforwork) for the [hyprland animations](https://github.com/mylinuxforwork/dotfiles/tree/main/share/dotfiles/.config/hypr/conf/animations)
- [dylanaraps](https://github.com/dylanaraps) for the [rofi theme](https://github.com/dylanaraps/pywal/blob/master/pywal/templates/colors-rofi-dark.rasi)
- [abhra00](https://github.com/Abhra00) for the [matugen gtk css](https://github.com/Abhra00/Matuprland/blob/main/matugen/templates/matugen-gtk.css)
- ai bots for providing useful examples
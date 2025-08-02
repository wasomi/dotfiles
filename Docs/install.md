# install

1. clone repo: `git clone https://github.com/wasomi/dotfiles ~/.dotfiles`
2. install needed pkgs: `pacman -S - < pkgList` & `paru -S - < aurPkgList`
3. make symbolic link for folders
   1. `ln -s` for all folders in .dotfiles/.config, example: `ln -s ~/.dotfiles/.config/hypr/ ~/.config/`
   2. `ln -s ~/.dotfiles/.local/bin/ ~/.local/`
   3. `ln -s ~/.dotfiles/Pictures/Wallpapers/ ~/Pictures/`
4. `chsh -s $(which fish)`
5. reboot system
6. start hyprland via command `h`
7. change the wallpaper using keybind `super + shift + w`

## optional pkgs

> i'm just using these packages

- `pacman -S - < optionalPkgList`
- `paru -S - < optionalAurPkgList`

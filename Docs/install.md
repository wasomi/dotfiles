## install

1. `git clone https://github.com/wasomi/dotfiles ~/.dotfiles`
2. `pacman -S - < pkgList`
3. `paru -S - < aurPkgList`
4. `ln -s` for all folders in .dotfiles/.config
    
    example: `ln -s ~/.dotfiles/.config/hypr/ ~/.config/`
5. `ln -s ~/.dotfiles/.local/bin/ ~/.local/`
6. `ln -s ~/.dotfiles/Pictures/Wallpapers/ ~/Pictures/`
7. `chsh -s $(which fish)`
8. start hyprland
9. select wallpaper

## optional pkgs

> i'm just using these packages

- `pacman -S - < optionalPkgList`

- `paru -S - < optionalAurPkgList`
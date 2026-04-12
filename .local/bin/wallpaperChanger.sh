#!/bin/bash

# Credits: https://www.youtube.com/@sane1090x

wall_dir="$HOME/Pictures/Wallpapers"
rofi_config="$HOME/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi"

if [ ! -d "$wall_dir" ]; then
    echo "Error: Wallpaper directory not found: $wall_dir" >&2
    notify-send -i -u critical "dialog-error-symbolic" "Error" "Wallpaper directory not found..." -r 8
    exit 1
fi

cd "$wall_dir" || exit 1

selected_wall=$(for img in *.jpg *.png; do
    [ -f "$img" ] && echo -en "$img\0icon\x1f$img\n"
done | rofi -dmenu -show-icons -config "$rofi_config")

cd - > /dev/null || exit 1

if [ -n "$selected_wall" ]; then
    wall_path="$wall_dir/$selected_wall"

    matugen image "$wall_path" -m "$settingsMode" --source-color-index 0 || { echo "Matugen failed..." && notify-send -i "dialog-error-symbolic" "Error" "Matugen failed..." -r 8 >&2; exit 1; }

    gsettings set org.gnome.desktop.interface gtk-theme "$settingsTheme"
    gsettings set org.gnome.desktop.interface color-scheme prefer-$settingsMode
    gsettings set org.gnome.desktop.interface icon-theme "$settingsIcons"
    gsettings set org.gnome.desktop.interface font-name "$settingsFont"
    gsettings set org.gnome.desktop.interface cursor-theme "$settingsCursor"

    envsubst < "$HOME/.dotfiles/.config/waybar/templates/config.jsonc" > "$HOME/.dotfiles/.config/waybar/config.jsonc"
    envsubst < "$HOME/.dotfiles/.config/waybar/templates/hyprland-workspaces.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-workspaces.jsonc"
    envsubst < "$HOME/.dotfiles/.config/waybar/templates/hyprland-language.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-language.jsonc"

    pkill dunst;  dunst & disown
    pkill waybar; waybar & disown
    pkill -f polkit-gnome-authentication-agent-1
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown

    pgrep kitty > /dev/null && pkill -SIGUSR1 kitty
    hyprctl reload

    notify-send -i "dialog-information-symbolic" "Theme applied" "Wallpaper and theme updated successfully!" -r 8 -t 1500

else
    echo "No wallpaper selected..." >&2
fi

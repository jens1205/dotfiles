#!/bin/sh

git clone --depth 1 git@github.com:dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
ln -s ~/.config/kitty/kitty-themes/themes/OneDark.conf ~/.config/kitty/theme.conf


#!/bin/sh
KITTY_THEME_DIR="$HOME/.local/share/kitty-themes"

if [ ! -d "$KITTY_THEME_DIR" ]; then
    git clone --depth 1 https://github.com/dexpota/kitty-themes.git "$KITTY_THEME_DIR"
else
    echo "kitty themes already installed"
fi

stow -t ~ kitty
stow -t ~ nvim
stow -t ~ tmux
stow -t ~ vim
stow -t ~ zsh


#!/bin/sh
KITTY_THEME_DIR="$HOME/.local/share/kitty-themes"
POWERLEVEL_THEME_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
FONT_DIR="$HOME/.local/share/fonts"

if [ ! -d "$KITTY_THEME_DIR" ]; then
    git clone --depth 1 https://github.com/dexpota/kitty-themes.git "$KITTY_THEME_DIR"
else
    echo "kitty themes already installed"
fi

if [ ! -d "$POWERLEVEL_THEME_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL_THEME_DIR"
else
    echo "powerlevel10k already installed"
fi

if [ ! -d "${FONT_DIR}" ]; then
    mkdir -p "${FONT_DIR}"
    tmpdir=$(mktemp -d)
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip -P $tmpdir
    unzip $tmpdir/FiraCode.zip -d $FONT_DIR
    echo "fc-cache -f"
    fc-cache -f
else
    echo "Found fonts dir $FONT_DIR"
fi


stow -t ~ kitty
stow -t ~ nvim
stow -t ~ tmux
stow -t ~ vim
stow -t ~ zsh


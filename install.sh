#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
DOTFILES="$(pwd)"

link() {
  local source_path="$DOTFILES/$1"
  local target_path="$2"
  mkdir -p "$(dirname "$target_path")"
  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    mv "$target_path" "$target_path.pre-dotfiles"
    echo "backed up $target_path"
  fi
  ln -sfn "$source_path" "$target_path"
  echo "linked $target_path"
}

link zshrc "$HOME/.zshrc"
link tmux.conf "$HOME/.tmux.conf"
link config/nvim "$HOME/.config/nvim"
link config/starship.toml "$HOME/.config/starship.toml"
link config/fastfetch "$HOME/.config/fastfetch"

mkdir -p "$HOME/.zsh"
[ -d "$HOME/.zsh/zsh-autosuggestions" ] \
  || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
[ -d "$HOME/.zsh/zsh-syntax-highlighting" ] \
  || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"

echo "done"

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
clone() {
  [ -d "$HOME/.zsh/$2" ] || git clone --depth 1 "$1" "$HOME/.zsh/$2"
}
clone https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
clone https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting
clone https://github.com/Aloxaf/fzf-tab fzf-tab
clone https://github.com/mroth/evalcache evalcache
[ -d "$HOME/.zsh/zsh-abbr" ] \
  || git clone --depth 1 --recurse-submodules https://github.com/olets/zsh-abbr "$HOME/.zsh/zsh-abbr"
[ -d "$HOME/.tmux/plugins/tpm" ] \
  || git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

if ! command -v laziergit >/dev/null && command -v cargo >/dev/null; then
  cargo install laziergit
fi

echo "done"

# dotfiles

workspace. wsl, zsh, starship, tmux, fastfetch, nvim

run ./install.sh to symlink everything, it also backs up whatever was there

set WIN_USER at the top of zshrc on a new machine

## prerequisites

- zsh (login shell), tmux, fastfetch, starship
- neovim 0.12+ (this setup runs it from `~/.local`)
- ripgrep (Telescope live grep)
- node and npm, then `npm i -g @fsouza/prettierd prettier` for formatting
- a nerd font in the terminal for the icons
- fzf 0.48+ from github releases
- laziergit (`cargo install laziergit`)
- `cargo binstall fd-find bat eza zoxide just jaq ast-grep` (atuin too, but
  `cargo install atuin --locked` on ubuntu 22.04, the prebuilt needs newer glibc)
- `go install github.com/joshmedeski/sesh/v2@latest`
- prefix+I inside tmux once, to install tpm plugins

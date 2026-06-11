export PATH="$HOME/.local/bin:$PATH"

# Auto-cd: typing a directory (e.g. `..` or `~/foo`) runs `cd` instead of trying
# to exec it. Without this, any PATH entry that's a directory makes `..` fail
# with "permission denied" because zsh tries to exec the matching child entry.
setopt AUTO_CD

WIN_USER="47488"

# Strip `/mnt/c/Users/$WIN_USER/` (Windows user home bare) from PATH. It contains
# subdirectories like `go/`, `.cargo/`, etc. that match Linux command names
# and cause "permission denied: <cmd>" because zsh tries to exec a directory.
typeset -U path
path=("${path[@]:#/mnt/c/Users/$WIN_USER}")
path=("${path[@]:#/mnt/c/Users/$WIN_USER/}")

# Linux Go (must come before the Windows go.exe interop entry).
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
path=("$GOROOT/bin" "$GOPATH/bin" "${path[@]}")

# Curated Windows interop paths. We disabled appendWindowsPath in
# /etc/wsl.conf (it injected ~60 /mnt/c entries that made completion/command
# lookup laggy on the 9p mount). Re-add only the handful worth keeping, and
# APPEND them so Linux binaries always win over their Windows namesakes.
for _wpath in \
  "/mnt/c/Windows/System32" \
  "/mnt/c/Users/$WIN_USER/AppData/Local/Programs/Microsoft VS Code/bin" \
  "/mnt/c/Users/$WIN_USER/AppData/Local/Microsoft/WindowsApps"; do
  [ -d "$_wpath" ] && path+=("$_wpath")
done
unset _wpath

# Auto-start tmux if not already in a tmux session
if [ -z "$TMUX" ] && [ -n "$SSH_TTY" -o -n "$WSL_DISTRO_NAME" ]; then
    tmux new-session -A -s main
fi

# Greeter: system info on a fresh interactive shell (runs inside tmux).
if [[ $- == *i* ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# Enable colors
export CLICOLOR=1
# Prompt is now provided by starship (init at the bottom of this file).
export EDITOR='nvim'
export VISUAL='nvim'

# Enable command completion.
# compaudit (the fpath security check) is the single biggest startup cost on
# this machine (~110ms). Only run the full audit/rebuild when the dump is more
# than 24h old; otherwise load it directly with -C (skips the slow audit).
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n $_zcompdump(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# Load zsh plugins. fzf-tab must come after compinit and before
# autosuggestions/syntax-highlighting.
[ -f ~/.zsh/evalcache/evalcache.plugin.zsh ] && source ~/.zsh/evalcache/evalcache.plugin.zsh
[ -f ~/.zsh/fzf-tab/fzf-tab.plugin.zsh ] && source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
[ -f ~/.zsh/zsh-abbr/zsh-abbr.plugin.zsh ] && source ~/.zsh/zsh-abbr/zsh-abbr.plugin.zsh
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'
  zstyle ':fzf-tab:complete:*' fzf-preview '[ -f $realpath ] && bat --color=always --style=numbers --line-range=:200 $realpath || eza -la --color=always $realpath 2>/dev/null'
fi

command -v zoxide >/dev/null 2>&1 && _evalcache zoxide init zsh
command -v atuin >/dev/null 2>&1 && _evalcache atuin init zsh --disable-up-arrow

# Set up zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Enable colored output for ls
if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -la --git'
  alias la='eza -a'
  alias l='eza -l'
  alias lt='eza --tree --level=2'
else
  alias ls='ls --color=auto'
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v jaq >/dev/null 2>&1 && alias jq='jaq'

# Enable colored output for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Clear screen alias
alias cls='clear'

# Up the directory tree. AUTO_CD doesn't catch these because zsh resolves them
# as PATH children and gets EACCES before falling through to auto-cd.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


# Vite+ bin (https://viteplus.dev)
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# extra completions
[ -d "$HOME/.local/share/zsh/site-functions" ] && fpath=("$HOME/.local/share/zsh/site-functions" $fpath)

# starship prompt (keep last so it wins the prompt). Shows repo name + git
# branch + status; config at ~/.config/starship.toml
_evalcache starship init zsh

# opencode
[ -d "$HOME/.opencode/bin" ] && export PATH=$HOME/.opencode/bin:$PATH

#!/bin/bash
# Symlink dotfiles from this repo to their expected locations.
# Run from the repo root: ./setup.sh
#
# Existing files are backed up to <path>.bak before symlinking.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "Backing up $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

# Wezterm
link "$REPO_DIR/.wezterm.lua" "$HOME/.wezterm.lua"

# On WSL, wezterm runs on the Windows side and reads from C:\Users\<user>\.wezterm.lua.
# Windows can't resolve symlinks pointing into the WSL filesystem, so copy instead.
if grep -qi microsoft /proc/version 2>/dev/null; then
  win_user="$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n')"
  if [ -n "$win_user" ] && [ -d "/mnt/c/Users/$win_user" ]; then
    cp "$REPO_DIR/.wezterm.lua" "/mnt/c/Users/$win_user/.wezterm.lua"
    echo "Copied .wezterm.lua -> /mnt/c/Users/$win_user/.wezterm.lua (re-run setup.sh after edits)"
  fi
fi

# Zsh
link "$REPO_DIR/.zshrc" "$HOME/.zshrc"

# Neovim (symlink entire directory)
link "$REPO_DIR/nvim" "$HOME/.config/nvim"

# Claude Code settings
link "$REPO_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$REPO_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

echo ""
echo "All configs linked. Changes in either direction stay in sync."

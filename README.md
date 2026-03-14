# Dev Environment Config

WezTerm + Neovim + Zsh configuration. Cross-platform (macOS / Windows+WSL).

## Setup

```bash
# Symlink wezterm + zsh
ln -sf $(pwd)/.wezterm.lua ~/.wezterm.lua
ln -sf $(pwd)/.zshrc ~/.zshrc

# Symlink nvim config
ln -sf $(pwd)/nvim ~/.config/nvim
```

## Shortcuts

`Mod` = `Cmd` on macOS, `Alt` on Windows.

### WezTerm

| Shortcut | Action |
|---|---|
| `Mod+Shift+-` | Split pane vertical |
| `Mod+Shift+=` | Split pane horizontal |
| `Mod+Arrow` | Navigate panes |
| `Mod+Shift+Arrow` | Resize panes |
| `Mod+w` | Close pane |
| `Mod+Enter` | Toggle fullscreen |
| `Mod+Shift+Space` | Quick select (URLs, paths, hashes) |
| `Mod+1-9` | Switch to tab |
| `Option+Left/Right` | Jump word (macOS) |

### Neovim

Leader key: `Space`

| Shortcut | Action |
|---|---|
| `Space ff` | Find files (Telescope) |
| `Space fg` | Search text (Telescope) |
| `Space fb` | Open buffers (Telescope) |
| `gd` | Go to definition |
| `gr` | Find references (Telescope) |
| `K` | Hover docs |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |

### LSP Servers (auto-installed via Mason)

- **pyright** — Python type checking
- **ruff** — Python linting/formatting
- **ts_ls** — TypeScript/JavaScript
- **lua_ls** — Lua

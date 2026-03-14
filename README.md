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

### Vim Essentials

#### Movement

| Shortcut | Action |
|---|---|
| `w` / `b` | Jump forward/back by word |
| `e` | Jump to end of word |
| `0` / `$` | Start/end of line |
| `^` | First non-blank character |
| `gg` / `G` | Top/bottom of file |
| `{` / `}` | Jump paragraph up/down |
| `%` | Jump to matching bracket |
| `Ctrl+d` / `Ctrl+u` | Half-page down/up |
| `f{char}` / `F{char}` | Jump to char forward/backward |
| `t{char}` / `T{char}` | Jump to before char forward/backward |
| `;` / `,` | Repeat last f/t forward/backward |

#### Editing

| Shortcut | Action |
|---|---|
| `ciw` | Change inner word |
| `ci"` / `ci(` / `ci{` | Change inside quotes/parens/braces |
| `di"` / `di(` / `di{` | Delete inside quotes/parens/braces |
| `yiw` | Yank (copy) inner word |
| `dd` / `yy` / `cc` | Delete/yank/change entire line |
| `D` / `C` | Delete/change to end of line |
| `o` / `O` | New line below/above |
| `p` / `P` | Paste after/before cursor |
| `u` / `Ctrl+r` | Undo/redo |
| `.` | Repeat last change |
| `>>` / `<<` | Indent/unindent line |
| `~` | Toggle case |

#### Visual Mode

| Shortcut | Action |
|---|---|
| `v` | Character select |
| `V` | Line select |
| `Ctrl+v` | Block (column) select |
| `vaw` | Select a word |
| `vi"` / `vi(` / `vi{` | Select inside quotes/parens/braces |
| `va"` / `va(` / `va{` | Select around (including delimiters) |

#### Search & Replace

| Shortcut | Action |
|---|---|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next/previous match |
| `*` / `#` | Search word under cursor forward/backward |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |

#### Marks & Jumps

| Shortcut | Action |
|---|---|
| `ma` | Set mark `a` |
| `'a` | Jump to mark `a` |
| `Ctrl+o` / `Ctrl+i` | Jump back/forward in jumplist |
| `gi` | Go to last insert position |

#### Windows & Buffers

| Shortcut | Action |
|---|---|
| `:w` / `:q` / `:wq` | Save/quit/save+quit |
| `:e file` | Open file |
| `:bn` / `:bp` | Next/previous buffer |
| `:bd` | Close buffer |
| `Ctrl+w s` | Split horizontal |
| `Ctrl+w v` | Split vertical |
| `Ctrl+w w` | Cycle windows |
| `Ctrl+w q` | Close window |

### LSP Servers (auto-installed via Mason)

- **pyright** — Python type checking
- **ruff** — Python linting/formatting
- **ts_ls** — TypeScript/JavaScript
- **lua_ls** — Lua

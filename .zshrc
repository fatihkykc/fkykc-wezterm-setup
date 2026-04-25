# No bell from zsh. NO_BEEP covers the line editor (already-at-EOL etc.);
# LIST_BEEP is a separate option that controls the completion-system beep
# (empty/ambiguous tab completion). External programs can still send \a.
setopt NO_BEEP
unsetopt LIST_BEEP

# Persistent, shared history across terminals.
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# WSL: if we start inside a Windows mount (e.g. C:\Users\...), jump to the project root.
if [[ -r /proc/version ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  [[ "$PWD" == /mnt/* ]] && cd /root/orbina
fi

# Prompt: bold cyan username, bold blue cwd
PROMPT='%B%F{cyan}%n%f%b:%B%F{blue}%~%f%b$ '

export PATH="$HOME/.local/bin:$PATH"
if [[ "$OSTYPE" == darwin* ]]; then
  export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
fi

# Allow `claude --dangerously-skip-permissions` as root in WSL.
# Claude Code gates the flag behind a non-root UID unless IS_SANDBOX=1.
export IS_SANDBOX=1


# set up fzf key bindings for fuzzy completion (requires fzf >=0.48 for --zsh)
if command -v fzf >/dev/null 2>&1 && fzf --zsh >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Ctrl+Arrow → word navigation. WezTerm sends CSI 1;5 C/D for Ctrl+Right/Left
# but zsh has no default bindkey for them. Same for Alt+Arrow on linux/wsl.
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
# Home/End and Delete keys (some terminals send these forms)
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[3~" delete-char

# Tell the terminal emulator the cwd after every prompt (OSC 7)
precmd() { printf '\033]7;file://%s%s\033\\' "${HOST:-$HOSTNAME}" "$PWD" }

# bun completions
[ -s "/root/.bun/_bun" ] && source "/root/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

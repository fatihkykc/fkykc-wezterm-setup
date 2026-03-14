# Prompt: bold cyan username, bold blue cwd
PROMPT='%B%F{cyan}%n%f%b:%B%F{blue}%~%f%b$ '

export PATH="$HOME/.local/bin:$PATH"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH


# set up fzf key bindings for fuzzy completion
source <(fzf --zsh)

#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
short_cwd=$(echo "$cwd" | sed "s|$HOME|~|")
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Build context usage string as "23.4k/200k"
if [ -n "$used" ] && [ -n "$max_tokens" ]; then
  ctx_str=$(awk -v used="$used" -v max="$max_tokens" 'BEGIN {
    tokens = used * max / 100
    if (tokens >= 1000000)      tok = sprintf("%.1fM", tokens/1000000)
    else if (tokens >= 1000)    tok = sprintf("%.1fk", tokens/1000)
    else                        tok = sprintf("%d", tokens)
    if (max >= 1000000)         lim = sprintf("%.0fM", max/1000000)
    else if (max >= 1000)       lim = sprintf("%.0fk", max/1000)
    else                        lim = sprintf("%d", max)
    print " | ctx: " tok "/" lim
  }')
elif [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  ctx_str=" | ctx: ${used_int}%"
else
  ctx_str=""
fi

# Build model string
if [ -n "$model" ]; then
  model_str=" | ${model}"
else
  model_str=""
fi

user=$(whoami)
printf '\033[1;36m%s\033[0m:\033[1;34m%s\033[0m\033[0;36m%s%s\033[0m' "$user" "$short_cwd" "$model_str" "$ctx_str"

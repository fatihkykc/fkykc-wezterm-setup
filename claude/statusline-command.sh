#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
short_cwd=$(echo "$cwd" | sed "s|$HOME|~|")
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Build context usage string
if [ -n "$used" ]; then
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

printf '\033[1;34m%s\033[0m\033[0;36m%s%s\033[0m' "$short_cwd" "$model_str" "$ctx_str"

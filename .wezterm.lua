local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Platform detection
local is_mac = wezterm.target_triple:find("darwin") ~= nil
local mod = is_mac and "SUPER" or "ALT"
local mod_shift = mod .. "|SHIFT"

-- Font and size
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13
config.initial_cols = 107
config.initial_rows = 33
config.line_height = 0.9
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- Minimal appearance
config.window_background_opacity = 0.92
config.color_scheme = "Builtin Solarized Dark"
config.colors = {
  background = "#1a1a1a",
  foreground = "#d0d0d0",
}
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.window_frame = {
  font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
  font_size = 11,
  active_titlebar_bg = "#1a1a1a",
  inactive_titlebar_bg = "#1a1a1a",
}
config.window_decorations = "TITLE | RESIZE"

-- macOS-specific
if is_mac then
  config.macos_window_background_blur = 20
  config.native_macos_fullscreen_mode = true
end

-- Assign each tab a different shade based on its index
local tab_colors = {
  "#2a2a3a", "#2a3a2a", "#3a2a2a", "#2a3a3a",
  "#3a2a3a", "#3a3a2a", "#2a2a4a", "#2a4a2a",
  "#4a2a2a",
}

wezterm.on("format-tab-title", function(tab)
  local idx = (tab.tab_index % #tab_colors) + 1
  local bg = tab_colors[idx]
  local fg = "#d0d0d0"
  if tab.is_active then
    fg = "#ffffff"
  end
  local title = tab.tab_index + 1 .. ": " .. tab.active_pane.title
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = " " .. title .. " " },
  }
end)

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- Default working directory and shell
if is_mac then
  config.default_cwd = wezterm.home_dir .. "/Documents/GitHub"
else
  config.default_domain = "WSL:Ubuntu"
  config.default_cwd = "/root/orbina"
end

-- Keybindings (Cmd on mac, Alt on windows)
config.keys = {
  -- Split panes
  { key = "-", mods = mod_shift, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "=", mods = mod_shift, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

  -- Navigate between panes
  { key = "LeftArrow", mods = mod, action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = mod, action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = mod, action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = mod, action = act.ActivatePaneDirection("Down") },

  -- Resize panes
  { key = "LeftArrow", mods = mod_shift, action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = mod_shift, action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow", mods = mod_shift, action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow", mods = mod_shift, action = act.AdjustPaneSize({ "Down", 5 }) },

  -- Close pane
  { key = "w", mods = mod, action = act.CloseCurrentPane({ confirm = true }) },

  -- Fullscreen toggle
  { key = "Enter", mods = mod, action = act.ToggleFullScreen },

  -- Quick select (URLs, paths, hashes)
  { key = " ", mods = mod_shift, action = act.QuickSelect },

  -- Quick tab switching
  { key = "1", mods = mod, action = act.ActivateTab(0) },
  { key = "2", mods = mod, action = act.ActivateTab(1) },
  { key = "3", mods = mod, action = act.ActivateTab(2) },
  { key = "4", mods = mod, action = act.ActivateTab(3) },
  { key = "5", mods = mod, action = act.ActivateTab(4) },
  { key = "6", mods = mod, action = act.ActivateTab(5) },
  { key = "7", mods = mod, action = act.ActivateTab(6) },
  { key = "8", mods = mod, action = act.ActivateTab(7) },
  { key = "9", mods = mod, action = act.ActivateTab(8) },
}

return config

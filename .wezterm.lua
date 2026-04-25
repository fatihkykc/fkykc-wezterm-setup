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
config.initial_cols = is_mac and 107 or 122
config.initial_rows = is_mac and 33 or 30
config.line_height = 0.9
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- Minimal appearance
config.window_background_opacity = is_mac and 0.92 or 0.95

config.color_scheme = "Builtin Solarized Dark"
config.colors = {
  background = "#1a1a1a",
  foreground = "#d0d0d0",
}
config.hide_tab_bar_if_only_one_tab = false
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

-- Show git branch in the right side of the tab bar
wezterm.on("update-right-status", function(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  if not cwd_uri then
    window:set_right_status("")
    return
  end
  local cwd = cwd_uri.file_path
  local git_cmd = is_mac
    and { "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" }
    or { "wsl.exe", "-d", "Ubuntu-22.04", "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" }
  local success, stdout, stderr = wezterm.run_child_process(git_cmd)
  if success then
    local branch = stdout:gsub("%s+", "")
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#7aa2f7" } },
      { Text = "  " .. branch .. "  " },
    }))
  else
    window:set_right_status("")
  end
end)

-- Pane separation: dim inactive panes for clear visual boundary
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

-- Disable kitty keyboard protocol. The richer encoding it sends for Ctrl+Arrow,
-- modified keys, and some <CR>/<Tab> combos confuses nvim and breaks plain
-- shell word-navigation bindings. Stick to the standard CSI sequences.
config.enable_kitty_keyboard = false

-- Bell: audible + visual flash
config.audible_bell = "SystemBeep"
config.visual_bell = {
  fade_in_duration_ms = 150,
  fade_out_duration_ms = 700,
  fade_in_function = "EaseIn",
  fade_out_function = "EaseOut",
  target = "BackgroundColor",
}
config.colors.visual_bell = "#ffffff"

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- Default working directory and shell
if is_mac then
  config.default_cwd = wezterm.home_dir .. "/Documents/GitHub"
else
  config.default_domain = "WSL:Ubuntu-22.04"
  config.wsl_domains = {
    {
      name = "WSL:Ubuntu-22.04",
      distribution = "Ubuntu-22.04",
      default_cwd = "/root/orbina",
    },
  }
end

-- Keybindings (Cmd on mac, Alt on windows)
config.keys = {
  -- Split panes
  { key = "phys:Minus", mods = mod_shift, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "phys:Equal", mods = mod_shift, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },



  -- Swap/move panes
  { key = "m", mods = mod_shift, action = act.PaneSelect({ mode = "SwapWithActive" }) },

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

  -- Copy / paste (Cmd on mac, Alt on windows/linux)
  { key = "c", mods = mod, action = act.CopyTo("Clipboard") },
  { key = "v", mods = mod, action = act.PasteFrom("Clipboard") },

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

  -- Lazygit (opens in a new bottom pane). Rely on PATH so the same binding
  -- works on macOS (homebrew) and WSL (apt/binary install).
  {
    key = "g",
    mods = mod,
    action = act.SplitPane({
      direction = "Down",
      size = { Percent = 70 },
      command = { args = { "lazygit" } },
    }),
  },

}

-- macOS-only: Option+Arrow = word navigation. On non-mac, OPT aliases ALT and
-- would clobber the ALT+Arrow pane-navigation bindings above.
if is_mac then
  table.insert(config.keys, { key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") })
  table.insert(config.keys, { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") })
end

-- Windows-only keybindings (Cmd equivalents already exist by default on macOS)
if not is_mac then
  table.insert(config.keys, { key = "t", mods = mod, action = act.SpawnCommandInNewTab({ domain = "CurrentPaneDomain", cwd = "/root/orbina" }) })
end

return config

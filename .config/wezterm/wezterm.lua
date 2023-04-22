local wezterm = require("wezterm")

if wezterm.config_builder then
	config = wezterm.config_builder()
end

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

local function isViProcess(pane)
	return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction)
	if isViProcess(pane) then
		local direction = {
			Left = "h",
			Down = "j",
			Up = "k",
			Right = "l",
		}
		window:perform_action(wezterm.action.SendKey({ key = direction[pane_direction], mods = "CTRL" }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down")
end)

return {
	cell_width = 0.9,
	color_scheme = "dark",
	color_schemes = {
		["dark"] = {
			background = "black",
			foreground = "silver",
		},
		["light"] = {
			background = "silver",
			foreground = "black",
		},
	},
	font = wezterm.font("JetBrains Mono"),
	font_size = 14.0,
	hide_mouse_cursor_when_typing = true,
	hide_tab_bar_if_only_one_tab = true,
	hyperlink_rules = {
		-- Linkify things that look like URLs and the host has a TLD name.
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		-- Example: https://example.com
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},
		-- linkify email addresses
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		-- Example: name@example.com
		{
			regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
			format = "mailto:$0",
		},
		-- file:// URI
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\bfile://\S*\b]],
			format = "$0",
		},
		-- Make username/project paths clickable. This implies paths like the following are for GitHub.
		-- As long as a full URL hyperlink regex exists above this it should not match a full URL to
		-- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
		-- Example: tmm/dotfiles
		{
			regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
			format = "https://www.github.com/$1/$3",
		},
		-- Linkify things that look like URLs with numeric addresses as hosts.
		-- E.g. http://127.0.0.1:8000 for a local development server,
		-- or http://192.168.1.1 for the web interface of many routers.
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
			format = "$0",
		},
	},
	keys = {
		-- CTRL
		{
			key = "h",
			mods = "CTRL",
			action = wezterm.action.EmitEvent("ActivatePaneDirection-left"),
		},
		{
			key = "l",
			mods = "CTRL",
			action = wezterm.action.EmitEvent("ActivatePaneDirection-right"),
		},
		{
			key = "k",
			mods = "CTRL",
			action = wezterm.action.EmitEvent("ActivatePaneDirection-up"),
		},
		{
			key = "j",
			mods = "CTRL",
			action = wezterm.action.EmitEvent("ActivatePaneDirection-down"),
		},
		{ key = "u", mods = "CTRL", action = wezterm.action.ScrollByPage(-1) },
		{ key = "d", mods = "CTRL", action = wezterm.action.ScrollByPage(1) },

		-- Leader
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
		},
		{
			key = "n",
			mods = "LEADER",
			action = wezterm.action.PromptInputLine({
				description = wezterm.format({
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
					end
				end),
			}),
		},
		{
			key = "r",
			mods = "LEADER",
			action = wezterm.action.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		},
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
		{
			key = "z",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},

		-- SUPER
		{
			key = "Enter",
			mods = "SUPER",
			action = wezterm.action.ToggleFullScreen,
		},
	},
	key_tables = {
		resize_pane = {
			{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 2 }) },
			{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 2 }) },
			{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 2 }) },
			{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 2 }) },
			{ key = "Escape", action = "PopKeyTable" },
		},
	},
	leader = { key = "a", mods = "CMD", timeout_milliseconds = 1000 },
	native_macos_fullscreen_mode = true,
	scrollback_lines = 10000,
	tab_bar_at_bottom = true,
	unzoom_on_switch_pane = false,
	window_close_confirmation = "NeverPrompt",
	window_frame = {
		border_left_width = 1,
		border_right_width = 1,
		border_bottom_height = 1,
		border_left_color = "#242424",
		border_right_color = "#242424",
		border_bottom_color = "#242424",
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

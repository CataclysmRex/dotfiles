local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	-- Set  base color scheme
	config.color_scheme = "Monokai Soda"
	config.colors = require("cyberdream")
	config.window_background_opacity = 1.0

	-- config.use_fancy_tab_bar = false

	config.window_frame = {
		active_titlebar_bg = "rgba(36, 36, 36, 0.8)",
		-- inactive_titlebar_bg = "#1e1e1e",

		font = wezterm.font("Hermit"),
	}

	-- Apply background color based on the platform
	local background = "#000000"

	if wezterm.target_triple:find("linux") then
		-- background = "#1d212f"
		-- background = "#31313A"
		background = "#242424"
		config.window_background_opacity = 0.8
		-- config.wayland_window_background_blur = true
		config.wayland_window_background_blur = true
	elseif wezterm.target_triple:find("apple") then
		config.font_size = 14
		background = "#222222"
		-- background = "#413c3a"
		config.window_background_opacity = 0.8
		config.macos_window_background_blur = 64
		config.window_frame.font_size = 14
	end

	config.colors = {
		background = background,
	}

	config.font = wezterm.font("Hermit")
	config.hide_tab_bar_if_only_one_tab = true
end

return M

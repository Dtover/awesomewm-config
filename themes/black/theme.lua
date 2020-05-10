-----------------------------------------------------------------------------------------------------------------------
--                                                   Black theme                                                      --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

-- This theme was inherited from another with overwriting some values
-- Check parent theme to find full settings list and its description
local theme = require("themes/colored/theme")


-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
theme.color.main   = "#FFFFFF"
theme.color.urgent = "#111111"
theme.color.border = "#FFFFFF"
theme.color.selected = "#828282"

-- Fonts
------------------------------------------------------------
theme.fonts = {
	main     = "Source Code Pro Semibold 13",      -- main font
	menu     = "Source Code Pro Semibold 13",      -- main menu font
	tooltip  = "Source Code Pro Semibold 13",      -- tooltip font
	notify   = "Source Code Pro Bold 14",   -- redflat notify popup font
	clock    = "Source Code Pro Semibold 13",   -- textclock widget font
	qlaunch  = "Source Code Pro Bold 14",   -- quick launch key label font
	keychain = "Source Code Pro Bold 14",   -- key sequence tip font
	title    = "Source Code Pro Bold 13", -- widget titles font
	tiny     = "Source Code Pro Bold 10", -- smallest font for widgets
	titlebar = "Source Code Pro Bold 13", -- client titlebar font
	--hotkeys  = {
		--main  = "Roboto 9",        -- hotkeys helper main font
		--key   = "Roboto 10", 		-- hotkeys helper key font (use monospace for align)
		--title = "Roboto 12",        -- hotkeys helper group title font
	--},
	hotkeys  = {
		main  = "Source Code Pro 10",             -- hotkeys helper main font
		key   = "Source Code Pro Semibold 10", -- hotkeys helper key font (use monospace for align)
		title = "Source Code Pro Bold 12",        -- hotkeys helper group title font
	},
	player   = {
		main = "Source Code Pro Bold 13", -- player widget main font
		time = "Source Code Pro Bold 15", -- player widget current time font
	},
}

theme.cairo_fonts = {
	tag         = { font = "Source Code Pro Semibold", size = 16, face = 1 }, -- tag widget font
	appswitcher = { font = "Source Code Pro Semibold", size = 20, face = 1 }, -- appswitcher widget font
	navigator   = {
		title = { font = "Source Code Pro Bold", size = 28, face = 1, slant = 0 }, -- window navigation title font
		main  = { font = "Source Code Pro Bold", size = 22, face = 1, slant = 0 }  -- window navigation  main font
	},

	desktop = {
		textbox = { font = "Source Code Pro Semibold", size = 24, face = 0 },
	},
}

-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/black"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 38 -- panel height
theme.wallpaper    = theme.path .. "/wallpaper/Orign.png"

-- Setup parent theme settings
--------------------------------------------------------------------------------

theme:update()

-- Desktop config
-----------------------------------------------------------------------------------------------------------------------
theme.desktop.textset = {
	--font  = "Belligerent Madness 20",
	font = "Iosevka 17",
	spacing = 10,
	color = {
		main       = theme.color.urgent,
		gray       = theme.color.desktop_gray,
		icon       = theme.color.desktop_icon,
		urgent     = theme.color.urgent,
		wibox      = theme.color.bg .. "00"
	}
}

---- Panel widgets
------------------------------------------------------------------------------------------------------------------------

-- Audio
theme.gauge.audio.blue.dash.plain = true
theme.gauge.audio.blue.dash.bar.num = 8
theme.gauge.audio.blue.dash.bar.width = 3
theme.gauge.audio.blue.dmargin = { 5, 0, 9, 9 }
theme.gauge.audio.blue.width = 86
theme.gauge.audio.blue.icon = theme.path .. "/widget/audio.svg"

-- individual margins for panel widgets
--------------------------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 12, 9, 6, 6 },
	textclock   = { 10, 10, 0, 0 },
	volume      = { 4, 9, 3, 3 },
	microphone  = { 5, 6, 6, 6 },
	keyboard    = { 9, 9, 3, 3 },
	mail        = { 9, 9, 3, 3 },
	tray        = { 8, 8, 7, 7 },
	cpu         = { 9, 3, 7, 7 },
	ram         = { 2, 2, 7, 7 },
	cpuram      = { 10, 10, 5, 5 },
	battery     = { 4, 4, 7, 7 },
	network     = { 4, 4, 7, 7 },
	updates     = { 6, 6, 6, 6 },
	taglist     = { 4, 4, 6, 4 },
	tasklist    = { 10, 0, 0, 0 }, -- centering tasklist widget
}

theme.widget.tasklist.char_digit = 6
theme.widget.tasklist.width = 100
theme.widget.tasklist.task = theme.gauge.task.init
theme.float.player.border_width = 2

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme

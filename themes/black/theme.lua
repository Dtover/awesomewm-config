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
--theme.color.urgent = "#877B83"
theme.color.urgent = "#111111"
theme.color.border = "#FFFFFF"
theme.color.selected = "#828282"


-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/black"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 38 -- panel height
theme.wallpaper    = theme.path .. "/wallpaper/custom.png"

-- Setup parent theme settings
--------------------------------------------------------------------------------

theme:update()

-- Desktop config
-----------------------------------------------------------------------------------------------------------------------
theme.desktop.textset = {
	font  = "Belligerent Madness 20",
	spacing = 10,
	color = {
		main       = theme.color.urgent,
		gray       = theme.color.desktop_gray,
		icon       = theme.color.desktop_icon,
		urgent     = theme.color.urgent,
		wibox      = theme.color.bg .. "00"
	}
}

--theme.apprunner.color = {}

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
	battery     = { 3, 9, 7, 7 },
	network     = { 4, 4, 7, 7 },
	updates     = { 6, 6, 6, 6 },
	taglist     = { 4, 4, 6, 4 },
	tasklist    = { 10, 0, 0, 0 }, -- centering tasklist widget
}

theme.widget.tasklist.char_digit = 6
theme.widget.tasklist.width = 100
theme.widget.tasklist.task = theme.gauge.task.init

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme

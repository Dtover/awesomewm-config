-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")
local beautiful = require("beautiful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	focus        = awful.client.focus.filter,
	raise        = true,
	size_hints_honor = false,
	screen       = awful.screen.preferred,
	placement    = awful.placement.no_overlap + awful.placement.no_offscreen
}

rules.floating_any = {
	instance = { "DTA", "copyq", "todo" },
	class = {
		"Arandr", "Gpick", "Kruler", "MessageWin", "Wpa_gui", "pinentry", "veromix",
		"xtightvncviewer", "flameshot", "Tk", "Variety", "baidunetdisk", "Baidunetdisk",
		"TelegramDesktop","zoom","Fcitx-config-gtk3", "Wine", "PacketTracer7", "Dialog", "LoginUI.py"
	},
	name = { "Event Tester" },
	role = { "AlarmWindow", "pop-up" }
}


-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)

	args = args or {}
	self.base_properties.keys = args.hotkeys.keys.client
	self.base_properties.buttons = args.hotkeys.mouse.client


	-- Build rules
	--------------------------------------------------------------------------------
	self.rules = {
		{
			rule       = {},
			properties = args.base_properties or self.base_properties
		},
		{
			rule_any   = args.floating_any or self.floating_any,
			properties = { floating = true },
			callback = function(c)
				awful.placement.centered(c, nil)
			end
		},
		{
			rule_any   = { type = { "normal", "dialog" }},
			except_any = { class = "netease-cloud-music" },
			properties = { titlebars_enabled = true }
		},
		{ 	rule = { class = "Google-chrome" },
			properties = { screen = 1, tag = "Tag2", switchtotag = true }
	    },
		{ 	rule = { class = "Brave-browser" },
			properties = { screen = 1, tag = "Tag3" }
	    },
		{ 	rule = { class = "netease-cloud-music" },
			properties = { titlebars_enabled = false, screen = 1, tag = "TagR" }
	    },
		{ 	rule = { class = "Wine" },
			properties = { titlebars_enabled = false, border_width = 0 }
	    },
		{ 	rule = { class = "code" },
			properties = { screen = 1, tag = "Tag4" }
	    },
		{
			rule = { class = "java-lang-Thread" },
			properties = { screen = 1, tag = "Tag3" }
		},
		{
			rule = { class = "jetbrains-idea" },
			properties = { screen = 1, tag = "Tag3" }
		},
		{
			rule = { class = "Zathura" },
			properties = { screen = 1, tag = "TagQ", switchtotag = true }
		},
		{
			rule = { class = "Wpspdf" },
			properties = { screen = 1, tag = "TagW" }
		},
		{
			rule = { class = "Wps" },
			properties = { screen = 1, tag = "TagW" }
		},
		{
			rule = { class = "Wpp" },
			properties = { screen = 1, tag = "TagW" }
		},
		{
			rule = { class = "Et" },
			properties = { screen = 1, tag = "TagW" }
		},
		{
			rule = { class = "code" },
			properties = { screen = 1, tag = "Tag4" }
		},
		{
			rule = { class = "uTools" },
			properties = { floating = true }
		},
		{
			rule = { name = "scratchpadd" },
			properties = { floating = true, x = 950, y = 550, width = 950, height = 600 }
		},
		{
			rule = { class = "mpv" },
			properties = { floating = true, x = 1200, y = 50, width = 640, height = 480 }
		},
		{
			rule = { class = "Sxiv", instance = "bgp" },
			properties = { floating = true, width = 1200, height = 800 },
			callback = function(c)
				awful.placement.centered(c, nil)
			end
		},
	}

	-- Set rules
	--------------------------------------------------------------------------------
	awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules

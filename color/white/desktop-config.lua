-----------------------------------------------------------------------------------------------------------------------
--                                               Desktop widgets config                                              --
-----------------------------------------------------------------------------------------------------------------------

-- No desktop ready for steel
-- Some temporary mock up here

-- Grab environment
local beautiful = require("beautiful")
local wibox = require("wibox")
local timer = require("gears.timer")

local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local desktop = {}

-- desktop aliases
local system = redflat.system
local read = redflat.util.read
local wa = mouse.screen.workarea

-- Desktop widgets
-----------------------------------------------------------------------------------------------------------------------
function desktop:init(args)
	if not beautiful.desktop then return end

	-- init vars
	args = args or {}
	local env = args.env or {}
	local autohide = env.desktop_autohide or false
	local font = "Iosevka 20"

	local function base_box(label, height)
		local box =  wibox.widget({
			text          = label,
			font          = font,
			valign        = "top",
			forced_height = height,
			widget        = wibox.widget.textbox,
		})

		box._label = label
		return box
	end

	local function storage_check(label, fs)
		local box = wibox.widget({
			text   = label,
			font   = font,
			widget = wibox.widget.textbox,
		})

		-- awesome v4.3 timer API used
		box._label = label
		box._timer = timer({
			timeout   = 60 * 10,
			call_now  = true,
			autostart = true,
			callback  = function()
				local data = system.fs_info(fs)
				local color, text = get_level(fs_levels, data[1])
				box:set_markup(string.format(
					'<span color="%s">%s</span> <span color="%s">%s</span>',
					beautiful.color.icon, box._label, color, text
				))
			end
		})

		return box
	end

	-- init widgets
	local boxes = { storage = {}, memory = {} }
	local main = { body = {} }

	boxes.todotitle = base_box("TODO_List for today:")
	boxes.todo = base_box(read.output("showtodo"))

	boxes.sentencetitle = base_box("Jinrishici or Hitokoto:")
	boxes.sentence = base_box(read.output("sentence"))

	-- construct layout
	main.body.area = wibox.widget({
		boxes.todotitle,
		boxes.todo,
		boxes.sentencetitle,
		boxes.sentence,
		spacing = 20,
		layout  = wibox.layout.fixed.vertical
	})
	main.body.style = beautiful.desktop

	boxes.todo.timer = timer({
		timeout   = 100,
		call_now  = true,
		autostart = true,
		callback = function()
			local data = read.output("showtodo")
			boxes.todo.text = data
		end
	})

	boxes.sentence.timer = timer({
		timeout   = 3600,
		call_now  = true,
		autostart = true,
		callback = function()
			local data = read.output("sentence")
			boxes.sentence.text = data
		end
	})

	-- calculate geometry
	local wibox_height = 400
	local wibox_x = 950
	main.geometry = {
		x = wibox_x, y = wa.y + (wa.height - wibox_height) / 2,
		width = wa.width - wibox_x, height = wibox_height
	}

	-- Desktop setup
	--------------------------------------------------------------------------------
	local desktop_objects = { main }

	if not autohide then
		redflat.util.desktop.build.static(desktop_objects, args.buttons)
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop

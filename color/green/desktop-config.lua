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
			valign        = "middle",
			forced_height = height,
			widget        = wibox.widget.textbox,
		})
		box._label = label
		return box
	end

	--local function storage_check(label, fs)
		--local box = wibox.widget({
			--text   = label,
			--font   = font,
			--widget = wibox.widget.textbox,
		--})

		--box._label = label
		--box._timer = timer({
			--timeout   = 60 * 10,
			--call_now  = true,
			--autostart = true,
			--callback  = function()
				--local data = system.fs_info(fs)
				--local color, text = get_level(fs_levels, data[1])
				--box:set_markup(string.format(
					--'<span color="%s">%s</span> <span color="%s">%s</span>',
					--beautiful.color.icon, box._label, color, text
				--))
			--end
		--})

		--return box
	--end

	-- init widgets
	local boxes = { storage = {}, memory = {} }
	local main = { body = {} }

	local class = nil
	boxes.classtitle = base_box("Class for today:")
	local function getClass()
		if(read.output("class_schedule") == "") then
			class = "No class following"
		else
			class = read.output("class_schedule")

		end
		return class
	end
	--boxes.class = base_box(read.output("class_schedule"))
	boxes.class = base_box(getClass())

	boxes.todotitle = base_box("TODO list for today:")
	boxes.todo = base_box(read.output("showtodo"))

	local sep = "-----------------------------------------------------"
	boxes.separater = base_box(sep)
	boxes.separater:set_markup(string.format(
		'<span color="%s">%s</span>',
		beautiful.color.main, sep
	))
	--boxes.sentencetitle = base_box("Jinrishici/Hitokoto:")
	boxes.sentencetitle = base_box("One sentence:")
	boxes.sentence = base_box(read.output("sentence"))

	-- Calendar
	--------------------------------------------------------------------------------
	local cwidth = 100 -- calendar widget width
	local cy = 21      -- calendar widget upper margin
	local cheight = wa.height - 2*cy

	local calendar = {
		args     = { timeout = 60 },
		geometry = { x = wa.width - cwidth, y = cy, width = cwidth, height = cheight }
	}

	-- construct layout
	main.body.area = wibox.widget({
		boxes.classtitle,
		boxes.class,
		boxes.separater,
		boxes.todotitle,
		boxes.todo,
		boxes.separater,
		boxes.sentencetitle,
		boxes.sentence,
		spacing = 20,
		layout  = wibox.layout.fixed.vertical
	})
	main.body.style = beautiful.desktop

	boxes.class.timer = timer({
		timeout = 10,
		call_now = true,
		autostart = true,
		callback = function()
			boxes.class.text = getClass()
		end
	})

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


	calendar.body = redflat.desktop.calendar(calendar.args, calendar.style)

	-- calculate geometry
	local wibox_height = 800
	local wibox_x = 200
	main.geometry = {
		x = wibox_x, y = wa.y + (wa.height - wibox_height) / 2,
		width = wa.width - wibox_x, height = wibox_height
	}

	-- Desktop setup
	--------------------------------------------------------------------------------
	local desktop_objects = { main, calendar }
	--local desktop_objects = { main }

	if not autohide then
		redflat.util.desktop.build.static(desktop_objects)
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end

	calendar.body:activate_wibox(calendar.wibox)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop

-----------------------------------------------------------------------------------------------------------------------
--                                            RedFlat special_separator widget                                       --
-----------------------------------------------------------------------------------------------------------------------
-- special separator to decorate panel
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
-----------------------------------------------------------------------------------------------------------------------
local wibox = require("wibox")
local beautiful = require("beautiful")
local color = require("gears.color")

local redutil = require("redflat.util")

-- Initialize tables for module
-----------------------------------------------------------------------------------------------------------------------
local special_separator = {}

-- Generate default theme vars
-----------------------------------------------------------------------------------------------------------------------
local function default_style()
	local style = {
		marginv = { 0, 0, 0, 0 },
		marginh = { 0, 0, 0, 0 },
		color  = { shadow1 = "#141414", shadow2 = "#313131" }
	}
	return redutil.table.merge(style, redutil.table.check(beautiful, "gauge.separator") or {})
end

-- Create a new separator widget
-- Total size two pixels bigger than sum of margins for general direction
-----------------------------------------------------------------------------------------------------------------------
local function special_separator_base(horizontal, style)

	-- Initialize vars
	--------------------------------------------------------------------------------
	style = redutil.table.merge(default_style(), style or {})
	if not style.margin then
		style.margin = horizontal and style.marginh or style.marginv
	end

	-- Create custom widget
	--------------------------------------------------------------------------------
	local widg = wibox.widget.base.make_widget()

	-- Fit
	------------------------------------------------------------
	function widg:fit(_, width, height)
		if horizontal then
			return width, 2 + style.margin[3] + style.margin[4]
		else
			return 2 + style.margin[1] + style.margin[2], height
		end
	end

	-- Draw
	------------------------------------------------------------
	function widg:draw(_, cr, width, height)
		local w = width - style.margin[1] - style.margin[2]
		local h = height - style.margin[3] - style.margin[4]

		cr:translate(style.margin[1], style.margin[3])
		cr:set_source(color(style.color.shadow1))
		if horizontal then
			cr:rectangle(0, 0, w, 1)
			--cr:move_to(-2.5, 0)
			--cr:rel_line_to()
		else
			cr:move_to(-2.5, 0)
			cr:rel_line_to(1, 0)
			cr:rel_line_to(5, h)
			cr:rel_line_to(-1, 0)
			cr:close_path()
		end
		cr:fill()

		cr:set_source(color(style.color.shadow2))
		if horizontal then
			cr:rectangle(0, 1, w, 1)
		else
			cr:move_to(-1.5, 0)
			cr:rel_line_to(1, 0)
			cr:rel_line_to(5, h)
			cr:rel_line_to(-1, 0)
			cr:close_path()
		end
		cr:fill()
	end

	--------------------------------------------------------------------------------
	return widg
end

-- Horizontal and vertical variants
-----------------------------------------------------------------------------------------------------------------------
function special_separator.tilt(style)
	return special_separator_base(false, style)
end

function special_separator.dpowerline(style)
	return special_separator_base(true, style)
end

-----------------------------------------------------------------------------------------------------------------------
return special_separator

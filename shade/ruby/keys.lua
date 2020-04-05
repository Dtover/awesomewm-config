-----------------------------------------------------------------------------------------------------------------------
--                                          Hotkeys and mouse buttons config                                         --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local redflat = require("redflat")
-- for test
local naughty = require("naughty")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = { mouse = {}, raw = {}, keys = {}, fake = {} }

-- key aliases
local apprunner = redflat.float.apprunner
local appswitcher = redflat.float.appswitcher
local current = redflat.widget.tasklist.filter.currenttags
local allscr = redflat.widget.tasklist.filter.allscreen
local laybox = redflat.widget.layoutbox
local grid = redflat.layout.grid
local redtip = redflat.float.hotkeys
local redtitle = redflat.titlebar

-- Key support functions
-----------------------------------------------------------------------------------------------------------------------
local focus_switch_byd = function(dir)
	return function()
		awful.client.focus.bydirection(dir)
		if client.focus then client.focus:raise() end
	end
end

local function minimize_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) then c.minimized = true end
	end
end

local function minimize_all_except_focused()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c ~= client.focus then c.minimized = true end
	end
end

local function restore_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and c.minimized then c.minimized = false end
	end
end

local function kill_all()
	for _, c in ipairs(client.get()) do
		if current(c, mouse.screen) and not c.sticky then c:kill() end
	end
end

local function focus_to_previous()
	awful.client.focus.history.previous()
	if client.focus then client.focus:raise() end
end

local function restore_client()
	local c = awful.client.restore()
	if c then client.focus = c; c:raise() end
end

local function toggle_placement(env)
	env.set_slave = not env.set_slave
	redflat.float.notify:show({ text = (env.set_slave and "Slave" or "Master") .. " placement" })
end

local function restore_all_then_switch_to_fullscreen()
	local c = awful.client.restore()
	if c then client.focus = c; end
	awful.layout.set(awful.layout.layouts[8])
end

local function vhtile_toggle()
	local c = awful.layout.getname()
	if ( c == "tile") then
		awful.layout.set(awful.layout.layouts[3])
	else
		if ( c == "tilebottom") then
			awful.layout.set(awful.layout.layouts[2])
		end
	end
end

local function tag_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then action(tag) end
		end
	)
end

local function client_numkey(i, mod, action)
	return awful.key(
		mod, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then action(tag) end
			end
		end
	)
end


-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function hotkeys:init(args)

	-- Init vars
	------------------------------------------------------------
	args = args or {}
	local env = args.env
	local volume = args.volume
	local mainmenu = args.menu

	self.mouse.root = (awful.util.table.join(
		awful.button({ }, 3, function () mainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	))

	-- volume functions
	local volume_raise = function() volume:change_volume({ show_notify = true })              end
	local volume_lower = function() volume:change_volume({ show_notify = true, down = true }) end
	local volume_mute  = function() volume:mute() end

	-- Layouts
	--------------------------------------------------------------------------------
	-- this is example for layouts hotkeys setup, see other color configs for more

	 --local layout_tile = {
		 --{
			 --{ env.mod }, "l", function () awful.tag.incmwfact( 0.05) end,
			 --{ description = "Increase master width factor", group = "Layout" }
		 --},
		 --{
			 --{ env.mod }, "h", function () awful.tag.incmwfact(-0.05) end,
			 --{ description = "Decrease master width factor", group = "Layout" }
		 --},
		 --{
			 --{ env.mod }, "k", function () awful.client.incwfact( 0.05) end,
			 --{ description = "Increase window factor of a client", group = "Layout" }
		 --},
		 --{
			 --{ env.mod }, "j", function () awful.client.incwfact(-0.05) end,
			 --{ description = "Decrease window factor of a client", group = "Layout" }
		 --},
		 --{
			 --{ env.mod, }, "+", function () awful.tag.incnmaster( 1, nil, true) end,
			 --{ description = "Increase the number of master clients", group = "Layout" }
		 --},
		 --{
			 --{ env.mod }, "-", function () awful.tag.incnmaster(-1, nil, true) end,
			 --{ description = "Decrease the number of master clients", group = "Layout" }
		 --},
		 --{
			 --{ env.mod, "Control" }, "+", function () awful.tag.incncol( 1, nil, true) end,
			 --{ description = "Increase the number of columns", group = "Layout" }
		 --},
		 --{
			 --{ env.mod, "Control" }, "-", function () awful.tag.incncol(-1, nil, true) end,
			 --{ description = "Decrease the number of columns", group = "Layout" }
		 --},
	 --}

	 --laycom:set_keys(layout_tile, "tile")

	-- Keys for widgets
	--------------------------------------------------------------------------------

	-- Apprunner widget
	------------------------------------------------------------
	local apprunner_keys_move = {
		{
			{ env.mod }, "j", function() apprunner:down() end,
			{ description = "Select next item", group = "Navigation" }
		},
		{
			{ env.mod }, "k", function() apprunner:up() end,
			{ description = "Select previous item", group = "Navigation" }
		},
	}

	apprunner:set_keys(awful.util.table.join(apprunner.keys.move, apprunner_keys_move), "move")

	-- Menu widget
	------------------------------------------------------------
	local menu_keys_move = {
		{
			{ env.mod }, "j", redflat.menu.action.down,
			{ description = "Select next item", group = "Navigation" }
		},
		{
			{ env.mod }, "k", redflat.menu.action.up,
			{ description = "Select previous item", group = "Navigation" }
		},
		{
			{ env.mod }, "h", redflat.menu.action.back,
			{ description = "Go back", group = "Navigation" }
		},
		{
			{ env.mod }, "l", redflat.menu.action.enter,
			{ description = "Open submenu", group = "Navigation" }
		},
	}

	redflat.menu:set_keys(awful.util.table.join(redflat.menu.keys.move, menu_keys_move), "move")

	-- Appswitcher
	------------------------------------------------------------
	local appswitcher_keys_move = {
		{
			{ env.mod }, "a", function() appswitcher:switch() end,
			{ description = "Select next app", group = "Navigation" }
		},
		{
			{ env.mod, "Shift" }, "a", function() appswitcher:switch({ reverse = true }) end,
			{ description = "Select previous app", group = "Navigation" }
		},
	}

	local appswitcher_keys_action = {
		{
			{ env.mod }, "Super_L", function() appswitcher:hide() end,
			{ description = "Activate and exit", group = "Action" }
		},
		{
			{}, "Escape", function() appswitcher:hide(true) end,
			{ description = "Exit", group = "Action" }
		},
	}

	appswitcher:set_keys(awful.util.table.join(appswitcher.keys.move, appswitcher_keys_move), "move")
	appswitcher:set_keys(awful.util.table.join(appswitcher.keys.action, appswitcher_keys_action), "action")


	-- Emacs like key sequences
	--------------------------------------------------------------------------------

	-- initial key
	-- first prefix key, no description needed here
	local keyseq = { { env.mod }, "semicolon", {}, {} }

	-- second sequence keys
	keyseq[3] = {
		-- second and last key in sequence, full description and action is necessary

		-- not last key in sequence, no description needed here
		{ {}, "k", {}, {} }, -- application kill group
		{ {}, "n", {}, {} }, -- application minimize group
		{ {}, "r", {}, {} }, -- application restore group
		{
			{}, "m", function() awful.spawn(env.musicplayer, false) end,
			{ description = "Run cloud music", group = "Run app" }
		},
		{
			{}, "i", function() awful.spawn(env.idea, false) end,
			{ description = "Run IDEA", group = "Run app" }
		},
		{
			{}, "p", function() awful.spawn(env.bgpselector, false) end,
			{ description = "Run sxiv selector", group = "Run app" }
		},
		{
			{}, "t", function() awful.spawn(env.todo, false) end,
			{ description = "Run todo builder", group = "Run app" }
		},
		--{
			--{}, "a", function() awful.spawn(env.ssh) end,
			--{ description = "Run ssh in st", group = "Run app" }
		--}

		-- { {}, "g", {}, {} }, -- run or rise group
		-- { {}, "f", {}, {} }, -- launch application group
	}

	-- application kill actions,
	-- last key in sequence, full description and action is necessary
	keyseq[3][1][3] = {
		{
			{}, "f", function() if client.focus then client.focus:kill() end end,
			{ description = "Kill focused client", group = "Kill application", keyset = { "f" } }
		},
		{
			{}, "a", kill_all,
			{ description = "Kill all clients with current tag", group = "Kill application", keyset = { "a" } }
		},
	}

	-- application minimize actions,
	-- last key in sequence, full description and action is necessary
	keyseq[3][2][3] = {
		{
			{}, "f", function() if client.focus then client.focus.minimized = true end end,
			{ description = "Minimized focused client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", minimize_all,
			{ description = "Minimized all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
		--{
			--{}, "e", minimize_all_except_focused,
			--{ description = "Minimized all clients except focused", group = "Clients managment", keyset = { "e" } }
		--},
	}

	-- application restore actions,
	-- last key in sequence, full description and action is necessary
	keyseq[3][3][3] = {
		{
			{}, "f", restore_client,
			{ description = "Restore minimized client", group = "Clients managment", keyset = { "f" } }
		},
		{
			{}, "a", restore_all,
			{ description = "Restore all clients with current tag", group = "Clients managment", keyset = { "a" } }
		},
	}

	-- quick launch key sequence actions, auto fill up last sequence key
	-- for i = 1, 9 do
	-- 	local ik = tostring(i)
	-- 	table.insert(keyseq[3][5][3], {
	-- 		{}, ik, function() qlaunch:run_or_raise(ik) end,
	-- 		{ description = "Run or rise application №" .. ik, group = "Run or Rise", keyset = { ik } }
	-- 	})
	-- 	table.insert(keyseq[3][6][3], {
	-- 		{}, ik, function() qlaunch:run_or_raise(ik, true) end,
	-- 		{ description = "Launch application №".. ik, group = "Quick Launch", keyset = { ik } }
	-- 	})
	-- end


	-- Global keys
	--------------------------------------------------------------------------------
	self.raw.root = {
		{
			{ env.mod }, "s", function() redtip:show() end,
			{ description = "[Hold]Show hotkeys helper", group = "Main" }
		},
		{
			{ env.mod }, "r", function () redflat.service.navigator:run() end,
			{ description = "Window control mode", group = "Main" }
		},
		{
			{ env.mod, "Shift" }, "r", awesome.restart,
			{ description = "Reload awesome", group = "Main" }
		},
		{
			{ env.mod }, "semicolon", function() redflat.float.keychain:activate(keyseq, "User") end,
			{ description = "User key sequence", group = "Main" }
		},
		{
			{ env.mod }, "Return", function() awful.spawn(env.terminal) end,
			{ description = "Open a terminal", group = "Main" }
		},
		{
			{ env.mod, "Shift" }, "Return", function() awful.spawn(env.scratchpad) end,
			{ description = "Open a floating terminal", group = "Main" }
		},
		{
			{ env.mod }, "l", focus_switch_byd("right"),
			{ description = "Go to right client", group = "Client focus" }
		},
		{
			{ env.mod }, "h", focus_switch_byd("left"),
			{ description = "Go to left client", group = "Client focus" }
		},
		{
			{ env.mod }, "k", focus_switch_byd("up"),
			{ description = "Go to upper client", group = "Client focus" }
		},
		{
			{ env.mod }, "j", focus_switch_byd("down"),
			{ description = "Go to lower client", group = "Client focus" }
		},
		{
			{ env.mod }, "u", awful.client.urgent.jumpto,
			{ description = "Go to urgent client", group = "Client focus" }
		},
		{
			{ env.mod, "Shift" }, "h", function() awful.client.swap.bydirection("left") end,
			{ description = "swap with left client", group = "Client swap" }
		},
		{
			{ env.mod, "Shift" }, "j", function() awful.client.swap.bydirection("down") end,
			{ description = "swap with below client", group = "Client swap" }
		},
		{
			{ env.mod, "Shift" }, "k", function() awful.client.swap.bydirection("up") end,
			{ description = "swap with above client", group = "Client swap" }
		},
		{
			{ env.mod, "Shift" }, "l", function() awful.client.swap.bydirection("right") end,
			{ description = "swap with right client", group = "Client swap" }
		},
		{
			{ env.mod }, "Tab", focus_to_previous,
			{ description = "Go to previos client", group = "Client focus" }
		},
		{
			{ env.mod, "Shift" }, "Tab", restore_all_then_switch_to_fullscreen,
			{ description = "Restore client then set current tag fullscreen", group = "Client focus" }
		},
		{
			{ env.mod }, "w", function() mainmenu:show() end,
			{ description = "Show main menu", group = "Widgets" }
		},
		{
			{ env.mod }, "d", function() apprunner:show() end,
			{ description = "Application launcher", group = "Widgets" }
		},
		{
			{ env.mod,  "Shift" }, "d", function() redflat.float.prompt:run() end,
			{ description = "Show the prompt box", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "p", function() redflat.widget.minitray:toggle() end,
			{ description = "Show minitray", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "o", function() redflat.float.top:show("cpu") end,
			{ description = "Show cpu usage", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "i", function() redflat.float.top:show("mem") end,
			{ description = "Show memory usage", group = "Widgets" }
		},
		{
			{ env.mod, "Control" }, "d", function() redflat.float.qlaunch:show() end,
			{ description = "Application quick launcher", group = "Main" }
		},
		{
			{ env.mod }, "t", function() redtitle.toggle(client.focus) end,
			{ description = "Show/hide titlebar for focused client", group = "Titlebar" }
		},
		{
			{ env.mod, "Control" }, "t", function() redtitle.switch(client.focus) end,
			{ description = "Switch titlebar view for focused client", group = "Titlebar" }
		},
		{
			{ env.mod, "Shift" }, "t", function() redtitle.toggle_all() end,
			{ description = "Show/hide titlebar for all clients", group = "Titlebar" }
		},
		{
			{ env.mod, "Control", "Shift" }, "t", function() redtitle.global_switch() end,
			{ description = "Switch titlebar view for all clients", group = "Titlebar" }
		},
		{
			{ env.mod }, "a", nil, function() appswitcher:show({ filter = current }) end,
			{ description = "Switch to next with current tag", group = "Application switcher" }
		},
		--{
			--{ env.mod }, "q", nil, function() appswitcher:show({ filter = current, reverse = true }) end,
			--{ description = "Switch to previous with current tag", group = "Application switcher" }
		--},
		{
			{ env.mod, "Shift" }, "a", nil, function() appswitcher:show({ filter = allscr }) end,
			{ description = "Switch to next through all tags", group = "Application switcher" }
		},
		--{
			--{ env.mod, "Shift" }, "q", nil, function() appswitcher:show({ filter = allscr, reverse = true }) end,
			--{ description = "Switch to previous through all tags", group = "Application switcher" }
		--},
		{
			{ env.mod }, "`", awful.tag.history.restore,
			{ description = "Go previos tag", group = "Tag navigation" }
		},
		--{
			--{ env.mod }, "Right", awful.tag.viewnext,
			--{ description = "View next tag", group = "Tag navigation" }
		--},
		--{
			--{ env.mod }, "Left", awful.tag.viewprev,
			--{ description = "View previous tag", group = "Tag navigation" }
		--},
		{
			{ env.mod }, "y", function() laybox:toggle_menu(mouse.screen.selected_tag) end,
			{ description = "Show layout menu", group = "Layouts" }
		},
		{
			{ env.mod }, "Up", function() awful.layout.inc(-1) end,
			{ description = "Select next layout", group = "Layouts" }
		},
		{
			{ env.mod }, "Down", function() awful.layout.inc(1) end,
			{ description = "Select previous layout", group = "Layouts" }
		},
		{
			{ env.mod }, "Left", function() awful.layout.set(awful.layout.layouts[2]) end,
			{ description = "Set the current tag layout as right tile", group = "Layouts" }
		},
		{
			{ env.mod }, "Right", function() awful.layout.set(awful.layout.layouts[1]) end,
			{ description = "Set the current tag layout as floating", group = "Layouts" }
		},
		{
			{ env.mod, "Shift" }, "n", restore_client,
			{ description = "Restore minimized client", group = "Client keys" }
		},
		{
			{ env.mod }, "e", vhtile_toggle,
			{ description = "Toggle layout between tile and tilebottom", group = "Clients managment" }
		},
		{
			{ env.mod }, "p", function () toggle_placement(env) end,
			{ description = "Switch master/slave window placement", group = "Clients managment" }
		},
		{
			{ env.mod }, "m", function() redflat.float.scratch.toggle() end,
			{ description = "Toggle scratchpad", group = "Client keys" }
		},
		-- keys to run apps
		{
			{ env.mod, "Shift" }, "e", function () awful.spawn(env.asrl, false) end,
			{ description = "Run system options", group = "App launcher keys" }
		},
		{
			{ env.mod }, "b", function () awful.spawn(env.brave, false) end,
			{ description = "Run brave browser", group = "App launcher keys" }
		},
		{
			{ env.mod }, "c", function () awful.spawn(env.browser, false) end,
			{ description = "Run chrome browser", group = "App launcher keys" }
		},
		{
			{ env.mod, "Shift" }, "s", function() awful.spawn(env.ssh, false) end,
			{ description = "Connect to server in st", group = "App launcher keys" }
		},
		{
			{ env.mod }, "x", function() awful.spawn(env.iconpick_2, false) end,
			{ description = "Launcher a iconpick", group = "App launcher keys" }
		},
		{
			{ env.mod, "Shift" }, "x", function() awful.spawn(env.iconpick_1, false) end,
			{ description = "Launcher a iconpick", group = "App launcher keys" }
		},
		{
			{ env.mod }, "g", function() awful.spawn(env.betterlock, false) end,
			{ description = "Lock screen with betterlockscreen", group = "Lock screen" }
		},
		{
			{ env.mod, "Shift" }, "g", function() awful.spawn(env.i3lock, false) end,
			{ description = "Lock screen with i3lock-fancy", group = "Lock screen" }
		},
		{
			{}, "XF86AudioRaiseVolume", volume_raise,
			{ description = "Increase volume", group = "Volume control" }
		},
		{
			{}, "XF86AudioLowerVolume", volume_lower,
			{ description = "Reduce volume", group = "Volume control" }
		},
		{
			{}, "XF86AudioMute", volume_mute,
			{ description = "Mute audio", group = "Volume control" }
		},

	}

	-- Client keys
	--------------------------------------------------------------------------------
	self.raw.client = {
		--{
			--{ env.mod }, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end,
			--{ description = "Toggle fullscreen", group = "Client keys" }
		--},
    --awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              --{description = "increase the number of master clients", group = "layout"}),
    --awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              --{description = "decrease the number of master clients", group = "layout"}),
		{
			{ env.mod, "Control" }, "h", function() awful.tag.incmwfact( -0.05 ) end,
			{ descritption = "increase the number of master clients", group = "Client keys" },
		},
		{
			{ env.mod, "Control" }, "l", function() awful.tag.incmwfact( 0.05 ) end,
			{ descritption = "increase the number of master clients", group = "Client keys" },
		},
		{
			{ env.mod, "Shift" }, "q", function(c) c:kill() end,
			{ description = "Close", group = "Client keys" }
		},
		{
			{ env.mod, "Shift" }, "space", awful.client.floating.toggle,
			{ description = "Toggle floating", group = "Client keys" }
		},
		{
			{ env.mod, "Shift" }, "=", function(c) c.ontop = not c.ontop end,
			{ description = "Toggle keep on top", group = "Client keys" }
		},
		{
			{ env.mod }, "f", function(c) c.maximized = not c.maximized; c:raise() end,
			{ description = "Maximize", group = "Client keys" }
		},
		{
			{ env.mod }, "n", function() if client.focus then client.focus.minimized = true end end,
			{ description = "Minimize", group = "Client keys" }
		},
		{
			{ env.mod }, "o", function ()
					if client.focus.floating
					then
					  client.focus.width = 950
					  client.focus.height = 600
					  client.focus.x = 950
					  client.focus.y = 550
					end
				end,
			{ description = "Resize then move scratchpad to right bottom", group = "Client keys" }
		},
		{
			{ env.mod }, "i", function ()
					if client.focus.floating
					then
					  client.focus.width = 950
					  client.focus.height = 600
					  client.focus.x = 10
					  client.focus.y = 550
					end
				end,
			{ description = "Resize then move scratchpad to left bottom", group = "Client keys" }
		},
		{
			{ env.mod, "Shift" }, "f", function() redflat.float.control:show() end,
			{ description = "[Hold] Floating window control mode", group = "Window control" }
		},

	}

	self.keys.root = redflat.util.key.build(self.raw.root)
	self.keys.client = redflat.util.key.build(self.raw.client)

    -------------------------------------------------------------------
	-- grid layout keys
	local layout_grid_move = {
		{
			{ env.mod }, "KP_Up", function() grid.move_to("up") end,
			{ description = "Move window up", group = "Movement" }
		},
		{
			{ env.mod }, "KP_Down", function() grid.move_to("down") end,
			{ description = "Move window down", group = "Movement" }
		},
		{
			{ env.mod }, "KP_Left", function() grid.move_to("left") end,
			{ description = "Move window left", group = "Movement" }
		},
		{
			{ env.mod }, "KP_right", function() grid.move_to("right") end,
			{ description = "Move window right", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Up", function() grid.move_to("up", true) end,
			{ description = "Move window up by bound", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Down", function() grid.move_to("down", true) end,
			{ description = "Move window down by bound", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Left", function() grid.move_to("left", true) end,
			{ description = "Move window left by bound", group = "Movement" }
		},
		{
			{ env.mod, "Control" }, "KP_Right", function() grid.move_to("right", true) end,
			{ description = "Move window right by bound", group = "Movement" }
		},
	}

	local layout_grid_resize = {
		{
			{ env.mod }, "k", function() grid.resize_to("up") end,
			{ description = "Inrease window size to the up", group = "Resize" }
		},
		{
			{ env.mod }, "j", function() grid.resize_to("down") end,
			{ description = "Inrease window size to the down", group = "Resize" }
		},
		{
			{ env.mod }, "h", function() grid.resize_to("left") end,
			{ description = "Inrease window size to the left", group = "Resize" }
		},
		{
			{ env.mod }, "l", function() grid.resize_to("right") end,
			{ description = "Inrease window size to the right", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "k", function() grid.resize_to("up", nil, true) end,
			{ description = "Decrease window size from the up", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "j", function() grid.resize_to("down", nil, true) end,
			{ description = "Decrease window size from the down", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "h", function() grid.resize_to("left", nil, true) end,
			{ description = "Decrease window size from the left", group = "Resize" }
		},
		{
			{ env.mod, "Shift" }, "l", function() grid.resize_to("right", nil, true) end,
			{ description = "Decrease window size from the right", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "k", function() grid.resize_to("up", true) end,
			{ description = "Increase window size to the up by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "j", function() grid.resize_to("down", true) end,
			{ description = "Increase window size to the down by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "h", function() grid.resize_to("left", true) end,
			{ description = "Increase window size to the left by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control" }, "l", function() grid.resize_to("right", true) end,
			{ description = "Increase window size to the right by bound", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "k", function() grid.resize_to("up", true, true) end,
			{ description = "Decrease window size from the up by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "j", function() grid.resize_to("down", true, true) end,
			{ description = "Decrease window size from the down by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "h", function() grid.resize_to("left", true, true) end,
			{ description = "Decrease window size from the left by bound ", group = "Resize" }
		},
		{
			{ env.mod, "Control", "Shift" }, "l", function() grid.resize_to("right", true, true) end,
			{ description = "Decrease window size from the right by bound ", group = "Resize" }
		},
	}

	redflat.layout.grid:set_keys(layout_grid_move, "move")
	redflat.layout.grid:set_keys(layout_grid_resize, "resize")

	-- Numkeys
	--------------------------------------------------------------------------------

	-- add real keys without description here
	for i = 1, 9 do
		self.keys.root = awful.util.table.join(
			self.keys.root,
			tag_numkey(i,    { env.mod },                     function(t) t:view_only()               end),
			tag_numkey(i,    { env.mod, "Control" },          function(t) awful.tag.viewtoggle(t)     end),
			client_numkey(i, { env.mod, "Shift" },            function(t) client.focus:move_to_tag(t) end),
			client_numkey(i, { env.mod, "Control", "Shift" }, function(t) client.focus:toggle_tag(t)  end)
		)
	end

	-- make fake keys with description special for key helper widget
	local numkeys = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

	self.fake.numkeys = {
		{
			{ env.mod }, "1..9", nil,
			{ description = "Switch to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control" }, "1..9", nil,
			{ description = "Toggle tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Shift" }, "1..9", nil,
			{ description = "Move focused client to tag", group = "Numeric keys", keyset = numkeys }
		},
		{
			{ env.mod, "Control", "Shift" }, "1..9", nil,
			{ description = "Toggle focused client on tag", group = "Numeric keys", keyset = numkeys }
		},
	}

	-- Hotkeys helper setup
	--------------------------------------------------------------------------------
	redflat.float.hotkeys:set_pack("Main", awful.util.table.join(self.raw.root, self.raw.client, self.fake.numkeys), 2)

	-- Mouse buttons
	--------------------------------------------------------------------------------
	self.mouse.client = awful.util.table.join(
		awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ env.mod }, 1, awful.mouse.client.move),
		awful.button({ env.mod }, 3, awful.mouse.client.resize)
	)

	-- Set root hotkeys
	--------------------------------------------------------------------------------
	root.keys(self.keys.root)
	root.buttons(self.mouse.root)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys

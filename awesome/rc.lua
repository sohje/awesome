-- Awesome 3.4 configuration file
-- Made by Omi <e1337.jp [at] gmail.com>
-- Happy living ;]

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- vicious library 
-- by Omi date: fri Oct 30
require("vicious")
require("wicked")

-- Sound Control
--require("volume")
--


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/ai/.config/awesome/themes/blue/theme.lua")

-- widgets
-- load after initialize theme
require("omi")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

local home   = os.getenv("HOME")
local exec   = awful.util.spawn

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "main", "web", "code", "etc", "media" }, s)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }

}

myinternet = {
   { "Skype", "skype" },
   { "Firefox", "firefox" },
   { "Chrome", "chromium-browser" },
   { "Chrome-Pr", "chromium-browser -incognito" },
   { "Transmission", "transmission-gtk" },
   { "Thunderbird", "thunderbird" }
}

mygraphics = {
   { "Gimp", "gimp" }
}

mymedia = {
    { "Webcam", "wxcam" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { " ", nil, nil}, -- separator
                                    {"graphics", mygraphics },
                                    {"internet", myinternet },
                                    {"media", mymedia },
                                    { " ", nil, nil}, -- separator
                                    { "terminal", terminal },
                                    {"editor", "sublime_text" },
                                    { "filemanager", "nautilus" },
                                    { "Lock screen", "xlock" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)


    -- Test widgets
    	mytest = widget({ type="textbox", name = "mytest" })
    	mytest.text = " | "
	
    -- Text wi
        mysp = widget({ type="textbox", name = "mysp" })
        mysp.text = " ["

    -- Text wi1
        mysp1 = widget({ type="textbox", name = "mysp1" })
        mysp1.text = "] "

    -- CPU Icon
        cpuicone = widget({ type = "imagebox" })
        cpuicone.image = image(beautiful.widget_cpu)

    -- CPU Widget
        cpubar = awful.widget.progressbar()
        cpubar:set_width(50)
        cpubar:set_height(6)
        cpubar:set_vertical(false)
        cpubar:set_background_color("#434343")
        cpubar:set_gradient_colors({ beautiful.fg_normal, beautiful.fg_normal, beautiful.fg_normal, beautiful.bar })
        vicious.register(cpubar, vicious.widgets.cpu, "$1", 3)
        awful.widget.layout.margins[cpubar.widget] = { top = 5 }

    -- Cpu usage
        cpuwidget = widget({ type = "textbox" })
        vicious.register( cpuwidget, vicious.widgets.cpu, "$2% $3%", 3)

        cpuicon:buttons(awful.util.table.join(
            awful.button({ }, 1, function () awful.util.spawn("urxvtc -e htop", false) end)
            ))

        -- MEM icon
            memicone = widget ({type = "imagebox" })
            memicone.image = image(beautiful.widget_mem)
        -- Initialize MEMBar widget
            membar = awful.widget.progressbar()
            membar:set_width(50)
            membar:set_height(6)
            membar:set_vertical(false)
            membar:set_background_color("#434343")
            membar:set_border_color(nil)
            membar:set_gradient_colors({ beautiful.fg_normal, beautiful.fg_normal, beautiful.fg_normal, beautiful.bar })
            awful.widget.layout.margins[membar.widget] = { top = 5 }
            vicious.register(membar, vicious.widgets.mem, "$1", 1)

        -- Memory usage
            memwidget = widget({ type = "textbox" })
            vicious.register(memwidget, vicious.widgets.mem, "$2M", 1)

            memicon:buttons(awful.util.table.join(
                awful.button({ }, 1, function () awful.util.spawn("urxvtc -e saidar -c", false) end)
            ))

    -- Vol Icon
        volicon = widget ({type = "imagebox" })
        volicon.image = image(beautiful.widget_vol)

    -- Vol bar Widget
        volbar = awful.widget.progressbar()
        volbar:set_width(50)
        volbar:set_height(6)
        volbar:set_vertical(false)
        volbar:set_background_color("#434343")
        volbar:set_border_color(nil)
        volbar:set_gradient_colors({ beautiful.fg_normal, beautiful.fg_normal, beautiful.fg_normal, beautiful.bar })
        awful.widget.layout.margins[volbar.widget] = { top = 5 }
        vicious.register(volbar, vicious.widgets.volume,  "$1",  1, "Master")


    -- Sound volume
        volumewidget = widget ({ type = "textbox" })
        vicious.register( volumewidget, vicious.widgets.volume, "$1", 1, "Master" )

        volicon:buttons(awful.util.table.join(
            awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end)
        --awful.button({ }, 3, function () awful.util.spawn("urxvt -e alsamixer", true) end),
        --awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
        --awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
        ))

        volumewidget:buttons(awful.util.table.join(
            awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end)
        --awful.button({ }, 3, function () awful.util.spawn("urxvt -e alsamixer", true) end),
        --awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
        --awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
        ))


	-- Battery widget
	-- Omi October 30 2009
    	local mybaticon = widget({ type = "imagebox" })
    	mybaticon.image = image("/home/ai/.config/awesome/icons/bat.png")

        local batwidget = widget({ type = "textbox", name = "batwidget" })
        vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0" )

    -- Volume widget
    -- Omi December 30 2011 (fucking army) gmicon,
	--local volicon = widget({ type = "imagebox", name = "volicon" })
    --    volicon.image = image("/home/ai/.config/awesome/icons/vol.png")

    --    tb_volume = widget({ type = "textbox", name = "tb_volume", align = "right" })
    --    tb_volume:buttons(awful.util.table.join(
	--	     awful.button({ }, 1, function () volume("mute", tb_volume) end),
	--	     awful.button({ }, 3, function () exec("pavucontrol") end),
	--	     awful.button({ }, 4, function () volume("up", tb_volume) end),
	--	     awful.button({ }, 5, function () volume("down", tb_volume) end)
	--     ))

    -- Date icon
    -- Omi April 17 2010 
	    local dateicon = widget({ type = "imagebox", name = "dateicon" })
        dateicon.image = image("/home/ai/.config/awesome/icons/time.png")
    -- pylendar 30 december 2011 (fucking army) T_T
        mytextclock:buttons(awful.util.table.join(
		      awful.button({ }, 1, function () exec(home.."/.config/awesome/calendarpy.py") end)
		))
    
    -- Gmail widget
    -- Jan 21 2012
        local gmicon = widget({ type = "imagebox", name = "gmicon" })
        gmicon.image = image("/home/ai/.config/awesome/icons/mail.png")

        gmailwidget = widget({ type = "textbox" })
        --Register widget
        vicious.register(gmailwidget, vicious.widgets.gmail, "GMail: ${count} ${subject}", 60)

    -- Add widgets to the wibox - order matters
    -- Create the wibox
        mywibox[s] = awful.wibox({ position = "top", screen = s })
    	mywibox[s].widgets = {
        {
        -- mylauncher,
            mytaglist[s], myspace,  
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        -- mylayoutbox[s],
        mytextclock, dateicon, mytest,
	batwidget, mybaticon, mytest, 
	mytasklist[s],
	--s == 1 and mysystray or nil,
	layout = awful.widget.layout.horizontal.rightleft
    	}

	mywibox[s] = awful.wibox({ position = "bottom", height = 14, screen = s })
	mywibox[s].widgets = {
		mylauncher, myspace, myspace, myspace,
            	mysp, cpuicone, cpubar, spacer, spacer, cputherm, spacer, mysp1, tab,
		        mysp, memicone, membar, spacer, memwidget, spacer, mysp1, tab,
                mysp, volicon, volbar, spacer, volumewidget, mysp1, tab,
		upicon, txwidget, spacer, upgraph, upwidget, tab,
		downicon, rxwidget, spacer, downgraph, downwidget, tab,
        	layout = awful.widget.layout.horizontal.leftright,
        {
            s == 1 and mysystray or nil, --tb_volume, volicon, mytest, gmailwidget, gmicon,
            layout = awful.widget.layout.horizontal.rightleft
        }
  }	
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
os.execute("xbindkeys")
os.execute("xrdb -merge /home/ai/.Xdefaults")
-- c.size_hints_honor = false

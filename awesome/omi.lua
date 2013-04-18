--------------------
-- Omi's config  ---
-- awesome 3.4.3 ---
-- ai [at]      ---
--------------------

-- Libraries
require("wicked")
require("vicious")
require("awful")
require("beautiful")

-- Widgets

-- {{{ Spacers
spacer = widget({ type = "textbox" })
spacer.text = " "

tab = widget({ type = "textbox" })
tab.text = "	"
-- }}}


-- {{{ PROCESSOR
-- icon
cpuicon = widget({ type = "imagebox"})
cpuicon.image = image("/home/ai/.config/awesome/icons/cpu.png")

-- cpu0 info
cpuinfo = widget({ type = "textbox" })
vicious.register(cpuinfo, vicious.widgets.cpuinf, "${cpu0 ghz}GHz")

-- cpu0 graph
cpugraph = awful.widget.graph()
cpugraph:set_width(40)
cpugraph:set_height(12)
cpugraph:set_background_color(beautiful.bg_widget)
cpugraph:set_border_color(beautiful.bg_widget)
cpugraph:set_gradient_colors({ beautiful.fg_widget, beautiful.bg_widget })
cpugraph:set_gradient_angle(180)
vicious.register(cpugraph, vicious.widgets.cpu, "$1")

-- cpu0 %
cpupct = widget({ type = "textbox" })
vicious.register(cpupct, vicious.widgets.cpu, "$1%", 2)

-- therm cpu
cputherm = widget({ type = "textbox", name = "cputherm" })
vicious.register(cputherm, vicious.widgets.thermal, "$1°C", 9, "temp")

-- }}}


-- {{{ MEMORY
-- icon 
memicon = widget({ type = "imagebox", name = "memicon"})
memicon.image = image("/home/ai/.config/awesome/icons/mem.png")

-- used
memused = widget({ type = "textbox" })
vicious.register(memused, wicked.widgets.mem, "$2MB", 5)

-- bar
membar = awful.widget.progressbar()
membar:set_width(40)
membar:set_height(12)
membar:set_border_color(beautiful.bg_widget)
membar:set_background_color(beautiful.bg_widget)
membar:set_gradient_colors({ beautiful.fg_widget, beautiful.bg_widget })
vicious.register(membar, vicious.widgets.mem, "$1", 5)

-- %
mempct = widget({ type = "textbox" })
vicious.register(mempct, wicked.widgets.mem, "$1%", 5)

-- }}}

-- {{{ NETWORK
-- tx icon
upicon = widget({ type = "imagebox"})
upicon.image = image("/home/ai/.config/awesome/icons/up.png")

-- tx
txwidget = widget({ type = "textbox" })
vicious.register(txwidget, vicious.widgets.net, "${eth0 tx_mb}MB", 15)

-- up graph
upgraph = awful.widget.graph()
upgraph:set_width(40)
upgraph:set_height(12)
upgraph:set_background_color(beautiful.bg_widget)
upgraph:set_border_color(beautiful.bg_widget)
upgraph:set_gradient_colors({ beautiful.fg_widget, beautiful.bg_widget })
upgraph:set_gradient_angle(180)
vicious.register(upgraph, vicious.widgets.net, "${eth0 up_kb}")

-- up speed
upwidget = widget({ type = "textbox" })
wicked.register(upwidget, wicked.widgets.net, "${eth0 up_kb}k/s", 2)

-- rx icon
downicon = widget({ type = "imagebox"})
downicon.image = image("/home/ai/.config/awesome/icons/down.png")

-- rx
rxwidget = widget({ type = "textbox" })
vicious.register(rxwidget, vicious.widgets.net, "${eth0 rx_mb}MB", 15)

-- down graph
downgraph = awful.widget.graph()
downgraph:set_width(40)
downgraph:set_height(12)
downgraph:set_background_color(beautiful.bg_widget)
downgraph:set_border_color(beautiful.bg_widget)
downgraph:set_gradient_colors({ beautiful.fg_widget, beautiful.bg_widget })
downgraph:set_gradient_angle(180)
vicious.register(downgraph, vicious.widgets.net, "${eth0 down_kb}")

-- down speed
downwidget = widget({ type = "textbox" })
wicked.register(downwidget, wicked.widgets.net, "${eth0 down_kb}k/s", 2)

-- }}}


-- {{{ WEATHER
weatherwidget = widget({ type = "textbox" })
vicious.register(weatherwidget, vicious.widgets.weather, "<span color='#d6d6d6'>${sky}</span> @ ${tempf}°F on", 1200, "KOUN")

function get_forecast(mode)
    local s, cutoff
    if mode == "quick" then
        s = " | sed 's/Tomorrow Night/.../'"
        cutoff = "/Tomorrow Night/"
    elseif mode == "full" then
        s = ""
        cutoff = 38
    end

    local fp = io.popen("sed -n '1," .. cutoff .. "p' /tmp/weather" .. s)
    local forecast = fp:read("*a")
    fp:close()

    return forecast
end

-- buttons
weatherwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function ()
        naughty.notify { text = get_forecast("quick"), timeout = 5, hover_timeout = 0.5 }
    end),
    awful.button({ }, 2, function ()
        awful.util.spawn(browser .. " http://www.accuweather.com/us/ok/norman/73071/city-weather-forecast.asp?partner=accuweather&u=1&traveler=0", false)
        awful.tag.viewonly(tags[1][2])
    end),
    awful.button({ }, 3, function ()
        naughty.notify { text = get_forecast("full"), timeout = 10, hover_timeout = 0.5 }
    end)))

-- }}}

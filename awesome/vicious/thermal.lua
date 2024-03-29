---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
---------------------------------------------------

-- {{{ Grab environment
local type = type
local tonumber = tonumber
local setmetatable = setmetatable
local string = { match = string.match }
local helpers = require("vicious.helpers")
-- }}}


-- Thermal: provides temperature levels of ACPI and coretemp thermal zones
module("vicious.widgets.thermal")


-- {{{ Thermal widget type
local function worker(format, warg)
    if not warg then return end

    local zone = { -- Known temperature data sources
        ["sys"]  = {"/sys/class/thermal/",     file = "temp",       div = 1000},
        ["core"] = {"/sys/devices/platform/coretemp.0/",  file = "temp2_input",div = 1000},
        ["proc"] = {"/proc/acpi/thermal_zone/",file = "temperature"}
    } --  Default to /sys/class/thermal
    warg = type(warg) == "table" and warg or { warg, "core" }

    -- Get temperature from thermal zone
    local thermal = helpers.pathtotable(zone[warg[2]][1] .. warg[1])

    local data = warg[3] and thermal[warg[3]] or thermal[zone[warg[2]].file]
    if data then
        if zone[warg[2]].div then
            return {data / zone[warg[2]].div}
        else -- /proc/acpi "temperature: N C"
            return {tonumber(string.match(data, "[%d]+"))}
        end
    end

    return {0}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })

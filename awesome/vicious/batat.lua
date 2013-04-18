---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2009, Adrian C. <anrxc.sysphere.org>
---------------------------------------------------

-- {{{ Grab environment
local io = { popen = io.popen }
local setmetatable = setmetatable
local table = { insert = table.insert }
local string = { match = string.match }
-- }}}


-- Batat: provides state, charge, and remaining time for all batteries using acpitool
module("vicious.batat")


-- {{{ Battery widget type
local function worker(format)
    local battery_info  = {}
    local battery_state = {
        ["full"] = "↯",
        ["unknown"] = "⌁",
        ["charged"] = "↯",
        ["charging"] = "+",
        ["discharging"] = "-"
    }

    -- Get data from acpitool
    local f = io.popen("acpitool -b")

    for line in f:lines() do
        -- Check if the battery is present
        if string.match(line, "^[%s]+Battery.*") then
            -- Store state and charge information
            table.insert(battery_info, (battery_state[string.match(line, "([%a]*),")] or "/"))
            table.insert(battery_info, (string.match(line, "([%d]?[%d]?[%d])%.") or "/"))
            -- Store remaining time information
            table.insert(battery_info, (string.match(line, "%%,%s(.*)") or "/"))
        else
            return {"/", "/", "/"}
        end
    end
    f:close()

    return battery_info
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })

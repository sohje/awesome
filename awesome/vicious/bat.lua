---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2009, Adrian C. <anrxc.sysphere.org>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { open = io.open }
local setmetatable = setmetatable
local math = {
    min = math.min,
    floor = math.floor
}
local string = {
    find = string.find,
    match = string.match,
    format = string.format
}
-- }}}


-- Bat: provides state, charge, and remaining time for a requested battery
module("vicious.bat")


-- {{{ Battery widget type
local function worker(format, batid)
    local battery_state = {
        ["full"] = "↯",
        ["unknown"] = "⌁",
        ["charged"] = "↯",
        ["charging"] = "+",
        ["discharging"] = "-"
    }

    -- Get /proc/acpi/battery info
    --local f = io.open("/proc/acpi/battery/"..batid.."/info")
    -- Changed 28 oct 2011, cause kernel model of acpi devices was changed.
    local f = io.open("/sys/class/power_supply/"..batid.."/energy_full")
    -- Handler for incompetent users
    if not f then return {battery_state["unknown"], "0", "N/A"} end
    local infofile = f:read("*all")
    f:close()

    -- Check if the battery is present
    if infofile == nil or string.find(infofile, "[%s]+no") then
        return {battery_state["unknown"], "0", "N/A"}
    end

    -- Get capacity information
    --local capacity = string.match(infofile, "last full capacity:[%s]+([%d]+).*")
    local capacity = string.match(infofile, "([%d]+).*")


    -- Get /proc/acpi/battery state
    local f = io.open("/sys/class/power_supply/"..batid.."/energy_now")
    local statefile = f:read("*all")
    f:close()

    -- Get state information
    local state = string.match(statefile, "([%d]+).*")
    local state = battery_state[state] or battery_state["unknown"]

    -- Get charge information
    local rate = string.match(statefile, "([%d]+).*")
    local remaining = string.match(statefile, "([%d]+).*")


    -- Calculate percentage (but work around broken BAT/ACPI implementations)
    local percent = math.min(math.floor(remaining / capacity * 100), 100)

    -- Calculate remaining (charging or discharging) time
    if state == "+" then
        timeleft = (tonumber(capacity) - tonumber(remaining)) / tonumber(rate)
    elseif state == "-" then
        timeleft = tonumber(remaining) / tonumber(rate)
    else
        return {state, percent, "N/A"}
    end
    local hoursleft = math.floor(timeleft)
    local minutesleft = math.floor((timeleft - hoursleft) * 60 )
    local time = string.format("%02d:%02d", hoursleft, minutesleft)

    return {state, percent, time}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })

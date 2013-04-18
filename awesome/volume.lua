cardid = 0
channel = "Master"
function volume (mode, widget)
   if mode == "update" then
      local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
      local status = fd:read("*all")
      fd:close()

      local volume = string.match(status, "(%d?%d?%d)%%")
      volume = string.format("% 3d", volume)

      status = string.match(status, "%[(o[^%]]*)%]")

      if string.find(status, "on", 1, true) then
	 volume = "<span color='green'>" .. volume .. "</span>% "
      else
	 volume = "<span color='red'>" .. volume .. "</span>M "
      end
      widget.text = volume
   elseif mode == "up" then
      io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 2%+"):read("*all")
      volume("update", widget)
   elseif mode == "down" then
      io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 2%-"):read("*all")
      volume("update", widget)
   else
      io.popen("amixer -c " .. cardid .. " sset " .. channel .. " toggle"):read("*all")
      volume("update", widget)
   end
end

#!/usr/bin/env luajit

local sh = require 'sh'
local i3msg = sh.command 'i3-msg'
local MIN_WS, MAX_WS = 1, 9

function moveWorkspace(ws1, ws2)
  i3msg("'" ..
    'rename workspace ' .. ws1 .. ' to temporary; ' ..
    'rename workspace ' .. ws2 .. ' to ' .. ws1 .. '; ' ..
    'rename workspace temporary to ' .. ws2 ..
    "'")
end

function getCurrentWorkspace()
  local result =
    i3msg '-t get_workspaces'
    : jq "-r '.[] | select(.focused==true).name'"
  return tonumber(tostring(result))
end

function main()
  local direction = arg[1] or 'left'
  local ws1 = getCurrentWorkspace()
  local ws2 = direction == 'left' and (ws1 - 1) or (ws1 + 1)
  if(ws1 == ws2
      or ws1 > MAX_WS or ws2 > MAX_WS
      or ws1 < MIN_WS or ws2 < MIN_WS) then
    return
  end
  moveWorkspace(ws1, ws2)
end

main()

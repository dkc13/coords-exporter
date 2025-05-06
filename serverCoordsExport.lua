-- Coordinates Export System for HappinessMP
-- Created by: dkc13 | Discord: dkc13
-- GitHub: https://github.com/dkc13 | License: MIT License
-- 
-- Description:
-- This script allows players to save and export their coordinates in the game HappinessMP
-- (both in vehicles and on foot).
--
-- Contributions and modifications are welcome. If you want to contribute or report issues,
-- feel free to reach out on Discord or open an issue on GitHub.

local timestamp = true              -- Default is that timestamp is enabled
local path = "savedpositions.txt"   -- Define the file path (you can change it as needed)
local color = "{749154}"            -- Color code for chat messages

-- Function to get the current time in HH:MM:SS format
local function getCurrentTime()
    local time = os.date("*t")  -- Get current time
    return string.format("[%02d:%02d:%02d]", time.hour, time.min, time.sec)
end

-- Function to write coordinates to a file
Events.Subscribe("exportCoordinates", function (type, name, hash, coords)
    local serverId = Events.GetSource()

    local file = io.open(path, "a")  -- Open the file for appending
    if not file then
        Chat.SendMessage(serverId, color .. "Error opening the file!")
        return
    end

    -- Add timestamp if enabled
    local timePrefix = ""
    if timestamp then
        timePrefix = getCurrentTime() .. " "
    end

    -- Write coordinates based on type
    for _, k in ipairs(coords) do
        if type == 1 then  -- Vehicle
            file:write(timePrefix .. string.format("InCar(%s, 0x%X, %.2f, %.2f, %.2f, %.2f)\n", name, hash, k.x, k.y, k.z, k.a))
        elseif type == 2 then  -- Pedestrian
            file:write(timePrefix .. string.format("OnFoot(0x%X, %.2f, %.2f, %.2f, %.2f)\n", hash, k.x, k.y, k.z, k.a))
        end
    end

    file:close()
    Chat.SendMessage(serverId, color .. "Data successfully written to the file.")
end, true)

Events.Subscribe("updateTimeStamp", function ()
    local serverId = Events.GetSource()

    if timestamp == true then
        timestamp = false  -- Disable timestamp
        Chat.SendMessage(serverId, color .. "Timestamp disabled.")
    else
        timestamp = true  -- Enable timestamp
        Chat.SendMessage(serverId, color .. "Timestamp enabled.")
    end
end, true)

Events.Subscribe("updatePath", function (newPath)
    local serverId = Events.GetSource()

    if newPath and newPath ~= "" then
        path = newPath  -- Set the new path
        Chat.SendMessage(serverId, color .. "File path updated to: " .. path)
    else
        Chat.SendMessage(serverId, color .. "Invalid path specified.")
    end
end, true)

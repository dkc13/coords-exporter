-- Coordinates Export System for HappinessMP
-- Created by: dkc13 | Discord: dkc13
-- GitHub: https://github.com/dkc13 | License: MIT License
-- 
-- Description:
-- This script allows players to save and export their coordinates in HappinessMP
-- (both in vehicles and on foot).
--
-- Contributions and modifications are welcome. If you want to contribute or report issues,
-- feel free to reach out on Discord or open an issue on GitHub.

-- CES -> Coordinates Export System
local configFilePath = "CES/config.txt"     -- Path to the configuration file
local timestamp                             -- Variable for timestamp
local path                                  -- Variable for file path
local color = "{749154}"                    -- Color code for chat messages

-- Function to load configuration from the file
local function loadConfig(filePath)
    local file = io.open(filePath, "r")  -- Open the file for reading
    if not file then
        Console.Log("Error: CES config file is nout found!")
        return
    end

    -- Reading each line from the file
    for line in file:lines() do
        -- Trim leading and trailing whitespace
        line = line:match("^%s*(.-)%s*$")

        -- If the line is not empty, split it into key and value
        if line ~= "" then
            local key, value = line:match("^(%w+)%s*=%s*(.+)$")
            if key and value then
                -- Set values to the corresponding variables
                if key == "timestamp" then
                    timestamp = (value == "true")  -- Convert to boolean
                elseif key == "path" then
                    path = value
                end
            end
        end
    end

    file:close()  -- Close the file
end

-- Function to save the configuration to the file
local function saveConfig(filePath)
    local file = io.open(filePath, "w")  -- Open the file for writing (overwrite mode)
    if not file then
        print("Error: CES config file is not found!")
        return
    end

    -- Write the timestamp and path to the file
    if timestamp ~= nil then
        file:write("timestamp=" .. tostring(timestamp) .. "\n")
    end
    if path ~= nil then
        file:write("path=" .. path .. "\n")
    end

    file:close()  -- Close the file
end

-- Collecting data from the file on resource start
Events.Subscribe("resourceStart", function()
    loadConfig(configFilePath)  -- Load the configuration when the resource starts
end)

-- Saving data to the file on resource stop
Events.Subscribe("resourceStop", function()
    saveConfig(configFilePath)  -- Save the configuration when the resource stops
end)

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
        Chat.SendMessage(serverId, color .. "Error: Export file is not found, change the path (/save path)!")
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
        path = "CES/" .. newPath .. ".txt" -- Set the new path
        Chat.SendMessage(serverId, color .. "File path updated to: " .. path)
    else
        Chat.SendMessage(serverId, color .. "Invalid path specified.")
    end
end, true)
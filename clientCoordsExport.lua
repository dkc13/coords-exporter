local color = "{749154}" -- Color code for chat messages

-- Function to get the player's coordinates
local function getPlayerCoordinates()
    local playerId = Game.GetPlayerId()
    local playerChar = Game.GetPlayerChar(playerId)

    if Game.IsCharInAnyCar(playerChar) then
        local currentCar = Game.GetCarCharIsUsing(playerChar)
        local x, y, z = Game.GetCarCoordinates(currentCar)
        local a = Game.GetCarHeading(currentCar)

        local coords = {
            {x = x, y = y, z = z, a = a}
        }

        local vehicleHash = Game.GetCarModel(currentCar)
        local vehicleName = Game.GetDisplayNameFromVehicleModel(vehicleHash)

        -- Call event for vehicle
        Events.CallRemote("exportCoordinates", {1, vehicleName, vehicleHash, coords})
    else
        local x, y, z = Game.GetCharCoordinates(playerChar)
        local a = Game.GetCharHeading(playerChar)

        local coords = {
            {x = x, y = y, z = z, a = a}
        }

        local pedHash = Game.GetCharModel(playerChar)

        -- Call event for pedestrian
        Events.CallRemote("exportCoordinates", {2, nil, pedHash, coords})
    end
end

local function printCurrentCoordinates()
    local playerId = Game.GetPlayerId()
    local playerChar = Game.GetPlayerChar(playerId)

    if Game.IsCharInAnyCar(playerChar) then
        local currentCar = Game.GetCarCharIsUsing(playerChar)
        local x, y, z = Game.GetCarCoordinates(currentCar)
        local a = Game.GetCarHeading(currentCar)

        Chat.AddMessage(color .. x .. ", " .. y .. ", " .. z .. ", " .. a) -- Prints current on foot coordinates
    else
        local x, y, z = Game.GetCharCoordinates(playerChar)
        local a = Game.GetCharHeading(playerChar)
        Chat.AddMessage(color .. x .. ", " .. y .. ", " .. z .. ", " .. a) -- Prints current on foot coordinates
    end
end

-- Helper function to split a string by a separator
local function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"  -- Default separator is a space
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- Chat command to handle timestamp, path, saving coordinates and printing current coordinates
Events.Subscribe("chatCommand", function(fullcommand)
    local command = stringsplit(string.lower(fullcommand), ' ')  -- Split the command
    if command[1] == "/save" then
        if command[2] == "timestamp" then
            Events.CallRemote("updateTimeStamp", {})  -- Updates timestamp
        elseif command[2] == "path" then
            if command[3] == nil or command[3] == "" then  -- If path is empty or nil
                Chat.AddMessage(color .. "You must specify a valid file path.")
            else
                Events.CallRemote("updatePath", {command[3]})  -- Set a new file path
            end  
        elseif command[2] == "help" then
            Chat.AddMessage(color .. "-- Coordinates Export ---------------------------------------------")
            Chat.AddMessage(color .. "/save                         -> Save coordinates to file.")
            Chat.AddMessage(color .. "/save timestamp               -> Enable/Disable timestamp.")
            Chat.AddMessage(color .. "/save path [path_name.txt]    -> Change the export path.")
            Chat.AddMessage(color .. "/save help                    -> Display all commands.")
            Chat.AddMessage(color .. "----------------------------------------------------------------------------")        
        else
            getPlayerCoordinates()  -- Call the function to save coordinates
        end
    elseif command[1] == "/mypos" then
        printCurrentCoordinates()
    end
end)
print('')
print("\27[91m   _____ _        _       _                 _____                _ ")
print("\27[91m  / ____| |      | |     | |       ___     / ____|              | |")
print("\27[91m | (___ | | _____| |_ ___| |__    ( _ )   | (___   ___ _ __   __| |")
print("\27[91m  \\___ \\| |/ / _ \\ __/ __| '_ \\   / _ \\/\\  \\___ \\ / _ \\ '_ \\ / _` |")
print("\27[91m  ____) |   <  __/ || (__| | | | | (_>  <  ____) |  __/ | | | (_| |")
print("\27[91m |_____/|_|\\_\\___|\\__\\___|_| |_| _\\___/\\/ |_____/ \\___|_| |_|\\__,_|")
print("\27[94m | |                          (_|_)   | |         | |              ")
print("\27[94m | |__  _   _    __ _ ___  ___ _ _  __| |_   _  __| | ___          ")
print("\27[94m | '_ \\| | | |  / _` / __|/ __| | |/ _` | | | |/ _` |/ _ \\         ")
print("\27[94m | |_) | |_| | | (_| \\__ \\ (__| | | (_| | |_| | (_| |  __/         ")
print("\27[94m |_.__/ \\__, |  \\__,_|___/\\___|_|_|\\__,_|\\__,_|\\__,_|\\___|         ")
print("\27[94m         __/ |                                                     ")
print("\27[94m        |___/                                                      ")
print('')

--[[
    DISCORD REFERENCES

    sendMessage
    sendMessage(ID, Content)

    sendEmbed
    local embedFields = {
        { name = "Field 1", value = "Value 1" },
        { name = "Field 2", value = "Value 2" }
    }
    sendEmbed(ID, Title, Description, Color, embedFields)
]]--


-- Command handling

RegisterCommand(Config.sketchCommand, function(source, args, rawCommand)
    if Config.limitACE_Sketch then
        if IsAceAllowed(source, 'sketchnsend.' .. Config.sketchPermission) then
            TriggerClientEvent('SketchNSend:ShowSketchpad', source)
        end
    else
        TriggerClientEvent('SketchNSend:ShowSketchpad', source)
    end
end)

-- Event Handling

-- Save Sketch & Send Request
-- Limits viewing sketches made by players, including requests being made to those players
RegisterNetEvent('SketchNSend:SaveSketch')
AddEventHandler('SketchNSend:SaveSketch', function(source, data)
    function saveSketch_fn(success, url)
        if success then
            local eventData = {
                senderId = source,
                requestId = data.requestId,
                url = url,
                timeout = os.time() + Config.requestTimeout
            }

            if Config.limitACE_View then
                if IsAceAllowed(data.requestId, 'sketchnsend.' .. Config.viewPermission) then
                    TriggerClientEvent('SketchNSend:RequestChange', data.requestId, eventData)
                    print('New sketch request from ' .. GetPlayerName(source) .. ' (Server #' .. source .. ')' .. ' to ' .. GetPlayerName(data.requestId) .. ' (Server #' .. source .. ')')
                end
            else
                TriggerClientEvent('SketchNSend:RequestChange', data.requestId, eventData)
                print('New sketch request from ' .. GetPlayerName(source) .. ' (Server #' .. source .. ')' .. ' to ' .. GetPlayerName(data.requestId) .. ' (Server #' .. source .. ')')
            end
        else
            print('An error has occured when uploading image to ImgBB. Do you have an API key configured?')
        end
    end

    if Config.limitACE_Sketch then
        if IsAceAllowed(source, 'sketchnsend.' .. Config.sketchPermission) then
            saveSketch(data.image, saveSketch_fn)
        else
            print('Player ID: ' .. tostring(source) .. ' does not have permission to save sketches.')
        end
    else
        saveSketch(data.image, saveSketch_fn)
    end
end)

RegisterNetEvent('SketchNSend:CheckTimeout')
AddEventHandler('SketchNSend:CheckTimeout', function(clientTimeout)
    TriggerClientEvent('SketchNSend:HandleTimeout', source, os.time(), clientTimeout)
end)

RegisterNetEvent('SketchNSend:GetPlayerData_View')
AddEventHandler('SketchNSend:GetPlayerData_View', function(senderId, url)
    local playerInfo = {
        senderName = GetPlayerName(senderId),
        senderId = senderId
    }

    TriggerClientEvent('SketchNSend:PlayerDataReceived_View', senderId, playerInfo, url)
end)

RegisterNetEvent('SketchNSend:GetPlayerList')
AddEventHandler('SketchNSend:GetPlayerList', function()
    local players = {}
    for _, id in ipairs(GetPlayers()) do
        table.insert(players, {
            id = id,
            name = GetPlayerName(id)
        })
    end

    TriggerClientEvent('SketchNSend:RecievePlayerList', source, players)
end)

RegisterNetEvent('SketchNSend:RequestResponse')
AddEventHandler('SketchNSend:RequestResponse', function(senderId, accepted)
    if accepted then
        TriggerClientEvent('chat:addMessage',
            senderId,
            {
                color = { 0, 255, 0 },
                multiline = true,
                args = { '[SketchNSend]', string.format('Your sketch view request was accepted.') }
            }
        )
    else
        TriggerClientEvent('chat:addMessage',
            senderId,
            {
                color = { 255, 0, 0 },
                multiline = true,
                args = { '[SketchNSend]', string.format('Your sketch view request was denied.') }
            }
        )
    end
end)

RegisterNetEvent('SketchNSend:LogToDiscord')
AddEventHandler('SketchNSend:LogToDiscord', function(url, senderId, requestId)
    local senderName = GetPlayerName(senderId)
    local identifiers = GetPlayerIdentifiers(senderId)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S', os.time())

    local formattedIdentifiers = {}
    for _, id in ipairs(identifiers) do
        table.insert(formattedIdentifiers, '* ' .. id)
    end

    local identifiersString = table.concat(formattedIdentifiers, '\n')

    local requestName = GetPlayerName(requestId)

    local embedFields = {
        { name = "From", value = senderName .. '(Server #' .. senderId .. ')', inline = true },
        { name = "To", value = requestName .. '(Server #' .. requestId .. ')', inline = true },
        { name = "Sender Identifiers", value = identifiersString, inline = false }
    }

    sendEmbed(Config.discordChannelId, "Sketch Request", "A new sketch request has been logged.", 3447003, embedFields, url)
end)
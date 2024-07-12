-- NUI Handling

-- Register NUI Callbacks
RegisterNUICallback("closeSketchpad_View", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("closeSketchpad", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("getPlayerList", function(data, cb)
    TriggerServerEvent('SketchNSend:GetPlayerList')
    cb("ok")
end)

-- Event Handling
RegisterNetEvent('SketchNSend:ShowSketchpad')
AddEventHandler('SketchNSend:ShowSketchpad', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openSketchpad"
    })
end)

RegisterNetEvent('SketchNSend:ShowSketchpad_View')
AddEventHandler('SketchNSend:ShowSketchpad_View', function(url, senderId)
    TriggerServerEvent('SketchNSend:GetPlayerData_View', senderId, url)
end)

RegisterNetEvent('SketchNSend:RecievePlayerList')
AddEventHandler('SketchNSend:RecievePlayerList', function(players)
    SendNUIMessage({
        type = "playerList",
        players = players
    })
end)

-- Handling the response from the server
RegisterNetEvent('SketchNSend:PlayerDataReceived_View')
AddEventHandler('SketchNSend:PlayerDataReceived_View', function(playerData, url)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openSketchpad_View",
        url = url,
        playerData = playerData
    })
end)


-- Save and Send Sketches

local currentRequest

RegisterNUICallback('saveSketch', function(data, cb)
    TriggerServerEvent('SketchNSend:SaveSketch', GetPlayerServerId(PlayerId()), data)
    cb('closeSketchpad')
end)

RegisterNetEvent('SketchNSend:RequestChange')
AddEventHandler('SketchNSend:RequestChange', function(requestData)
    currentRequest = requestData

    TriggerEvent('chat:addMessage', {
        color = { 0, 255, 0 },
        multiline = true,
        args = { '[SketchNSend]', string.format('You have a new request! Press %s or %s to accept or deny this request.', Config.acceptRequest, Config.denyRequest) }
    })

    -- Log to discord
    if Config.useDiscord then
        TriggerServerEvent('SketchNSend:LogToDiscord', requestData.url, requestData.senderId, requestData.requestId)
    end
end)

-- Request Handling

-- Acceptance & denial
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentRequest then
            if getKeyPressed(Config.acceptRequest) then
                print('Accepted sketch request, sketch made by server user ID #' .. currentRequest.senderId)

                TriggerEvent('SketchNSend:ShowSketchpad_View', currentRequest.url, currentRequest.senderId)
                TriggerServerEvent('SketchNSend:RequestResponse', currentRequest.senderId, true)

                TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0 },
                    multiline = true,
                    args = { '[SketchNSend]', string.format('You have accepted this sketch view request.') }
                })

                currentRequest = nil
            elseif getKeyPressed(Config.denyRequest) then
                TriggerServerEvent('SketchNSend:RequestResponse', currentRequest.senderId, false)

                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { '[SketchNSend]', string.format('You have denied this sketch view request.') }
                })

                currentRequest = nil
            end
        end
    end
end)

-- Periodically check for expired requests
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if currentRequest and currentRequest.timeout then
            TriggerServerEvent('SketchNSend:CheckTimeout', currentRequest.timeout)
        end
    end
end)

RegisterNetEvent('SketchNSend:HandleTimeout')
AddEventHandler('SketchNSend:HandleTimeout', function(currentTime, clientTimeout)
    if currentTime >= clientTimeout then
        currentRequest = nil
    end
end)

-- Remove request on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    currentRequest = nil
end)
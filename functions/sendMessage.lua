-- Send a message through Discord

function sendMessage(channelId, messageContent)
    local payload = {
        content = messageContent
    }
    PerformHttpRequest(Config.webhookURL, function(statusCode, responseData, headers)
        if statusCode ~= 204 then
            print('Failed to send message:', statusCode)
        end
    end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })
end
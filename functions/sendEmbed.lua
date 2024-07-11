-- Send an embed through Discord

function sendEmbed(channelId, embedTitle, embedDescription, embedColor, embedFields, imageUrl)
    local embed = {
        title = embedTitle,
        description = embedDescription,
        color = embedColor,
        fields = embedFields,
        image = { url = imageUrl },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")  -- ISO 8601 format for Discord
    }
    local payload = {
        embeds = { embed }
    }
    PerformHttpRequest(Config.webhookURL, function(statusCode, responseData, headers)
        if statusCode ~= 204 then
            print('Failed to send embed:', statusCode)
        end
    end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })
end

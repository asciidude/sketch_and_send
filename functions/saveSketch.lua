function saveSketch(imageData, cb)
    local apiKey = Config.imgbbApiKey
    local endpoint = "https://api.imgbb.com/1/upload"
    
    local headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local body = "key=" .. apiKey .. "&image=" .. urlEncode(imageData)
    
    PerformHttpRequest(endpoint, function(statusCode, response, headers)
        local data = json.decode(response)
        if statusCode == 200 and data and data.data and data.data.url then
            print("Image uploaded successfully. URL: " .. data.data.url)
            cb(true, data.data.url)
        else
            print("Failed to upload image to ImgBB. Status code: " .. statusCode)
            print("Response: " .. response)
            cb(false)
        end
    end, "POST", body, headers)
end

-- Helper function to encode image data to URL-safe format
function urlEncode(s)
    return s:gsub("[^%w]", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

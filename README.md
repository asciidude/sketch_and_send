# Sketch & Send
Sketch and Send is a highly-configurable FiveM plugin that allows users to communicate through sketching drawings and sending them to fellow members
with the option to use ACE permissions to enhance security.

Copyright © 2024 asciidude - All rights reservered, MIT license [(view more)](LICENSE)

## Prerequisites
- [imgbb API key](https://api.imgbb.com) - [Setup Guide](#ImgBB_Setup)

## Configuration
Everything is explained in the configuration file. If you have further inquiries, please contact me via the plugin page. GitHub is entirely for development
purposes and you will not recieve support if you try to contact me through here.

`config.lua` (change `config.CHANGEME.lua` to `config.lua`)
```lua
-- This plugin is licensed under MIT. More information in LICENSE.
-- Made with 💗 by asciidude.

-- Welcome to Sketch&Send!
-- This is the configuration file, please configure it according to your liking.

-- ⚠ Important ⚠ --
-- This plugin does __NOT__ detect NSFW or offensive art, use at your own discretion.
-- Also, reports are non-existent in this plugin due to the use of ticketing systems in so many Discord servers.
-- Recieving a sketch should give enough information to search for a sketch in logs.
-- ⚠ Important ⚠ --

Config = {}

Config.limitACE_Sketchpad = false -- Limits the creation of sketches
Config.limitACE_View = false -- Limits viewing sketches made by players, including requests being made to those players
Config.sketchCommand = "sketchpad" -- The command used to open the sketchpad

Config.requestTimeout = (5 * 60) -- In seconds, default 5 minutes

-- Ignore these accordingly to the configuration above.
-- Permission prefix: "sketchnsend."
Config.sketchPermission = "create" -- The command used to open the sketchpad
Config.viewPermission = "view" -- The command used to open the sketchpad

-- View possible keys in keylist.json
Config.acceptRequest = "E" -- Accept request to view sketch
Config.denyRequest = "R" -- Deny request to view sketch

-- This is used for sending images to other players and logging sketches.
-- Please ensure you have an imgbb API key and place it here.
Config.imgbbApiKey = "your_imgbb_api_key_here"

-- Discord Configuration -- This is so you can log and view any sketches made by players. Their FiveM identifier, in-game ID, and name are displayed in logs.

Config.useDiscord = false
Config.webhookURL = "your_webhook_url_here"
Config.discordChannel = 1252879334889230379
```

## ImgBB Setup
- Create an account with ImgBB
- Goto https://api.imgbb.com/
- Click "Get API key"
- Copy your API key into the value of `Config.imgbbApiKey`
- Go to your profile
- Set your profile to private (in case of NSFW content being drawn)

### ImgBB Note
ImgBB may rate limit you and return status code 400 if too many sketches are made at once, in that case please just wait patiently in order for everything to
return to normal. I highly recommend restricting sketches to certain ACE groups to avoid this.

## Additional Information
- This plugin is unable to detect content that is NSFW. Please use at your own discretion.
- If you have questions or concerns, contact me through the cfx.re plugin page.
- If you notice any bugs or plugin issues, please correct the code and create a PR or contact me through the cfx.re plugin page.
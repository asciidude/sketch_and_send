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

Config.limitACE_Sketchpad = true -- Limits creation of sketches
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
fx_version 'cerulean'
game 'gta5'

author 'asciidude'
description 'Sketch & Send'
version '1.0.0'

client_script 'client.lua'
server_script 'server.lua'

shared_scripts {
    'config.lua',
    'functions/**.*'
}

-- NUI --

ui_page 'nui/html/index.html'

files {
    'nui/**.*',
    'keylist.json'
}

lua54 'yes'
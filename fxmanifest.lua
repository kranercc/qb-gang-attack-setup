fx_version 'cerulean'
game 'gta5'
 
description 'Krane - GANG-ATTACK'
version '1.0.0'
 
lua54 'yes'
 
shared_script { 
    "CONFIG.lua"
}
 
client_scripts {
    'client/*.lua' -- Globbing method for multiple files
}
 
server_scripts {
    'server/*.lua' -- Globbing method for multiple files
}
 
ui_page 'html/ui.html'
 
files {
    'html/ui.html',
    'html/css/main.css',
    'html/js/*.js', -- Globbing also works here in case you have multiple js files
    'html/js/app.js'
}

escrow_ignore {
    "CONFIG.lua",
    "server/*",
    "client/*",
}
 
dependency 'qb-core'
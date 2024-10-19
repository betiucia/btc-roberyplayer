fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'btc_roberyplayer'
author 'Betiucia'
version '1.1'

shared_scripts {
    'config.lua',
    'locale/*.lua'
}


client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}


lua54 'yes'

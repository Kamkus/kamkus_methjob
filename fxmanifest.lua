fx_version 'adamant'

game 'gta5'

description 'Kamkus_Methjob'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua',
	'config.lua'
}

client_scripts {
	'client/main.lua',
	'config.lua'
}
ui_page "html/index.html"

files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css',
    'html/img.jpg',
    'html/notify.min.js'
}

dependency 'es_extended'


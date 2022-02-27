fx_version 'adamant'

game 'gta5'

description 'ESX Drugs remake by Rencikas'

version 'legacy'

shared_script '@es_extended/imports.lua'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/weed.lua'
}

dependencies {
	'es_extended',
	'nh-context',
	'nh-keyboard',
}

version '1.0'
author 'Kpri'
description 'kTrash'

escrow_ignore {
    
    "shared/*.lua"
}

server_scripts {

    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'

}


client_scripts {

    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/**/*.lua",
	'client/*.lua'

}


shared_script {

    "shared/*.lua"

}





lua54 'yes'
game 'gta5'
fx_version 'cerulean'
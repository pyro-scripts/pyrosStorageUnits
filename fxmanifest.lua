fx_version 'cerulean'
game 'gta5'
lua54 'on'

name 'pyrosStorageUnits'
author 'Pyro - the.pyro_'
description 'QBCore Storage Unit System'
verison '1.0.1'

shared_scripts { '@ox_lib/init.lua', 'config.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
client_scripts { 'client/*.lua' }

dependencies {
	'qb-core',
	'qb-target',
	'qb-inventory',
	'ox_lib'
}
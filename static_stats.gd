extends Node

enum ENT_STATS {HEALTH, MOVE_SPEED, SHIELD}
enum WEAPON_STATS {DAM, SPEED, RANGE, PELLET_COUNT, ACCURACY}


var player_modifiers = {
	ENT_STATS.HEALTH : 0,
	ENT_STATS.MOVE_SPEED : 0,
	ENT_STATS.SHIELD : 0,
	}

var enemy_modifiers = {
	ENT_STATS.HEALTH : 0,
	ENT_STATS.MOVE_SPEED : 0,
	ENT_STATS.SHIELD : 0,
	}

var weapon_modifiers = {
	WEAPON_STATS.DAM : 0,
	WEAPON_STATS.SPEED : 0,
	WEAPON_STATS.RANGE : 0,
	WEAPON_STATS.PELLET_COUNT : 0,
	WEAPON_STATS.ACCURACY : 0,
	}
	
func GetPlayerStatModifier(stat: ENT_STATS):
	if(player_modifiers.has(stat)):
		return player_modifiers[stat]
	else:
		print("didn't find that stat")

func GetEnemyStatModifier(stat: ENT_STATS):
	if(enemy_modifiers.has(stat)):
		return enemy_modifiers[stat]
	else:
		print("didn't find that stat")

func GetWeaponStatModifier(stat: WEAPON_STATS):
	if(weapon_modifiers.has(stat)):
		return weapon_modifiers[stat]
	else:
		print("didn't find that stat")
		
func SetPlayerStatModifier(stat: ENT_STATS, change):
	if(player_modifiers.has(stat)):
		player_modifiers[stat] = player_modifiers[stat] + change
	else:
		print("didn't find that stat")

func SetEnemyStatModifier(stat: ENT_STATS, change):
	if(enemy_modifiers.has(stat)):
		enemy_modifiers[stat] = enemy_modifiers[stat] + change
	else:
		print("didn't find that stat")

func SetWeaponStatModifier(stat: WEAPON_STATS, change):
	if(weapon_modifiers.has(stat)):
		weapon_modifiers[stat] = weapon_modifiers[stat] + change
	else:
		print("didn't find that stat")	

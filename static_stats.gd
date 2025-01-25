extends Node

enum ENT_STATS {HEALTH, MOVE_SPEED, SHIELD}
enum WEAPON_STATS {DAM, SPEED, RANGE, PELLET_COUNT, ACCURACY}

var initValAdd = 0

var player_modifiers = {
	ENT_STATS.HEALTH : initValAdd,
	ENT_STATS.MOVE_SPEED : initValAdd,
	ENT_STATS.SHIELD : initValAdd,
	}

var enemy_modifiers = {
	ENT_STATS.HEALTH : initValAdd,
	ENT_STATS.MOVE_SPEED : initValAdd,
	ENT_STATS.SHIELD : initValAdd,
	}

var player_weapon_modifiers = {
	WEAPON_STATS.DAM : initValAdd,
	WEAPON_STATS.SPEED : initValAdd,
	WEAPON_STATS.RANGE : initValAdd,
	WEAPON_STATS.PELLET_COUNT : initValAdd,
	WEAPON_STATS.ACCURACY : initValAdd,
	}
	
var enemy_weapon_modifiers = {
	WEAPON_STATS.DAM : initValAdd,
	WEAPON_STATS.SPEED : initValAdd,
	WEAPON_STATS.RANGE : initValAdd,
	WEAPON_STATS.PELLET_COUNT : initValAdd,
	WEAPON_STATS.ACCURACY : initValAdd,
	}
	
	#Entity Stats
func GetPlayerStatModifier(stat: ENT_STATS):
	if(player_modifiers.has(stat)):
		return player_modifiers[stat]
	else:
		print("didn't find that stat")

func SetPlayerStatModifier(stat: ENT_STATS, change):
	if(player_modifiers.has(stat)):
		player_modifiers[stat] = player_modifiers[stat] + change
	else:
		print("didn't find that stat")
		
func GetEnemyStatModifier(stat: ENT_STATS):
	if(enemy_modifiers.has(stat)):
		return enemy_modifiers[stat]
	else:
		print("didn't find that stat")

func SetEnemyStatModifier(stat: ENT_STATS, change):
	if(enemy_modifiers.has(stat)):
		enemy_modifiers[stat] = enemy_modifiers[stat] + change
	else:
		print("didn't find that stat")


#Weapon Stats
func GetPlayerWeaponStatModifier(stat: WEAPON_STATS):
	if(player_weapon_modifiers.has(stat)):
		return player_weapon_modifiers[stat]
	else:
		print("didn't find that stat")

func SetPlayerWeaponStatModifier(stat: WEAPON_STATS, change):
	if(player_weapon_modifiers.has(stat)):
		player_weapon_modifiers[stat] = player_weapon_modifiers[stat] + change
	else:
		print("didn't find that stat")	

func GetEnemyWeaponStatModifier(stat: WEAPON_STATS):
	if(enemy_weapon_modifiers.has(stat)):
		return enemy_weapon_modifiers[stat]
	else:
		print("didn't find that stat")

func SetEnemyWeaponStatModifier(stat: WEAPON_STATS, change):
	if(enemy_weapon_modifiers.has(stat)):
		enemy_weapon_modifiers[stat] = enemy_weapon_modifiers[stat] + change
	else:
		print("didn't find that stat")	

# Reset Stats
func ResetPlayerStats():
	for stat in ENT_STATS:
		player_modifiers[stat] = initValAdd

func ResetPlayerWeaponStats():
	for stat in WEAPON_STATS:
		player_weapon_modifiers[stat] = initValAdd

func ResetEnemyStats():
	for stat in ENT_STATS:
		enemy_modifiers[stat] = initValAdd

func ResetEnemyWeaponStats():
	for stat in WEAPON_STATS:
		enemy_weapon_modifiers[stat] = initValAdd
		
func ResetAllStats():
	ResetPlayerStats()
	ResetEnemyStats()
	ResetPlayerWeaponStats()
	ResetEnemyWeaponStats()

extends Node

enum ENT_STATS {HEALTH, MOVE_SPEED, SHIELD}
enum WEAPON_STATS {DAM, RANGE, PELLET_COUNT, ACCURACY, ATTACK_SPEED}

var initValAdd = 0

var player_modifiers = {
	ENT_STATS.HEALTH : initValAdd,
	ENT_STATS.MOVE_SPEED : initValAdd,
	ENT_STATS.SHIELD : initValAdd,
	}

var regular_enemy_modifiers = {
	ENT_STATS.HEALTH : initValAdd,
	ENT_STATS.MOVE_SPEED : initValAdd,
	ENT_STATS.SHIELD : initValAdd,
	}
	
var boss_enemy_modifiers = {
	ENT_STATS.HEALTH : initValAdd,
	ENT_STATS.MOVE_SPEED : initValAdd,
	ENT_STATS.SHIELD : initValAdd,
	}
	
var stat_change = {
	ENT_STATS.HEALTH : 5,
	ENT_STATS.MOVE_SPEED : 5,
	ENT_STATS.SHIELD : 3,
	}

var player_weapon_modifiers = {
	WEAPON_STATS.DAM : initValAdd,
	WEAPON_STATS.RANGE : initValAdd,
	WEAPON_STATS.PELLET_COUNT : initValAdd,
	WEAPON_STATS.ACCURACY : initValAdd,
	WEAPON_STATS.ATTACK_SPEED : initValAdd
	}
	
var regular_enemy_weapon_modifiers = {
	WEAPON_STATS.DAM : initValAdd,
	WEAPON_STATS.RANGE : initValAdd,
	WEAPON_STATS.PELLET_COUNT : initValAdd,
	WEAPON_STATS.ACCURACY : initValAdd,
	WEAPON_STATS.ATTACK_SPEED : initValAdd
	}
	
var boss_enemy_weapon_modifiers = {
	WEAPON_STATS.DAM : initValAdd,
	WEAPON_STATS.RANGE : initValAdd,
	WEAPON_STATS.PELLET_COUNT : initValAdd,
	WEAPON_STATS.ACCURACY : initValAdd,
	WEAPON_STATS.ATTACK_SPEED : initValAdd
	}
var weapon_change = {
	WEAPON_STATS.DAM : 5,
	WEAPON_STATS.RANGE : 0.1,
	WEAPON_STATS.PELLET_COUNT : 1,
	WEAPON_STATS.ACCURACY : 5,
	WEAPON_STATS.ATTACK_SPEED : 0.1
	}

var regular_enemy_change= {
	ENT_STATS.HEALTH : 5,
	ENT_STATS.MOVE_SPEED : 5,
	ENT_STATS.SHIELD : 0
}

var boss_enemy_change = {
	ENT_STATS.HEALTH : 10,
	ENT_STATS.MOVE_SPEED : 5,
	ENT_STATS.SHIELD : 0
}

var regular_enemy_weapon_change= {
	WEAPON_STATS.DAM : 2,
	WEAPON_STATS.RANGE : 0,
	WEAPON_STATS.PELLET_COUNT : 0,
	WEAPON_STATS.ACCURACY : 0,
	WEAPON_STATS.ATTACK_SPEED : 1
}

var boss_enemy_weapon_change = {
	WEAPON_STATS.DAM : 4,
	WEAPON_STATS.RANGE : 0,
	WEAPON_STATS.PELLET_COUNT : 0,
	WEAPON_STATS.ACCURACY : 0,
	WEAPON_STATS.ATTACK_SPEED : 0
}

	#Entity Stats
func GetPlayerStatModifier(stat: ENT_STATS):
	if(player_modifiers.has(stat)):
		return player_modifiers[stat]
	else:
		print("didn't find that stat")
		
func GetStatChangeDef(stat: ENT_STATS):
		return stat_change[stat]
		
func GetStatChangeOff(stat: WEAPON_STATS):
		return weapon_change[stat]

func SetPlayerStatModifier(stat: ENT_STATS):
	if(player_modifiers.has(stat) && stat_change.has(stat)):
		player_modifiers[stat] = player_modifiers[stat] + stat_change[stat]
	else:
		print("didn't find that stat")
		
func GetEnemyStatModifier(stat: ENT_STATS):
	if(regular_enemy_modifiers.has(stat)):
		return regular_enemy_modifiers[stat]
	else:
		print("didn't find that stat")

func SetEnemyStatModifier(stat: ENT_STATS, change):
	if(regular_enemy_modifiers.has(stat)):
		regular_enemy_modifiers[stat] = regular_enemy_modifiers[stat] + change
	else:
		print("didn't find that stat")


#Weapon Stats
func GetPlayerWeaponStatModifier(stat: WEAPON_STATS):
	if(player_weapon_modifiers.has(stat)):
		return player_weapon_modifiers[stat]
	else:
		print("didn't find that stat")

func SetPlayerWeaponStatModifier(stat: WEAPON_STATS):
	if(player_weapon_modifiers.has(stat) && weapon_change.has(stat)):
		player_weapon_modifiers[stat] = player_weapon_modifiers[stat] + weapon_change[stat]
	else:
		print("didn't find that stat")	

func GetEnemyWeaponStatModifier(stat: WEAPON_STATS):
	if(regular_enemy_weapon_modifiers.has(stat)):
		return regular_enemy_weapon_modifiers[stat]
	else:
		print("didn't find that stat")

func SetEnemyWeaponStatModifier(stat: WEAPON_STATS, change):
	if(regular_enemy_weapon_modifiers.has(stat)):
		regular_enemy_weapon_modifiers[stat] = regular_enemy_weapon_modifiers[stat] + change
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
		regular_enemy_modifiers[stat] = initValAdd

func ResetEnemyWeaponStats():
	for stat in WEAPON_STATS:
		regular_enemy_weapon_modifiers[stat] = initValAdd

func IncrementEnemyStats():
	for i in ENT_STATS.size():
		regular_enemy_modifiers[i] = regular_enemy_modifiers[i] + regular_enemy_change[i]
		boss_enemy_modifiers[i] = boss_enemy_modifiers[i] + boss_enemy_change[i]
	for i in WEAPON_STATS.size():
		regular_enemy_weapon_modifiers[i] = regular_enemy_weapon_modifiers[i] + regular_enemy_weapon_change[i]
		boss_enemy_weapon_modifiers[i] = boss_enemy_weapon_modifiers[i] + boss_enemy_weapon_change[i]

func ResetAllStats():
	ResetPlayerStats()
	ResetEnemyStats()
	ResetPlayerWeaponStats()
	ResetEnemyWeaponStats()

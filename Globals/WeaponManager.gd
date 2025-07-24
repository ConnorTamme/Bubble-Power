extends Node

var statsTable = {
	Enums.WeaponType.shotgun : {
		Enums.WEAPON_STATS.DAM : 1,
		Enums.WEAPON_STATS.RANGE : 400,
		Enums.WEAPON_STATS.PELLET_COUNT : 6,
		Enums.WEAPON_STATS.ACCURACY : 0.7,
		Enums.WEAPON_STATS.ATTACK_SPEED : 5,
		"isMelee" : false
	},
	Enums.WeaponType.sword : {
		Enums.WEAPON_STATS.DAM : 1,
		Enums.WEAPON_STATS.RANGE : 400,
		Enums.WEAPON_STATS.PELLET_COUNT : 1,
		Enums.WEAPON_STATS.ACCURACY : 1,
		Enums.WEAPON_STATS.ATTACK_SPEED : 5,
		"isMelee" : true
	},
	Enums.WeaponType.NOVA : {
		Enums.WEAPON_STATS.DAM : 20,
		Enums.WEAPON_STATS.RANGE : 400,
		Enums.WEAPON_STATS.PELLET_COUNT : 30,
		Enums.WEAPON_STATS.ACCURACY : -3.14,
		Enums.WEAPON_STATS.ATTACK_SPEED : 0.01,
		"isMelee" : false
	}
}

func lookupStats(type: Enums.WeaponType) -> Dictionary:
	return statsTable[type]

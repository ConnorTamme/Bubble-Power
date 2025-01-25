extends Node

var statsTable = {
	Enums.WeaponType.shotgun : {
		Enums.WEAPON_STATS.DAM : 1,
		Enums.WEAPON_STATS.SPEED : 1,
		Enums.WEAPON_STATS.RANGE : 1,
		Enums.WEAPON_STATS.PELLET_COUNT : 1,
		Enums.WEAPON_STATS.ACCURACY : 1,
	} #need stats struct
}

func lookupStats(type: Enums.WeaponType) -> Dictionary:
	return statsTable[type]

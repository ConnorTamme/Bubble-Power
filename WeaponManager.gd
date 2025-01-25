extends Node

var statsTable = {
	Enums.WeaponType.shotgun : {
		Enums.WEAPON_STATS.DAM : 1,
		Enums.WEAPON_STATS.SPEED : 400,
		Enums.WEAPON_STATS.RANGE : 800,
		Enums.WEAPON_STATS.PELLET_COUNT : 6,
		Enums.WEAPON_STATS.ACCURACY : 0.5,
	} #need stats struct
}

func lookupStats(type: Enums.WeaponType) -> Dictionary:
	return statsTable[type]

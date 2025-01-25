var statsTable = {
	WeaponType.shotgun : "test" #need stats struct
}

func lookupStats(type: WeaponType) -> String:
	return statsTable[type]

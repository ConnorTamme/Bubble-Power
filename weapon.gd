extends Sprite2D

class_name Weapon

var isPlayerWeapon: bool
var stats
var modifier
var canAttack = true
var rng = RandomNumberGenerator.new()

static func create_player_weapon(weaponType: Enums.WeaponType) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://",str(weaponType),".tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = true
	weapon.stats = WeaponManager.lookupStats(weaponType)
	#weapon.getStatsFromSingleton()
	return weapon

#Need modifier struct
static func create_enemy_weapon(weaponType: Enums.WeaponType, enemyModifier) -> Weapon:
	print(str("res://",Enums.WeaponType.keys()[weaponType],".tscn"))
	var weapon_scene: PackedScene = load(str("res://weapon.tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = false
	weapon.stats = WeaponManager.lookupStats(weaponType)
	weapon.modifier = enemyModifier
	return weapon

func attack(direction: Vector2) -> void:
	if !canAttack:
		return
	canAttack = false
	$attackDelay.start()
	direction = direction/direction.length()
	for i in stats[Enums.WEAPON_STATS.PELLET_COUNT]:
		var projectile = Projectile.create_projectile(direction.rotated(rng.randf_range(-1 + stats[Enums.WEAPON_STATS.ACCURACY],
		 1 - stats[Enums.WEAPON_STATS.ACCURACY])),
		 rng.randf_range(stats[Enums.WEAPON_STATS.SPEED]*0.66,stats[Enums.WEAPON_STATS.SPEED]),
		 stats[Enums.WEAPON_STATS.DAM],
		 stats[Enums.WEAPON_STATS.RANGE])
		projectile.set_name("bullet")
		projectile.global_transform = global_transform
		get_parent().get_parent().add_child(projectile)
	


func _on_attack_delay_timeout() -> void:
	canAttack = true

extends Sprite2D

class_name Weapon

var isPlayerWeapon: bool
var stats
var modifier
var canAttack = true
var rng = RandomNumberGenerator.new()

static func create_player_weapon(weaponType: Enums.WeaponType) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://weapon.tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = true
	weapon.stats = WeaponManager.lookupStats(weaponType)
	weapon.modifier = StaticStats.player_weapon_modifiers
	return weapon

#Need modifier struct
static func create_enemy_weapon(weaponType: Enums.WeaponType) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://weapon.tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = false
	weapon.stats = WeaponManager.lookupStats(weaponType)
	weapon.modifier = StaticStats.enemy_weapon_modifiers
	return weapon

func attack(direction: Vector2) -> void:
	if !canAttack:
		return
	canAttack = false
	
	direction = direction/direction.length()
	var combinedStats = {
		Enums.WEAPON_STATS.DAM : stats[Enums.WEAPON_STATS.DAM] + modifier[Enums.WEAPON_STATS.DAM],
		Enums.WEAPON_STATS.SPEED : stats[Enums.WEAPON_STATS.SPEED] + modifier[Enums.WEAPON_STATS.SPEED],
		Enums.WEAPON_STATS.RANGE : stats[Enums.WEAPON_STATS.RANGE] + modifier[Enums.WEAPON_STATS.RANGE],
		Enums.WEAPON_STATS.PELLET_COUNT : stats[Enums.WEAPON_STATS.PELLET_COUNT] + modifier[Enums.WEAPON_STATS.PELLET_COUNT],
		Enums.WEAPON_STATS.ACCURACY : min(1,stats[Enums.WEAPON_STATS.ACCURACY] + modifier[Enums.WEAPON_STATS.ACCURACY]),
		Enums.WEAPON_STATS.ATTACK_SPEED : stats[Enums.WEAPON_STATS.ATTACK_SPEED] + modifier[Enums.WEAPON_STATS.ATTACK_SPEED],
		}
		
	$attackDelay.start(combinedStats[Enums.WEAPON_STATS.ATTACK_SPEED])
	
	for i in combinedStats[Enums.WEAPON_STATS.PELLET_COUNT]:
		var projectile = Projectile.create_projectile(
			direction.rotated(rng.randf_range(-1 + combinedStats[Enums.WEAPON_STATS.ACCURACY],
		 1 - combinedStats[Enums.WEAPON_STATS.ACCURACY])),
		 rng.randf_range(combinedStats[Enums.WEAPON_STATS.SPEED]*0.66,
		combinedStats[Enums.WEAPON_STATS.SPEED]),
		 combinedStats[Enums.WEAPON_STATS.DAM],
		 combinedStats[Enums.WEAPON_STATS.RANGE])
		projectile.set_name("bullet")
		projectile.global_transform = global_transform
		get_parent().get_parent().add_child(projectile)
	


func _on_attack_delay_timeout() -> void:
	canAttack = true

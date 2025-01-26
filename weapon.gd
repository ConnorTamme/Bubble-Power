extends Sprite2D

class_name Weapon


var isPlayerWeapon: bool = false
@export var projectile: PackedScene
@export var stats = {
	"Damage" : 10,
	"Projectile Speed" : 400,
	"Range" : 400,
	"Pellet Count" : 1,
	"Accuracy" : 0.7,
	"Attack Speed" : 1000,
	"isMelee" : false
}
var modifier = StaticStats.regular_enemy_weapon_modifiers
var canAttack = true
var rng = RandomNumberGenerator.new()

static func create_player_weapon(weaponType: Enums.WeaponType) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://weapon.tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = true
	weapon.modifier = StaticStats.player_weapon_modifiers
	return weapon

#Need modifier struct
static func create_enemy_weapon(weaponType: Enums.WeaponType) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://weapon.tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = false
	weapon.modifier = StaticStats.enemy_weapon_modifiers
	return weapon

func setPlayerWeapon() -> void:
	isPlayerWeapon = true
	modifier = StaticStats.player_weapon_modifiers

func attack(direction: Vector2) -> void:
	if !$attackDelay.is_stopped():
		return
	$attackDelay.start(stats["Attack Speed"])
	direction = direction/direction.length()
	var combinedStats = {
		Enums.WEAPON_STATS.DAM : stats["Damage"] + modifier[Enums.WEAPON_STATS.DAM],
		Enums.WEAPON_STATS.RANGE : min(1000, stats["Range"] + modifier[Enums.WEAPON_STATS.RANGE]),
		Enums.WEAPON_STATS.PELLET_COUNT : stats["Pellet Count"] + modifier[Enums.WEAPON_STATS.PELLET_COUNT],
		Enums.WEAPON_STATS.ACCURACY : min(1,stats["Accuracy"] + modifier[Enums.WEAPON_STATS.ACCURACY]),
		Enums.WEAPON_STATS.ATTACK_SPEED : max(0.1,(stats["Attack Speed"] - modifier[Enums.WEAPON_STATS.ATTACK_SPEED])/1000),
		}
	if (stats["isMelee"]):
		combinedStats["speed"] = 0
	
	if (isPlayerWeapon):
		$FireSound.set_volume_db(randf_range(-2,2))
		$FireSound.play()
	for i in combinedStats[Enums.WEAPON_STATS.PELLET_COUNT]:
		var proj = projectile.instantiate()
		proj.set_parameters(
			direction.rotated(rng.randf_range(-1 + combinedStats[Enums.WEAPON_STATS.ACCURACY],
		 1 - combinedStats[Enums.WEAPON_STATS.ACCURACY])),
		 rng.randf_range(stats["Projectile Speed"]*0.66,
		stats["Projectile Speed"]),
		 combinedStats[Enums.WEAPON_STATS.DAM],
		 combinedStats[Enums.WEAPON_STATS.RANGE],
		 isPlayerWeapon,
		)
		proj.set_name("bullet")
		proj.global_transform = global_transform
		get_parent().get_parent().add_child(proj)
		

func _on_attack_delay_timeout() -> void:
	canAttack = true

func get_range() -> float:
	return stats["Range"] + modifier[Enums.WEAPON_STATS.RANGE]

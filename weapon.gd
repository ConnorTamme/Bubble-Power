extends Sprite2D

class_name Weapon

var isPlayerWeapon: bool
var stats
var modifier


static func create_player_weapon(weaponType: WeaponType) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://",str(weaponType),".tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = true
	weapon.stats = WeaponManager.lookupStats(weaponType)
	#weapon.getStatsFromSingleton()
	return weapon

#Need modifier struct
static func create_enemy_weapon(weaponType: WeaponType, enemyModifier: String) -> Weapon:
	var weapon_scene: PackedScene = load(str("res://",weaponType,".tscn"))
	var weapon = weapon_scene.instantiate()
	weapon.isPlayerWeapon = false
	weapon.stats = WeaponManager.lookupStats(weaponType)
	weapon.modifer = enemyModifier
	return weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

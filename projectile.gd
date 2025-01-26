extends RigidBody2D

class_name Projectile

var direction = Vector2.ZERO
var speed = 5
var damage = 1
var start_pos
var range
var isMelee
#Pretty sure we will need to set the mask in here too so it only targets players or enemies depending on who shot it

static func create_projectile(direction: Vector2, speed: float, damage: float, range:float, isPlayerProjectile: bool, isMelee: bool) -> Projectile:
	var proj_scene: PackedScene = load("res://projectile.tscn")
	if isMelee:
		proj_scene = load("res://melee_projectile.tscn")
	
	var proj: Projectile = proj_scene.instantiate()
	proj.direction = direction
	proj.speed = speed
	proj.damage = damage
	proj.range = range
	proj.isMelee = isMelee
	if isPlayerProjectile:
		proj.set_collision_layer_value(4, true)
	else:
		proj.set_collision_layer_value(3, true)
	return proj
	
static func create_melee_projectile(direction: Vector2, speed: float, damage: float, range:float, isPlayerProjectile: bool) -> Projectile:
	var proj_scene: PackedScene = load("res://melee_projectile.tscn")
	var proj: Projectile = proj_scene.instantiate()
	proj.direction = direction
	proj.speed = speed
	proj.damage = damage
	proj.range = range
	proj.isMelee = true
	if isPlayerProjectile:
		proj.set_collision_layer_value(4, true)
	else:
		proj.set_collision_layer_value(3, true)
	return proj

func _ready() -> void:
	start_pos = Vector2(position.x, position.y)
	if isMelee:
		global_position += direction * range/4
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Just to document. These MUST be global_position or else the projectile just sits there for a bit
	#It has the right values and everything it just simply doesn't move for seemingly no reason
	global_position.x += direction.x * delta * speed
	global_position.y += direction.y * delta * speed
	var distance_from_start = Vector2(start_pos.x - position.x, start_pos.y - position.y)
	if range == null:
		return
	if  distance_from_start.length() > range:
		queue_free()

func collided() -> void:
	if !isMelee:
		queue_free()
	


func _on_life_time_timeout() -> void:
	queue_free()

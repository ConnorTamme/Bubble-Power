extends RigidBody2D

class_name Projectile

var direction = Vector2.ZERO
var speed = 5
var damage = 1
var start_pos
var range
#Pretty sure we will need to set the mask in here too so it only targets players or enemies depending on who shot it

static func create_projectile(direction: Vector2, speed: float, damage: float, range:float) -> Projectile:
	var proj_scene: PackedScene = load("res://projectile.tscn")
	var proj: Projectile = proj_scene.instantiate()
	proj.direction = direction
	proj.speed = speed
	proj.damage = damage
	proj.range = range
	return proj
	
func set_parameters(direction: Vector2, speed: float, damage: float, range:float) -> Projectile:
	self.direction = direction
	self.speed = speed
	self.damage = damage
	self.range = range
	return self
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	start_pos = Vector2(position.x, position.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Just to document. These MUST be global_position or else the projectile just sits there for a bit
	#It has the right values and everything it just simply doesn't move for seemingly no reason
	global_position.x += direction.x * delta * speed
	global_position.y += direction.y * delta * speed
	var distance_from_start = Vector2(start_pos.x - position.x, start_pos.y - position.y)
	if  distance_from_start.length() > range:
		queue_free()


	

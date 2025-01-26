extends RigidBody2D

class_name Projectile

var direction = Vector2.ZERO
var speed = 5
var damage = 1
var start_pos
var range
var isMelee = false

func set_parameters(direction: Vector2, speed: float, damage: float, range:float, isPlayerProjectile: bool):
	self.direction = direction
	self.speed = speed
	self.damage = damage
	self.range = range
	if isPlayerProjectile:
		self.set_collision_layer_value(4, true)
	else:
		self.set_collision_layer_value(3, true)

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

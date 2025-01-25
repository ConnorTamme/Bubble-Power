extends Area2D

@export var attackDelay = 2
@export var moveSpeed = 50
@export var health = 2
@export var towardsPlayer = true
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

func takeDamage(damage: float) -> void:
	health -= damage
	if (health <= 0):
		die()
		
func die() -> void:
	queue_free()

func move(delta: float) -> void:
	var direction = Vector2(player.position.x - position.x, player.position.y - position.y)
	direction = direction/direction.length()
	direction = direction * moveSpeed * delta
	if (!towardsPlayer):
		direction *= -1
	position.x += direction.x
	position.y += direction.y
	
	

extends Area2D

@export var attackDelay = 2
@export var moveSpeed = 2
@export var health = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func takeDamage(damage: float) -> void:
	health -= damage
	if (health <= 0):
		die()
		
func die() -> void:
	queue_free()

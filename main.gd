extends Node2D

@onready var enemy = preload("res://enemy.tscn")
@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	DisplayServer.window_get_size()
	var sz = get_viewport().get_visible_rect().size
	
	var x_pos = (randi() % int(sz.x))
	var y_pos = (randi() % int(sz.y))
	var e = enemy.instantiate()
	e.position.x = x_pos
	e.position.y = y_pos
	add_child(e)
	$Timer.start()

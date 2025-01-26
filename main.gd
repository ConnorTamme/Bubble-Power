extends Node2D

@onready var enemy = preload("res://enemy.tscn")
@export var mob_scene: PackedScene
var to_spawn = 10
var killed = 0
var spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MobTimer.start()
	GlobalSignals.died.connect(_on_player_death)
	GlobalSignals.enemyKilled.connect(_on_enemy_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	if spawned < to_spawn:
		
	# Create a new instance of the Mob scene.
		var e = enemy.instantiate()

	# Choose a random location on Path2D.
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
		var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
		e.position = mob_spawn_location.position
		# Spawn the mob by adding it to the Main scene.
		add_child(e)

func _on_player_death() -> void:
	$MobTimer.stop()

func _on_enemy_death() -> void:
	killed += 1
	if killed == to_spawn:
		GlobalSignals.nextScene.emit()
	

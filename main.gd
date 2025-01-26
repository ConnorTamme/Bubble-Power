extends Node2D

#@onready var enemy = preload("res://enemy.tscn")
@export var enemy: Array[PackedScene]
@export var boss: PackedScene
@export var death_banner: PackedScene
@export var victory_banner: PackedScene
@export var max_on_screen: int = 15

var to_spawn = min(10 + 5 * Singleton.level, 100)
var spawn_rate = max(0.3, 1.5 - 0.1 * Singleton.level)
var killed = 0
var spawned = 0
var bossesToSpawn: int = Singleton.level/2
var bossesSpawned = 0
var bossesKilled = 0
var shouldSpawnBosses:bool = (to_spawn % 2 == 0)
var player_died = false
@export var endDelay = 2
var isWinner: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MobTimer.start(spawn_rate)
	GlobalSignals.died.connect(_on_player_death)
	GlobalSignals.enemyKilled.connect(_on_enemy_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	if spawned < to_spawn or spawned - killed > max_on_screen:
		spawned += 1
	# Create a new instance of the Mob scene.
		var e = enemy.pick_random().instantiate()

	# Choose a random location on Path2D.
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
		e.position = mob_spawn_location.position
		# Spawn the mob by adding it to the Main scene.
		add_child(e)
	if shouldSpawnBosses and bossesToSpawn < bossesSpawned and bossesKilled == bossesToSpawn:
		bossesSpawned += 1
		var e = boss.instantiate()

	# Choose a random location on Path2D.
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
		e.position = mob_spawn_location.position
		# Spawn the mob by adding it to the Main scene.
		add_child(e)

func _on_player_death() -> void:
	$MobTimer.stop()
	player_died = true
	Singleton.level = 1
	StaticStats.ResetAllStats()
	$EndTimer.start()
	isWinner = false
	$EndTimer/DeathBanner.visible = true
	$EndTimer.start(endDelay)

func _on_enemy_death() -> void:
	killed += 1
	if killed == to_spawn:
		if shouldSpawnBosses and bossesKilled < bossesToSpawn:
			return
		add_child(victory_banner.instantiate())
		$EndTimer.start()
		Singleton.level += 1
		StaticStats.IncrementEnemyStats()
		GlobalSignals.emit_signal("battleFinished")
	
func _on_boss_death() -> void:
	bossesKilled += 1
	if bossesKilled == bossesToSpawn and killed == to_spawn:
		$EndTimer.start()
		Singleton.level += 1
		StaticStats.IncrementEnemyStats()
		GlobalSignals.emit_signal("battleFinished")

func _on_end_timer_timeout() -> void:
	if player_died:
		get_tree().change_scene_to_file("res://start_screen.tscn")
	else:
		isWinner = true
		$EndTimer/VictoryBanner.visible = true
		$EndTimer.start(endDelay)

extends Area2D

var invincible = false
var player
var weapon
enum states {READY, APPROACH, RETREAT, PREPARE, RECOVER}
var ai_state = states.READY
@export var enemyStats = {"health": 2,"moveSpeed": 50,"range": 800,}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")
	weapon = Weapon.create_enemy_weapon(Enums.WeaponType.shotgun)
	enemyStats[range] = weapon.get_range() - 200
	var modifier = StaticStats.enemy_modifiers
	enemyStats["heath"] = enemyStats["health"] + modifier[Enums.ENT_STATS.HEALTH]
	enemyStats["moveSpeed"] = enemyStats["moveSpeed"] + modifier[Enums.ENT_STATS.MOVE_SPEED]
	add_child(weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	if Input.is_action_pressed("p1_shoot"):
		debug_damage()

func takeDamage(damage: float) -> void:
	if invincible:
		return
	invincible = true
	$invincibleDelay.start()
	enemyStats["health"] = enemyStats["health"] - damage
	if (enemyStats["health"] <= 0):
		die()
		
func die() -> void:
	queue_free()

func debug_damage() -> void:
	weapon.attack(Vector2(player.position.x - position.x, player.position.y - position.y))


func move(delta: float) -> void:
	match ai_state:
		states.READY:
			var player_location = Vector2(player.position.x - position.x, player.position.y - position.y)
			if player_location.length() < enemyStats[range]/2:
				ai_state = states.RETREAT
				$maxRetreatTime.start()
			elif player_location.length() > enemyStats[range]:
				ai_state = states.APPROACH
			else:
				ai_state = states.PREPARE
				$prepareTime.start()
		states.APPROACH:
			var direction = Vector2(player.position.x - position.x, player.position.y - position.y)
			direction = direction/direction.length()
			direction = direction * enemyStats["moveSpeed"] * delta
			position.x += direction.x
			position.y += direction.y
			var player_location = Vector2(player.position.x - position.x, player.position.y - position.y)
			if player_location.length() < enemyStats[range]:
				ai_state = states.PREPARE
				$prepareTime.start()
		states.RETREAT:
			var direction = Vector2(player.position.x - position.x, player.position.y - position.y)
			direction = direction/direction.length()
			direction = direction * enemyStats["moveSpeed"] * delta * -1
			position.x += direction.x
			position.y += direction.y
			var player_location = Vector2(player.position.x - position.x, player.position.y - position.y)
			if player_location.length() > enemyStats[range]:
				ai_state = states.APPROACH
			elif player_location.length() > enemyStats[range]:
				ai_state = states.PREPARE
				$prepareTime.start()
	
func _on_invincible_delay_timeout() -> void:
	invincible = false


func _on_body_entered(body: Node2D) -> void:
	takeDamage(body.damage)
	body.queue_free()


func _on_recover_time_timeout() -> void:
	ai_state = states.READY


func _on_prepare_time_timeout() -> void:
	weapon.attack(Vector2(player.position.x - position.x, player.position.y - position.y))
	$recoverTime.start()


func _on_max_retreat_time_timeout() -> void:
	if ai_state == states.RETREAT:
		ai_state = states.PREPARE
		$prepareTime.start()

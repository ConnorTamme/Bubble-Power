extends Enemy

func _ready():
	super()
	$Animator.animation = "idle"
	$Animator.play()


func _on_prepare_time_timeout() -> void:
	$Animator.animation = "attack"
	$AttackTimer.start()


func _on_attack_timer_timeout() -> void:
	weapon.attack(Vector2(player.position.x - position.x, player.position.y - position.y))
	$recoverTime.start()

func _on_recover_time_timeout() -> void:
	ai_state = states.READY
	$Animator.animation = "idle"

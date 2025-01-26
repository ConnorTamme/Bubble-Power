extends Enemy

func _ready():
	super()
	$Flipper/Animator.animation = "idle"
	$Flipper/Animator.play()

func _process(delta):
	super(delta)
	$Flipper/Animator.flip_h = ((player.position.x - position.x) > 0)
	#scale.x = 1 if ((player.position.x - position.x) > 0) else -1


func _on_prepare_time_timeout() -> void:
	super()
	#$Flipper/Animator.animation = "attack"
	$AttackTimer.start()


func _on_attack_timer_timeout() -> void:
	weapon.attack(Vector2(player.position.x - position.x, player.position.y - position.y))
	$recoverTime.start()
	#$Flipper/Animator.animation = "recover"

func _on_recover_time_timeout() -> void:
	super()
	ai_state = states.READY
	#$Flipper/Animator.animation = "recover"

extends CharacterBody2D
class_name Player

var DEBUG: bool = false;


@export var baseMoveSpeed = 400
var moveSpeed
@export var playerID = 1

@export var sprintFactor = 1.5
@export var sneakFactor = 0.8
@export var baseHealth = 100
var maxHealth
var health
var alive = true

@export var baseShield = 0
var maxShield
var shield



var screen_size
var shotDirection = 0


# Animation Variables
var walkAnimRight = "walk_right"
var walkAnimLeft = "walk_left"
var walkAnimName = walkAnimRight
var idleAnimName = "idle"

# Control Variables
var rightInput = "p1_right"
var leftInput = "p1_left"
var upInput = "p1_up"
var downInput = "p1_down"
var shootInput = "p1_shoot"
var sprintKey =  "p1_sprint"
var sneakKey =  "p1_sneak"

# Crosshair variables
@export var crosshairDist = 200
@export var crossHairObj: PackedScene
var crosshairPos = Vector2(0 ,0)
var crossHair

# Shooting Variables
var distFromPlayer = 30
@export var weaponType: Enums.WeaponType
var currWeapon: Weapon
#@export var defaultWeapon: Weapon


func _ready():
	screen_size = get_viewport_rect().size
	currWeapon = Weapon.create_player_weapon(weaponType)
	add_child(currWeapon)
	# Make crosshair
	crossHair = crossHairObj.instantiate();
	add_child(crossHair)
	
	$AnimatedSprite2D.animation = idleAnimName
	$AnimatedSprite2D.play()
	
	# Where player starts on screen
	position = Vector2(screen_size.x/4, screen_size.y/4)

	# Calculate stats:
	SetUpStats()
	
	# Connect Health bar
	$HealthBar.max_value = maxHealth
	$HealthBar.value = health
	#Connect Shield bar
	$ShieldBar.max_value = maxShield
	$ShieldBar.value = shield
	
	#currWeapon = $WeaponSingleton.GetPlayerWeapon()

func SetUpStats():
	health = baseHealth + StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS.HEALTH)
	maxHealth = health
	shield = baseShield + StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS.SHIELD)
	maxShield = shield
	moveSpeed = baseMoveSpeed + StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS.MOVE_SPEED)

func checkHealth():
	if(health < 0):
		health = 0;
	$HealthBar.value = health 



func movePlayer(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed(rightInput):
		velocity.x += 1
		walkAnimName = walkAnimLeft
	elif Input.is_action_pressed(leftInput):
		velocity.x -= 1
		walkAnimName = walkAnimRight
	
	if Input.is_action_pressed(upInput):
		velocity.y -= 1
	elif Input.is_action_pressed(downInput):
		velocity.y += 1

	# Adjust movespeed for sneak and sprint factors
	var moveSpeedFactor;
	if(Input.is_action_pressed(sneakKey)):
		moveSpeedFactor = sneakFactor
	elif(Input.is_action_pressed(sprintKey)):
		moveSpeedFactor = sprintFactor
	else:
		moveSpeedFactor = 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * moveSpeed * moveSpeedFactor
		shotDirection = velocity.angle()
		$AnimatedSprite2D.animation = walkAnimName
	else:
		$AnimatedSprite2D.animation = idleAnimName
	
	position += velocity * delta # Adjust for clock speed
	position = position.clamp(Vector2.ZERO, screen_size) # stop player from leaving screen.
	
	
# Draw a crosshair at the vector, normalized from user times a distance.
func getAttackAngle():
	var mouse = get_viewport().get_mouse_position()
	var vecX = (mouse.x - position.x)
	var vecY = (mouse.y - position.y)
	
	crosshairPos = Vector2(0, 0)
	
	crosshairPos.x += vecX
	crosshairPos.y += vecY
	
	crossHair.position = Vector2(crosshairPos.normalized() * crosshairDist)

func _process(delta):
	if !alive:
		return
	if DEBUG:
		print("Player position: ", position)
	
	checkHealth()
	movePlayer(delta)
	getAttackAngle()
	
	#Shooting
	if Input.is_action_pressed(shootInput):
		currWeapon.attack(crossHair.position)
		pass


func _on_body_entered(body: Node2D) -> void:
	takeDamage(body.damage)
	body.collided()
	if body.get_parent() != self:
		print("Player got shot! O.o")
		# if shield, hurt shield. 
		# else, hurt health

func takeDamage(damage: float) -> void:
	health -= damage
	if (health < 0):
		die()

func die() -> void:
	GlobalSignals.died.emit()
	alive = false
	$deathTimer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	takeDamage(body.damage)
	body.collided()


func _on_death_timer_timeout() -> void:
	queue_free()

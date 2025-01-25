extends CharacterBody2D
class_name Player

@export var speed = 400
@export var shotDelay = 0.5
@export var bullet : PackedScene
#@export var shotspeed:Vector2 = Vector2(200,0)
var shotspeed = 3000
@export var playerID = 1
@export var healthPerShot = 1
@export var hitDamage = 20

@export var sprintFactor = 1.5
@export var sneakFactor = 0.8
var maxHealth = 100
var screen_size
var DEBUG: bool = false;
#var velocity = Vector2.ZERO
var shotDirection = 0
var health = maxHealth

# Variables for diverse cast
var walkAnimName
var idleAnimName
var rightInput
var leftInput
var upInput 
var downInput
var shootInput
var sprintKey
var sneakKey

# Crosshair variables
@export var crosshairDist = 200
@export var crossHairObj: PackedScene
var crosshairPos = Vector2.ZERO
var crossHair

# Shooting Variables
var distFromPlayer = 30

func _ready():
	screen_size = get_viewport_rect().size
	crossHair = crossHairObj.instantiate();
	add_child(crossHair)

	
	# Connect Inputs based on player ID
	rightInput = "p" + str(playerID) + "_right"
	leftInput = "p" + str(playerID) + "_left"
	upInput = "p" + str(playerID) + "_up"
	downInput = "p" + str(playerID) + "_down"
	shootInput = "p" + str(playerID) + "_shoot"
	sprintKey =  "p" + str(playerID) + "_sprint"
	sneakKey =  "p" + str(playerID) + "_sneak"
	
	# Connect character animations
	walkAnimName = "walk"
	idleAnimName = "idle"
	$AnimatedSprite2D.animation = idleAnimName
	$AnimatedSprite2D.play()
	
	match playerID:
		1: position = Vector2(screen_size.x/4, screen_size.y/4)
		2: position = Vector2(3*screen_size.x/4, screen_size.y/4)
		3: position = Vector2(screen_size.x/4, 3*screen_size.y/4)
		4: position = Vector2(3*screen_size.x/4, 3*screen_size.y/4)
	
	# Connect Health bar
	$HealthBar.max_value = maxHealth
	$HealthBar.value = health
	if(bullet == null): # Move this so it is not done every time.
			push_error("No bullet assigned to Player #", playerID)

	
	# Set layer and mask for player and projectiles
	#for i in range(1, 5):
		#if(i == playerID):
			#set_collision_layer_value(i, true)
			#set_collision_mask_value(i, false)
		#else:
			#set_collision_layer_value(i, false)
			#set_collision_mask_value(i, true)
func checkHealth():
	if(health < 0):
		health = 0;
	$HealthBar.value = health 
	if(health <= 0):
		_die()
func movePlayer(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed(rightInput):
		velocity.x += 1
	elif Input.is_action_pressed(leftInput):
		velocity.x -= 1
	
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
		velocity = velocity.normalized() * speed * moveSpeedFactor
		shotDirection = velocity.angle()
		$AnimatedSprite2D.animation = walkAnimName
	else:
		$AnimatedSprite2D.animation = idleAnimName
	
	position += velocity * delta
	#move_and_slide(velocity)
	position = position.clamp(Vector2.ZERO, screen_size)
	
# Draw a crosshair at the vector, normalized from user times a distance.
func getAttackAngle():
	var mouse = get_viewport().get_mouse_position()
	var vecX = (mouse.x - position.x)
	var vecY = (mouse.y - position.y)
	
	crosshairPos = Vector2.ZERO
	crosshairPos.x += vecX
	crosshairPos.y += vecY
	
	if(crossHair == null):
		print("CrossHair is null!")
	crossHair.position = Vector2(crosshairPos.normalized() * crosshairDist)

func _process(delta):
	if DEBUG:
		print("Player position: ", position)
	
	checkHealth()
	movePlayer(delta)
	getAttackAngle()
	
	#Shooting
	if Input.is_action_pressed(shootInput):# and $ShotTimer.is_stopped():
		var shot
		if(bullet != null): # Move this so it is not done every time.
			var rotate_by = atan2(crosshairPos.x, crosshairPos.y)
			shot = bullet.instantiate();
			shot.rotate(rotate_by)
			shot.position = distFromPlayer * crosshairPos.normalized()
			shot.linear_velocity = (shotspeed * crosshairPos.normalized())
			#shot.set_collision_layer_value(playerID, false)
			add_child(shot)
		$ShotTimer.start(shotDelay);
	
	#Sprite Animation
	#if(velocity.x != 0):
		#$AnimatedSprite2D.flip_h = velocity.x < 0

func _die():
	print("ARRRGH!!! PLAYER ", str(playerID), " has died!")
	Singleton._killPlayer(playerID);
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() != self:
		if DEBUG:
			print("Player", str(playerID), " got shot! O.o")
		health -= hitDamage

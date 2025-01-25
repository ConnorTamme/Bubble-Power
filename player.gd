extends CharacterBody2D
class_name Player

@export var speed = 400
@export var shotDelay = 0.5
@export var bullet : PackedScene
#@export var shotspeed:Vector2 = Vector2(200,0)
var shotspeed = 3000
@export var playerID = 1
@export var hitDamage = 20

@export var sprintFactor = 1.5
@export var sneakFactor = 0.8
var maxHealth = 100
var screen_size
var DEBUG: bool = false;
var shotDirection = 0
var health = maxHealth

# Variables for diverse cast
var walkAnimRight = "walk_right"
var walkAnimLeft = "walk_left"
var walkAnimName = "walk"
var idleAnimName = "idle"

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
var crosshairPos = Vector2.ZERO
var crossHair

# Shooting Variables
var distFromPlayer = 30

func _ready():
	screen_size = get_viewport_rect().size
	crossHair = crossHairObj.instantiate();
	add_child(crossHair)
	
	$AnimatedSprite2D.animation = idleAnimName
	$AnimatedSprite2D.play()
	
	# Where player starts on screen
	position = Vector2(screen_size.x/4, screen_size.y/4)

	# Connect Health bar
	$HealthBar.max_value = maxHealth
	$HealthBar.value = health
	
	#throw error if no bullet
	if(bullet == null): # Move this so it is not done every time.
			push_error("No bullet assigned to Player #", playerID)


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
		velocity = velocity.normalized() * speed * moveSpeedFactor
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

func _die():
	print("ARRRGH!!! PLAYER ", str(playerID), " has died!")
	Singleton._killPlayer(playerID);
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.get_parent() != self:
		if DEBUG:
			print("Player", str(playerID), " got shot! O.o")
		health -= hitDamage

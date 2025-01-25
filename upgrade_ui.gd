extends Node2D

var screen_size
var DEBUG = true

var defenceUpgradeText = {
	StaticStats.ENT_STATS.HEALTH : "MAX HEALTH++",
	StaticStats.ENT_STATS.MOVE_SPEED : "MOVE SPEED++",
	StaticStats.ENT_STATS.SHIELD : "SHIELD++",
	}
	
var offenceUpgradeText = {
	StaticStats.WEAPON_STATS.DAM : "WEAPON DAMAGE++",
	StaticStats.WEAPON_STATS.SPEED : "ATTACK SPEED++",
	StaticStats.WEAPON_STATS.RANGE : "RANGE++",
	StaticStats.WEAPON_STATS.PELLET_COUNT : "PROJECTILE COUNT++",
	StaticStats.WEAPON_STATS.ACCURACY : "ACCURACY++",
	}

var upgradeA = false;
var upgradeB = false;
var upgradeC = false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	CycleUpgrades()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func CycleUpgrades():
	# one should be defensive, one offensive
	GetDefenseUpgrade($UpgradeABtn)
	pass
	
func GetDefenseUpgrade(btn: Button):
	var i = randi() % StaticStats.ENT_STATS.size()
	var defStat = StaticStats.ENT_STATS.keys()[i]
	btn.text = defenceUpgradeText[StaticStats.ENT_STATS[defStat]]


# Button Methods for toggling continue
func _on_upgrade_a_btn_toggled(toggled_on: bool) -> void:
	upgradeA = toggled_on
	if(toggled_on):
		$UpgradeBBtn.button_pressed = false
		upgradeB = false
		$UpgradeCBtn.button_pressed = false
		upgradeC = false
	SetContinueBtnState()
	
func _on_upgrade_b_btn_toggled(toggled_on: bool) -> void:
	upgradeB = toggled_on
	if(toggled_on):
		$UpgradeABtn.button_pressed = false
		upgradeA = false
		$UpgradeCBtn.button_pressed = false
		upgradeC = false
	SetContinueBtnState()
	
func _on_upgrade_c_btn_toggled(toggled_on: bool) -> void:
	upgradeC = toggled_on
	if(toggled_on):
		$UpgradeABtn.button_pressed = false
		upgradeA = false
		$UpgradeBBtn.button_pressed = false
		upgradeB = false
	SetContinueBtnState()

func SetContinueBtnState():
	if(DEBUG):
		print("Button States:", $UpgradeABtn.button_pressed, $UpgradeBBtn.button_pressed, $UpgradeCBtn.button_pressed)
		print("Button booleans:", upgradeA, upgradeB, upgradeC)
		print("Contiue should be disabled: ", !((upgradeA && !upgradeB && !upgradeC) || (!upgradeA && upgradeB && !upgradeC) || (!upgradeA && !upgradeB && upgradeC)))
	
	$SelectAndContinue.disabled = !((upgradeA && !upgradeB && !upgradeC) || (!upgradeA && upgradeB && !upgradeC) || (!upgradeA && !upgradeB && upgradeC))

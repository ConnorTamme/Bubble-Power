extends Node2D

var screen_size
var DEBUG = true
var statText: String 

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
var btnStat = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	CycleUpgrades()
	SetStatsText()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SetStatsText():
	statText = "PLAYER STAT MODIFIERS: "
	statText += "\n\t- MAX HEALTH: "
	statText += str(StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS.HEALTH))
	statText += "\n\t- MAX SHIELD: "
	statText += str(StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS.SHIELD))
	statText += "\n\t- MOVE SPEED: "
	statText += str(StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS.MOVE_SPEED))
	
	statText += "\n\n\nPLAYER WEAPON MODIFIERS:"
	statText += "\n\t- DAMAGE: "
	statText += str(StaticStats.GetPlayerWeaponStatModifier(StaticStats.WEAPON_STATS.DAM))
	statText += "\n\t- ATTACK SPEED: "
	statText += str(StaticStats.GetPlayerWeaponStatModifier(StaticStats.WEAPON_STATS.SPEED))
	statText += "\n\t- RANGE: "
	statText += str(StaticStats.GetPlayerWeaponStatModifier(StaticStats.WEAPON_STATS.RANGE))
	statText += "\n\t- PROJECTILE COUNT: "
	statText += str(StaticStats.GetPlayerWeaponStatModifier(StaticStats.WEAPON_STATS.PELLET_COUNT))
	statText += "\n\t- ACCURACY: "
	statText += str(StaticStats.GetPlayerWeaponStatModifier(StaticStats.WEAPON_STATS.ACCURACY))
	
	
	
	
	$StatsText.text = statText
	

func CycleUpgrades():
	# one should be defensive, one offensive
	GetDefenseUpgrade($UpgradeABtn)
	GetOffenseUpgrade($UpgradeBBtn)
	GetOffenseUpgrade($UpgradeCBtn)
	pass
	
func GetDefenseUpgrade(btn: Button):
	var i = randi() % StaticStats.ENT_STATS.size()
	var defStat = StaticStats.ENT_STATS.keys()[i]
	btnStat[btn] = StaticStats.ENT_STATS[defStat]
	btn.text = defenceUpgradeText[StaticStats.ENT_STATS[defStat]]

func GetOffenseUpgrade(btn: Button):
	var i = randi() % StaticStats.WEAPON_STATS.size()
	var offStat = StaticStats.WEAPON_STATS.keys()[i]
	btnStat[btn] = StaticStats.WEAPON_STATS[offStat]
	btn.text = offenceUpgradeText[StaticStats.WEAPON_STATS[offStat]]

# Button Methods for toggling continue
func _on_upgrade_a_btn_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		$UpgradeBBtn.button_pressed = false
		$UpgradeCBtn.button_pressed = false
	SetContinueBtnState()
	
func _on_upgrade_b_btn_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		$UpgradeABtn.button_pressed = false
		$UpgradeCBtn.button_pressed = false
	SetContinueBtnState()
	
func _on_upgrade_c_btn_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		$UpgradeABtn.button_pressed = false
		$UpgradeBBtn.button_pressed = false
	SetContinueBtnState()

func SetContinueBtnState():
	if(DEBUG):
		print("Button States:", $UpgradeABtn.button_pressed, $UpgradeBBtn.button_pressed, $UpgradeCBtn.button_pressed)
		print("Button booleans:", upgradeA, upgradeB, upgradeC)
		print("Contiue should be disabled: ", !((upgradeA && !upgradeB && !upgradeC) || (!upgradeA && upgradeB && !upgradeC) || (!upgradeA && !upgradeB && upgradeC)))
	
	upgradeA = $UpgradeABtn.button_pressed
	upgradeB = $UpgradeBBtn.button_pressed
	upgradeC = $UpgradeCBtn.button_pressed
	
	$SelectAndContinue.disabled = !((upgradeA && !upgradeB && !upgradeC) || (!upgradeA && upgradeB && !upgradeC) || (!upgradeA && !upgradeB && upgradeC))



func _on_select_and_continue_button_up() -> void:
	# Process Upgrades
	if(upgradeA):
		StaticStats.SetPlayerStatModifier(btnStat[$UpgradeABtn])
	elif(upgradeB):
		StaticStats.SetPlayerWeaponStatModifier(btnStat[$UpgradeBBtn])
	
	pass # Replace with function body.

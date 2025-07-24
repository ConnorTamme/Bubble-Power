extends Node2D

var screen_size
var DEBUG = false
var statText: String
#const menu_update_wait_time = 0.1
#var remaining_till_menu_update = menu_update_wait_time

var defenceUpgradeText = {
	StaticStats.ENT_STATS.HEALTH : "MAX HEALTH++",
	StaticStats.ENT_STATS.MOVE_SPEED : "MOVE SPEED++",
	StaticStats.ENT_STATS.SHIELD : "SHIELD++",
	}
	
var offenceUpgradeText = {
	StaticStats.WEAPON_STATS.DAM : "WEAPON DAMAGE++",
	StaticStats.WEAPON_STATS.ATTACK_SPEED : "ATTACK SPEED++",
	StaticStats.WEAPON_STATS.RANGE : "RANGE++",
	StaticStats.WEAPON_STATS.PELLET_COUNT : "SHOT COUNT++",
	StaticStats.WEAPON_STATS.ACCURACY : "ACCURACY++",
	}

var upgradeA = false;
var upgradeB = false;
var upgradeC = false;
var btnStat = {}
var defStat = {}
var offStat = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	CycleUpgrades()
	ResetStatText()
	
func MenuMoveUp():
	if $UpgradeCBtn.button_pressed:
		$UpgradeABtn.button_pressed = false
		$UpgradeBBtn.button_pressed = true
		$UpgradeCBtn.button_pressed = false
	elif $UpgradeBBtn.button_pressed:
		$UpgradeABtn.button_pressed = true
		$UpgradeBBtn.button_pressed = false
		$UpgradeCBtn.button_pressed = false
	elif not $UpgradeABtn.button_pressed:
		$UpgradeABtn.button_pressed = false
		$UpgradeBBtn.button_pressed = false
		$UpgradeCBtn.button_pressed = true
	pass
	
func MenuMoveDown():
	if $UpgradeABtn.button_pressed:
		$UpgradeABtn.button_pressed = false
		$UpgradeBBtn.button_pressed = true
		$UpgradeCBtn.button_pressed = false
	elif $UpgradeBBtn.button_pressed:
		$UpgradeABtn.button_pressed = false
		$UpgradeBBtn.button_pressed = false
		$UpgradeCBtn.button_pressed = true
	elif not $UpgradeCBtn.button_pressed:
		$UpgradeABtn.button_pressed = true
		$UpgradeBBtn.button_pressed = false
		$UpgradeCBtn.button_pressed = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#remaining_till_menu_update -= delta
	#if remaining_till_menu_update <= 0.0:
	if Input.is_action_just_pressed("menu_up"):
		MenuMoveUp()
	if Input.is_action_just_pressed("menu_down"):
		MenuMoveDown()
		#remaining_till_menu_update = menu_update_wait_time
	if Input.is_action_pressed("controller_a"):
		if $UpgradeABtn.button_pressed or $UpgradeBBtn.button_pressed or $UpgradeCBtn.button_pressed:
			_on_select_and_continue_button_up()

func CycleUpgrades():
	# one should be defensive, one offensive
	GetDefenseUpgrade($UpgradeABtn)
	GetOffenseUpgrade($UpgradeBBtn)
	GetOffenseUpgrade($UpgradeCBtn)
	pass
	
func GetDefenseUpgrade(btn: Button):
	var i = randi() % StaticStats.ENT_STATS.size()
	while(i > 4):
		i = randi() % StaticStats.ENT_STATS.size()
	print(i)
	defStat[btn] = StaticStats.ENT_STATS.keys()[i]
	btnStat[btn] = StaticStats.ENT_STATS[defStat[btn]]

	btn.text = defenceUpgradeText[StaticStats.ENT_STATS[defStat[btn]]]

func GetOffenseUpgrade(btn: Button):
	var i = randi() % StaticStats.WEAPON_STATS.size()
	while(i > 4):
		i = randi() % StaticStats.WEAPON_STATS.size()
	offStat[btn] = StaticStats.WEAPON_STATS.keys()[i]
	btnStat[btn] = StaticStats.WEAPON_STATS[offStat[btn]]
	btn.text = offenceUpgradeText[btnStat[btn]]

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
	
	SetUpgradeText()
	
	$SelectAndContinue.disabled = !((upgradeA && !upgradeB && !upgradeC) || (!upgradeA && upgradeB && !upgradeC) || (!upgradeA && !upgradeB && upgradeC))

func GetTargetDefStats():
	return StaticStats.GetPlayerStatModifier(StaticStats.ENT_STATS[defStat[$UpgradeABtn]])

func GetTargetOffStats(btn: Button):
	return StaticStats.GetPlayerWeaponStatModifier(StaticStats.WEAPON_STATS[offStat[btn]])

func GetDefStatDelta(stat: StaticStats.ENT_STATS):
	return StaticStats.GetPlayerStatModifier(stat)

func GetOffStatDelta(stat: StaticStats.WEAPON_STATS):
	return StaticStats.GetPlayerWeaponStatModifier(stat)

func ResetStatText():
	$PlayerStatsContainer/Health/Sprite2D/Text.text = str(GetDefStatDelta(StaticStats.ENT_STATS.HEALTH))
	$PlayerStatsContainer/Shield/Sprite2D/Text.text = str(GetDefStatDelta(StaticStats.ENT_STATS.SHIELD))
	$PlayerStatsContainer/MoveSpeed/Sprite2D/Text.text = str(GetDefStatDelta(StaticStats.ENT_STATS.MOVE_SPEED))
	$WeaponStatsContainer/Damage/Sprite2D/Text.text = str(GetOffStatDelta(StaticStats.WEAPON_STATS.DAM))
	$WeaponStatsContainer/Range/Sprite2D/Text.text = str(GetOffStatDelta(StaticStats.WEAPON_STATS.RANGE))
	$WeaponStatsContainer/AttackSpeed/Sprite2D/Text.text = str(GetOffStatDelta(StaticStats.WEAPON_STATS.ATTACK_SPEED))
	$WeaponStatsContainer/ProjectileCount/Sprite2D/Text.text = str(GetOffStatDelta(StaticStats.WEAPON_STATS.PELLET_COUNT))
	$WeaponStatsContainer/Accuracy/Sprite2D/Text.text = str(GetOffStatDelta(StaticStats.WEAPON_STATS.ACCURACY))
	
func SetUpgradeText():
	ResetStatText()
	if(upgradeA):
		var target = str(GetTargetDefStats())
		target += " -> "
		target += str(GetTargetDefStats() + StaticStats.GetStatChangeDef(btnStat[$UpgradeABtn]))
		SetDefTextLbl(target)

	elif(upgradeB):
		var target = str(GetTargetOffStats($UpgradeBBtn))
		target += " -> "
		target += str(GetTargetOffStats($UpgradeBBtn) + StaticStats.GetStatChangeOff(btnStat[$UpgradeBBtn]))
		SetOffTextLbl($UpgradeBBtn, target)
	else:
		var target = str(GetTargetOffStats($UpgradeCBtn))
		target += " -> "
		target += str(GetTargetOffStats($UpgradeCBtn) + StaticStats.GetStatChangeOff(btnStat[$UpgradeCBtn]))
		SetOffTextLbl($UpgradeCBtn, target)


func SetDefTextLbl(text: String): 
	if($UpgradeABtn.text.contains("HEALTH")):
		$PlayerStatsContainer/Health/Sprite2D/Text.text = text
	elif($UpgradeABtn.text.contains("SHIELD")):
		$PlayerStatsContainer/Shield/Sprite2D/Text.text = text
	elif($UpgradeABtn.text.contains("SPEED")):
		$PlayerStatsContainer/MoveSpeed/Sprite2D/Text.text = text

func SetOffTextLbl(btn: Button, text: String): 
	if(btn.text.contains("DAMAGE")):
		$WeaponStatsContainer/Damage/Sprite2D/Text.text = text
	elif(btn.text.contains("RANGE")):
		$WeaponStatsContainer/Range/Sprite2D/Text.text = text
	elif(btn.text.contains("SPEED")):
		$WeaponStatsContainer/AttackSpeed/Sprite2D/Text.text = text
	elif(btn.text.contains("SHOT")):
		$WeaponStatsContainer/ProjectileCount/Sprite2D/Text.text = text
	elif(btn.text.contains("ACCUR")):
		$WeaponStatsContainer/Accuracy/Sprite2D/Text.text = text
	
func _on_select_and_continue_button_up() -> void:
	# Process Upgrades
	if(upgradeA):
		StaticStats.SetPlayerStatModifier(btnStat[$UpgradeABtn])
	elif(upgradeB):
		StaticStats.SetPlayerWeaponStatModifier(btnStat[$UpgradeBBtn])
	else:
		StaticStats.SetPlayerWeaponStatModifier(btnStat[$UpgradeCBtn])
	
	GlobalSignals.nextScene.emit()
	pass # Replace with function body.

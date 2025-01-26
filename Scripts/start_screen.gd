extends Node2D

@export var sceneToLoad: String 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title.text = "[center]%s[/center]" % $Title.text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_btn_button_down() -> void:
	get_tree().quit()

func _on_start_btn_button_down() -> void:
	print("Trying to load scene: ", sceneToLoad)
	get_tree().change_scene_to_file(sceneToLoad)
	

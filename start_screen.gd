extends Node2D

@export var sceneToLoad: String 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("controller_a"):
		get_tree().change_scene_to_file(sceneToLoad)
		Singleton.usingController = true
	if Input.is_action_pressed("controller_b"):
		get_tree().quit()
	
	
func _on_exit_btn_button_down() -> void:
	get_tree().quit()

func _on_start_btn_button_down() -> void:
	print("Trying to load scene: ", sceneToLoad)
	Singleton.usingController = false
	get_tree().change_scene_to_file(sceneToLoad)
	

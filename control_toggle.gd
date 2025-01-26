extends CheckButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Singleton.usingController):
		$Controller.visible = true
		$Mouse.visible = false
	else:
		$Controller.visible = false
		$Mouse.visible = true


func _on_toggled(toggled_on: bool) -> void:
	Singleton.usingController = 0 if toggled_on else 1

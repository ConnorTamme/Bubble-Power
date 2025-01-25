extends Node

var playerIsAlive = [true, true, false, false]
var playerWins = [0,0,0,0]

# Player Select needs to set this value when the game starts
var playerCount = 2


func _winner():
	print("We have a winner!")
	var survivorCount = 0;
	var survivor = 0
	for i in range(0,4):
		if(playerIsAlive[i]):
			survivorCount += 1
			survivor = i
	
	if(survivorCount == 1):
		print("Player ", str(survivor + 1), " wins!")
	else:
		print("No winner was decided.")
	pass

func _killPlayer(deadee: int):
	if(!playerIsAlive[deadee - 1]):
		print("But they're already dead...?")
	else:
		playerIsAlive[deadee - 1] = false;
		playerCount -= 1

func launch_game(playing, characters):
	playerCount = 0
	for i in range(0,4):
		playerIsAlive[i] = playing[i]
		if(playing[i]):
			playerCount += 1
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")

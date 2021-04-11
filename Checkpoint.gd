extends Area2D

onready var Timer = $"../CanvasLayer/UI/VBoxContainer/HBoxContainer/SpeedrunTimer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Checkpoint_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		if GlobalVariables.LevelNum == 10 and not GlobalVariables.checkpoint == 1:
			GlobalVariables.checkpoint = 1


func _on_Player_restartcheckpoint():
	if GlobalVariables.LevelNum == 10:
		if GlobalVariables.checkpoint == 1:
			$"../Player".position = position
			$"../Player".color = "red"
			$"../GreenColorOrb".state = true
	if GlobalVariables.speedrun:
		Timer.start()

extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D


func _enter_tree():
	GlobalVariables.LevelNum = 10
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Camera.current = true
	if GlobalVariables.checkpoint == 0:
		Player.color = "blue"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

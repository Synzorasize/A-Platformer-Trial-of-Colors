extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 21
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Camera.current = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

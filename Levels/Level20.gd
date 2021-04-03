extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 20
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Player.color = "green"
	Camera.current = true
	Camera.limit_top = -GlobalVariables.screensize.y / 4
	Camera.limit_bottom = GlobalVariables.screensize.y
	Camera.limit_right = GlobalVariables.screensize.x + (GlobalVariables.screensize.x / 12)
	Camera.limit_left = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

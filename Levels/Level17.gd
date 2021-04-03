extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 17
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	GlobalVariables.disable("switch", self)
	GlobalVariables.disable("switch1", self)
	GlobalVariables.disable("switch2", self)
	Camera.current = true
	Camera.limit_top = -GlobalVariables.screensize.y / 4
	Camera.limit_bottom = GlobalVariables.screensize.y
	Camera.limit_right = GlobalVariables.screensize.x
	Camera.limit_left = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Switch_switchon():
	GlobalVariables.enable("switch", self)
	Player.position = Vector2(384,336)


func _on_Switch_switchoff():
	GlobalVariables.disable("switch", self)
	Player.position = Vector2(384,336)


func _on_Switch0_switchon():
	Player.color = "red"


func _on_Switch1_switchon():
	GlobalVariables.enable("switch1", self)

func _on_Switch1_switchoff():
	GlobalVariables.disable("switch1", self)


func _on_Switch2_switchoff():
	GlobalVariables.disable("switch2", self)
	GlobalVariables.enable("switch2off", self)

func _on_Switch2_switchon():
	GlobalVariables.enable("switch2", self)
	GlobalVariables.disable("switch2off", self)

extends Node2D

onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 9
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	GlobalVariables.disable("switch", self)
	Camera.current = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Switch0_switchoff():
	GlobalVariables.disable("switch", self)


func _on_Switch0_switchon():
	GlobalVariables.enable("switch", self)

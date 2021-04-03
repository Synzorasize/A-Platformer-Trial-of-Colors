extends Node2D


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 8
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	GlobalVariables.disable("switch", self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Switch0_switchoff():
	GlobalVariables.disable("switch", self)


func _on_Switch0_switchon():
	GlobalVariables.enable("switch", self)

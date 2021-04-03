extends Node2D




# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 5
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true

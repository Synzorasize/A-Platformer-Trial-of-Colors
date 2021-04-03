extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 3
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

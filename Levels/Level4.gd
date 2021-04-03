extends Node2D


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 4
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	$Player.color = "blue"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

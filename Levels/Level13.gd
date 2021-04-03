extends Node2D


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 13
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	GlobalVariables.disable("Switch0", self)
	GlobalVariables.disable("Switch1", self)
	GlobalVariables.disable("Switch2", self)
	GlobalVariables.disable("Switch3", self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Player_restart():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Switch0_switchon():
	GlobalVariables.enable("Switch0", self)


func _on_Switch0_switchoff():
	GlobalVariables.disable("Switch0", self)


func _on_Switch1_switchoff():
	GlobalVariables.disable("Switch1", self)


func _on_Switch1_switchon():
	GlobalVariables.enable("Switch1", self)


func _on_Switch2_switchoff():
	GlobalVariables.disable("Switch2", self)


func _on_Switch2_switchon():
	GlobalVariables.enable("Switch2", self)


func _on_Switch3_switchoff():
	GlobalVariables.disable("Switch3", self)


func _on_Switch3_switchon():
	GlobalVariables.enable("Switch3", self)


func _on_Switch4_switchoff():
	GlobalVariables.enable("Switch4", self)


func _on_Switch4_switchon():
	GlobalVariables.disable("Switch4", self)

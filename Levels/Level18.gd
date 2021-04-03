extends Node2D

onready var Player = $Player

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 18
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	GlobalVariables.disable("switch", self)
	GlobalVariables.disable("switch0", self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Switch_switchon():
	GlobalVariables.enable("switch", self)
	GlobalVariables.replace_switch("switchswitch", "Blue", self, "0")
	Player.color = "blue"


func _on_Switch0_switchon():
	GlobalVariables.disable("switch", self)
	GlobalVariables.replace_switch("switchswitch", "Red", self, "")
	Player.color = "red"


func _on_Switch1_switchon():
	GlobalVariables.enable("switch0", self)
	Player.color = "green"


func _on_Switch2_switchon():
	GlobalVariables.replace("switch1", "Tilecostumes/Bluetile", self, true)
	Player.color = "blue"

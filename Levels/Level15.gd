extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 15
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Camera.current = true
	Camera.limit_top = -GlobalVariables.screensize.y / 4
	Camera.limit_bottom = GlobalVariables.screensize.y
	GlobalVariables.disable("switch", self)
	GlobalVariables.disable("switch0", self)
	GlobalVariables.disable("switch1", self)
	GlobalVariables.disable("switch2", self)
	GlobalVariables.disable("switch5", self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Switch_switchon():
	GlobalVariables.enable("switch", self)
	GlobalVariables.disable("switchon", self)


func _on_Switch_switchoff():
	GlobalVariables.disable("switch", self)
	GlobalVariables.enable("switchon", self)

func _on_Switch0_switchon():
	GlobalVariables.enable("switch0", self)

func _on_Switch0_switchoff():
	GlobalVariables.disable("switch0", self)

func _on_Switch1_switchon():
	GlobalVariables.replace_switch("greenswitch", "Red", self, "2")
	GlobalVariables.enable("switch1", self)

func _on_Switch2_switchon():
	GlobalVariables.replace_switch("greenswitch", "Green", self, "1")
	GlobalVariables.enable("switch2", self)


func _on_Switch3_switchon():
	GlobalVariables.replace_switch("switch3", "Red", self, "4")
	Player.color = "red"

func _on_Switch4_switchon():
	GlobalVariables.replace_switch("switch3", "Blue", self, "3")
	Player.color = "blue"


func _on_Switch5_switchon():
	GlobalVariables.enable("switch5", self)


func _on_Switch5_switchoff():
	GlobalVariables.disable("switch5", self)

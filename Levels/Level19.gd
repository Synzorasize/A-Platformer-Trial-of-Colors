extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 19
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Player.color = "blue"
	GlobalVariables.disable("switch1", self)
	GlobalVariables.disable("switch2", self)
	GlobalVariables.disable("switch3", self)
	Camera.current = true
	Camera.limit_top = -GlobalVariables.screensize.y / 4
	Camera.limit_bottom = GlobalVariables.screensize.y
	Camera.limit_right = GlobalVariables.screensize.x + (GlobalVariables.screensize.x / 12)
	Camera.limit_left = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Switch_switchon():
	Player.color = "red"
	GlobalVariables.replace_switch("switchswitch", "Red", self, "0")
	GlobalVariables.replace("switch0", "Tilecostumes/Bluetile", self, true)

func _on_Switch0_switchon():
	Player.color = "green"
	GlobalVariables.replace_switch("switchswitch", "Green", self, "1")
	GlobalVariables.replace("switch0", "Tilecostumes/Redtile", self, true)

func _on_Switch1_switchon():
	Player.color = "blue"
	GlobalVariables.replace_switch("switchswitch", "Blue", self, "")
	GlobalVariables.replace("switch0", "Tilecostumes/Greentile", self, true)


func _on_Switch2_switchon():
	GlobalVariables.enable("switch1", self)


func _on_Switch2_switchoff():
	GlobalVariables.disable("switch1", self)


func _on_Switch3_switchon():
	GlobalVariables.replace_switch("selfswitch", "Blue", self, "4")
	Player.color = "blue"
	GlobalVariables.enable("switch2", self)


func _on_Switch4_switchon():
	GlobalVariables.replace_switch("selfswitch", "Red", self, "3")
	Player.color = "red"


func _on_Switch5_switchoff():
	GlobalVariables.disable("switch3", self)


func _on_Switch5_switchon():
	GlobalVariables.enable("switch3", self)


func _on_Switch6_switchon():
	GlobalVariables.disable("switch", self)


func _on_Switch6_switchoff():
	GlobalVariables.enable("switch", self)

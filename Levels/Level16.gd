extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 16
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	GlobalVariables.disable("switch5", self)
	GlobalVariables.disable("switch4", self)
	GlobalVariables.disable("switch", self)
	GlobalVariables.disable("switch10", self)
	Camera.current = true
	Camera.limit_top = -GlobalVariables.screensize.y / 4
	Camera.limit_bottom = GlobalVariables.screensize.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Switch_switchon():
	GlobalVariables.enable("switch", self)


func _on_Switch_switchoff():
	GlobalVariables.disable("switch", self)


func _on_Switch0_switchoff():
	Player.color = "green"


func _on_Switch0_switchon():
	Player.color = "blue"


func _on_Switch1_switchon():
	Player.color = "green"


func _on_Switch1_switchoff():
	Player.color = "red"


func _on_Switch2_switchon():
	GlobalVariables.replace("switch2", "Tilecostumes/Greentile", self, true)


func _on_Switch2_switchoff():
	GlobalVariables.replace("switch2", "Tilecostumes/Bluetile", self, true)


func _on_Switch3_switchon():
	GlobalVariables.replace_switch("switch3", "Green", self, "1")
	GlobalVariables.replace_switch("switch3on", "Green", self, "2")


func _on_Switch3_switchoff():
	GlobalVariables.replace_switch("switch3", "Red", self, "1")
	GlobalVariables.replace_switch("switch3on", "Red", self, "2")


func _on_Switch4_switchoff():
	GlobalVariables.disable("switch4", self)


func _on_Switch4_switchon():
	GlobalVariables.enable("switch4", self)


func _on_Switch5_switchoff():
	GlobalVariables.disable("switch5", self)


func _on_Switch5_switchon():
	GlobalVariables.enable("switch5", self)


func _on_Switch6_switchoff():
	GlobalVariables.replace("switch6", "Tilecostumes/Redtile", self, true)


func _on_Switch6_switchon():
	GlobalVariables.replace("switch6", "Tilecostumes/Bluetile", self, true)


func _on_Switch7_switchon():
	Player.color = "red"
	GlobalVariables.replace_switch("switch7", "Red", self, "8")


func _on_Switch8_switchon():
	Player.color = "blue"
	GlobalVariables.replace_switch("switch7", "Blue", self, "7")


func _on_Switch9_switchon():
	GlobalVariables.replace_switch("switch9", "Red", self, "10")
	GlobalVariables.enable("switch10", self)


func _on_Switch10_switchon():
	GlobalVariables.replace_switch("switch9", "Blue", self, "9")
	GlobalVariables.replace_teleporter("switch11", "Red", self, "nonGroup")


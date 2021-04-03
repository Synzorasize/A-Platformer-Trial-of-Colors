extends Node2D

onready var Player = $Player
onready var Camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 12
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Camera.current = true
	Camera.limit_top = -GlobalVariables.screensize.y / 16
	Camera.limit_bottom = GlobalVariables.screensize.y
	Camera.drag_margin_top = 1
	Camera.drag_margin_bottom = 1
	Player.color = "green"
	GlobalVariables.disable("Switch0", self)
	GlobalVariables.disable("Switch1", self)
	GlobalVariables.enable("Switch2", self)
	GlobalVariables.enable("Switch3", self)
	GlobalVariables.disable("Switch3on", self)
	GlobalVariables.disable("Switch4", self)
	GlobalVariables.disable("Switch5", self)
	GlobalVariables.disable("Switch6", self)
	GlobalVariables.disable("Switch8", self)
	GlobalVariables.enable("Switch8off", self)
	GlobalVariables.disable("Switch11on", self)
	GlobalVariables.disable("Switch9", self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Switch0_switchoff():
	GlobalVariables.disable("Switch0", self)

func _on_Switch0_switchon():
	GlobalVariables.enable("Switch0", self)

func _on_Switch1_switchoff():
	GlobalVariables.disable("Switch1", self)


func _on_Switch1_switchon():
	GlobalVariables.enable("Switch1", self)


func _on_Switch2_switchoff():
	GlobalVariables.enable("Switch2", self)

func _on_Switch2_switchon():
	GlobalVariables.disable("Switch2", self)


func _on_Switch3_switchon():
	GlobalVariables.replace("Switch3", "Hazards/RedHazard", self, true)
	GlobalVariables.enable("Switch3on", self)

func _on_Switch3_switchoff():
	GlobalVariables.replace("Switch3", "Tilecostumes/Tile", self, false)
	if Player.position.y > 296 and Player.position.y < 328:
		Player.position.y = 296
	GlobalVariables.disable("Switch3on", self)


func _on_Switch4_switchon():
	GlobalVariables.replace("Switch3", "Hazards/RedHazard", self, true)
	GlobalVariables.enable("Switch3on", self)
	GlobalVariables.enable("Switch4", self)


func _on_Switch4_switchoff():
	GlobalVariables.replace("Switch3", "Tilecostumes/Tile", self, false)
	GlobalVariables.disable("Switch3on", self)
	GlobalVariables.disable("Switch4", self)


func _on_Switch5_switchoff():
	GlobalVariables.enable("Switch5", self)


func _on_Switch5_switchon():
	GlobalVariables.disable("Switch5", self)


func _on_Switch6_switchoff():
	GlobalVariables.disable("Switch6", self)


func _on_Switch6_switchon():
	GlobalVariables.enable("Switch6", self)


func _on_Switch7_switchoff():
	GlobalVariables.replace("Switch7", "Tilecostumes/Tile", self, false)


func _on_Switch7_switchon():
	GlobalVariables.replace("Switch7", "Tilecostumes/Greentile", self, true)


func _on_Switch8_switchoff():
	GlobalVariables.disable("Switch8", self)
	GlobalVariables.enable("Switch8off", self)
	GlobalVariables.disable("Switch11on", self)
	GlobalVariables.replace("Switch11", "Tilecostumes/Bluetile", self, true)

func _on_Switch8_switchon():
	GlobalVariables.enable("Switch8", self)
	GlobalVariables.disable("Switch8off", self)
	GlobalVariables.enable("Switch11on", self)
	GlobalVariables.replace("Switch11", "Tilecostumes/Greentile", self, true)

func _on_Switch9_switchoff():
	GlobalVariables.disable("Switch9", self)


func _on_Switch9_switchon():
	GlobalVariables.enable("Switch9", self)

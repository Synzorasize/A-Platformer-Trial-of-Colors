extends Level

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 19
	#if GlobalVariables.restart == false:
	#	get_tree().reload_current_scene()
	#	GlobalVariables.restart = true
func _ready():
	Player.color = "blue"
	disable("switch1")
	disable("switch2")
	disable("switch3")
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
	replace_switch("switchswitch", "Red")
	replace("switch0", "Tilecostumes/Bluetile")

func _on_Switch0_switchon():
	Player.color = "green"
	replace_switch("switchswitch", "Green")
	replace("switch0", "Tilecostumes/Redtile")

func _on_Switch1_switchon():
	Player.color = "blue"
	replace_switch("switchswitch", "Blue")
	replace("switch0", "Tilecostumes/Greentile")


func _on_Switch2_switchon():
	enable("switch1")


func _on_Switch2_switchoff():
	disable("switch1")


func _on_Switch3_switchon():
	replace_switch("selfswitch", "Blue")
	Player.color = "blue"
	enable("switch2")


func _on_Switch4_switchon():
	replace_switch("selfswitch", "Red")
	Player.color = "red"


func _on_Switch5_switchoff():
	disable("switch3")


func _on_Switch5_switchon():
	enable("switch3")


func _on_Switch6_switchon():
	disable("switch")


func _on_Switch6_switchoff():
	enable("switch")

extends Level

func _process(_delta):
	if Player.color == "red":
		GlobalVariables.enable("switch4", self)
	else:
		GlobalVariables.disable("switch4", self)


func _on_Switch_switchon():
	GlobalVariables.replace_teleporter("switch", "Blue", self, "nonGroup")
	GlobalVariables.replace_switch("switch0", "Green", self, "0")
	GlobalVariables.replace("switch1", "ColorOrbs/GreenColorOrb", self, false)
	GlobalVariables.enable("switch2", self)

func _on_Switch0_switchon():
	GlobalVariables.replace_teleporter("switch", "Green", self, "nonGroup")
	GlobalVariables.replace_switch("switch0", "Blue", self, "")
	GlobalVariables.replace("switch1", "ColorOrbs/BlueColorOrb", self, false)
	GlobalVariables.disable("switch2", self)


func _on_Switch1_switchoff():
	GlobalVariables.replace_teleporter("switch", "Blue", self, "nonGroup")
	GlobalVariables.replace("switch3", "Tilecostumes/Redtile", self, true)

func _on_Switch1_switchon():
	GlobalVariables.replace_teleporter("switch", "Red", self, "nonGroup")
	GlobalVariables.replace("switch3", "Tilecostumes/Bluetile", self, true)

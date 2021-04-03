extends Control

var level_loaded
var levels_loaded = [preload("res://Levels/Level1.tscn"), preload("res://Levels/Level2.tscn"), preload("res://Levels/Level3.tscn"), preload("res://Levels/Level4.tscn"), preload("res://Levels/Level5.tscn"), preload("res://Levels/Level6.tscn"), preload("res://Levels/Level7.tscn"), preload("res://Levels/Level8.tscn"), preload("res://Levels/Level9.tscn"), preload("res://Levels/Level10.tscn"), preload("res://Levels/Level11.tscn"), preload("res://Levels/Level12.tscn"), preload("res://Levels/Level13.tscn"), preload("res://Levels/Level14.tscn"), preload("res://Levels/Level15.tscn"), preload("res://Levels/Level16.tscn"), preload("res://Levels/Level17.tscn"), preload("res://Levels/Level18.tscn"), preload("res://Levels/Level19.tscn"), preload("res://Levels/Level20.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready():
	create_LevelButtons()
	if GlobalVariables.speedrun == true:
		$HBoxContainer/Title.text = "Speedrun Level"
	else:
		$HBoxContainer/Title.text = "Level Select"


func create_LevelButtons():
	var check_LevelButtons : int = 1
	var LevelButton = $GridContainer/Level1.duplicate()
	$GridContainer/Level1.connect("mouse_entered", self, "_on_LevelButton_hovered", ["Level1"])
	while not $GridContainer.get_child_count() == 20:
		$GridContainer.add_child(LevelButton, true)
		LevelButton.text = str(check_LevelButtons + 1)
		LevelButton.connect("mouse_entered", self, "_on_LevelButton_hovered", [LevelButton.name])
		if check_LevelButtons < GlobalVariables.max_LevelNum:
			LevelButton.disabled = false
		else:
			LevelButton.disabled = true
		LevelButton = $GridContainer/Level1.duplicate()
		check_LevelButtons += 1


func _on_LevelButton_pressed():
	get_tree().change_scene_to(level_loaded)



func _on_BackButton_pressed():
	get_tree().change_scene("res://Levels/Title screen.tscn")


func _on_LevelButton_hovered(sender):
	level_loaded = levels_loaded[levels_loaded.find(load("res://Levels/" + sender + ".tscn"))]

extends Control


const first_text = "If the character is red you can go through red things and stand on other-colored things respectively. Same goes for blue and green.\nThere are tiles, orbs, hazards, teleporters and switches. Tiles are what the player stands on. If they are a colored tile, the character has to be the same color as it to go through it. Same goes for hazards, and with teleporters and switches, you need to be the same color to interact with it. Orbs change your color and can only be used once. Hazards will kill the player and teleporters teleport the player back and forth from each teleporter. Switches can activate/deactivate items in levels."
const second_text = "There are checkpoints which are exclamation marks. They are universal and don't need a color to touch. Checkpoints revert the scene to when you first touched it. Press R to restart. Restarting manually with a checkpoint resets you to the beginning.\nThere is also speedrun mode for competitive people. Respawning from checkpoints, however, sets the time back to when you first got that checkpoint and doesn't necessarily reset or keep going.\nThe level editor is very basic for now, but you can create levels and play them. Use 'shift' to make smaller increments. Hold the item and press 'backspace' or 'delete' to delete something."
const third_text = "Press 'left' and 'right' to move the area around and 'Camera' to toggle the camera on and off. You can choose a color for an item you can create by clicking on the color buttons. You can't change the color of something that is already created. Clicking on 'Player' will change the color of the player. Of course, the 'Orb', 'Hazard', and 'Player' will be disabled when you choose 'white'.\nYou can also only have one exit. You can't delete the player, though, of course. You can also move things around by holding them."
const fourth_text = "You can also save the levels and load them back by entering the level name (which can be set by the 'Rename' Button). Note that while saving a level, if it has the same name as an already saved level, it will override it."
onready var Container = $Panel2/VSplitContainer
onready var Instructions = $Panel/Body
onready var Previous = $Panel/PreviousButton
onready var Previous1 = $Panel2/PreviousStats
onready var Next1 = $Panel2/NextStats
onready var Next = $Panel/NextButton
onready var Panel = $Panel
onready var Panel2 = $Panel2
onready var Panel3 = $Panel3
onready var Panel4 = $Panel4
var speedrun_pages : int = 1
var instruction_pages : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.editor = false
	Panel.hide()
	Panel2.hide()
	Panel3.hide()
	Previous.hide()
	VisualServer.set_default_clear_color(Color(0.682,0.682,0.682,1.0))
	GlobalVariables.saveSettings()
	GlobalVariables.loadGame()
	if GlobalVariables.BGcolors_off:
		$Panel3/VSplitContainer/CheckButtonBGcolorsOff.pressed = true
	if GlobalVariables.colorblind_mode:
		$Panel3/VSplitContainer/CheckButtonColorblindMode.pressed = true
	if GlobalVariables.ButtonColors_off:
		$Panel3/VSplitContainer/CheckButtonButtonColorsOff.pressed = true
	if BGmusic.stream_paused:
		$Panel3/VSplitContainer/CheckButtonMuteSound.pressed = true
	if not GlobalVariables.max_LevelNum == null:
		GlobalVariables.max_LevelNum = GlobalVariables.userdata.levels_unlocked
	create_SpeedrunStats(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGame_pressed():
	get_tree().change_scene_to(preload("res://Levels/Level screen.tscn"))
	GlobalVariables.speedrun = false


func _on_Instructions_pressed():
	Panel.show()


func _on_CloseButton_pressed():
	Panel.hide()
	Panel2.hide()
	Panel3.hide()
	Panel4.hide()


func _on_SpeedrunMode_pressed():
	get_tree().change_scene_to(preload("res://Levels/Level screen.tscn"))
	GlobalVariables.speedrun = true


func _on_NextButton_pressed():
	if instruction_pages == 3:
		instruction_pages = 4
		Instructions.text = fourth_text
		Next.hide()
	elif instruction_pages == 2:
		instruction_pages = 3
		Instructions.text = third_text
	elif instruction_pages == 1:
		instruction_pages = 2
		Instructions.text = second_text
		Previous.show()


func _on_PreviousButton_pressed():
	if instruction_pages == 4:
		instruction_pages = 3
		Instructions.text = third_text
		Next.show()
	elif instruction_pages == 3:
		instruction_pages = 2
		Instructions.text = second_text
	elif instruction_pages == 2:
		instruction_pages = 1
		Instructions.text = first_text
		Previous.hide()

func _on_SpeedrunStats_pressed():
	Panel2.show()

func _on_PreviousStats_pressed():
	if speedrun_pages == 3:
		create_SpeedrunStats(8)
		speedrun_pages = 2
		Next1.show()
	elif speedrun_pages == 2:
		create_SpeedrunStats(1)
		speedrun_pages = 1
		Previous1.hide()

func _on_NextStats_pressed():
	if speedrun_pages == 1:
		create_SpeedrunStats(8)
		speedrun_pages = 2
		Previous1.show()
	elif speedrun_pages == 2:
		create_SpeedrunStats(14)
		speedrun_pages = 3
		Next1.hide()

func create_SpeedrunStats(levels):
	for counter in range(7):
		if GlobalVariables.userdata.speedrun_times.has("Level" + str(counter + levels)):
			Container.get_child(counter).text = "Level " + str(counter + levels) + ": " + str(GlobalVariables.userdata.speedrun_times["Level" + str(counter + levels)])
		else:
			Container.get_child(counter).text = "Level " + str(counter + levels) + ": N/A"


func _on_Settings_pressed():
	Panel3.show()


func _on_CheckButtonColorblindMode_toggled(button_pressed):
	if button_pressed:
		GlobalVariables.colorblind_mode = true
	elif button_pressed == false:
		GlobalVariables.colorblind_mode = false
	GlobalVariables.saveSettings()


func _on_CheckButtonBGcolorsOff_toggled(button_pressed):
	if button_pressed:
		GlobalVariables.BGcolors_off = true
	elif button_pressed == false:
		GlobalVariables.BGcolors_off = false
	GlobalVariables.saveSettings()


func _on_CheckButtonButtonColorsOff_toggled(button_pressed):
	if button_pressed:
		GlobalVariables.ButtonColors_off = true
	elif button_pressed == false:
		GlobalVariables.ButtonColors_off = false
	GlobalVariables.saveSettings()


func _on_LevelEditor_pressed():
	get_tree().change_scene_to(preload("res://Levels/Level Player.tscn"))


func _on_CheckButtonMuteSound_toggled(button_pressed):
	if button_pressed:
		BGmusic.stream_paused = true
	elif button_pressed == false:
		BGmusic.stream_paused = false
	GlobalVariables.saveSettings()


func _on_SavedLevels_pressed():
	GlobalVariables.userdata.saved_levels
	Panel4.show()

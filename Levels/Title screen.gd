extends Control


const first_text = "If the character is red you can go through red things and stand on other-colored things respectively. Same goes for blue and green.\nThere are tiles, orbs, hazards, teleporters and switches. Tiles are what the player stands on. If they are a colored tile, the character has to be the same color as it to go through it. Same goes for hazards, and with teleporters and switches, you need to be the same color to interact with it. Orbs change your color and can only be used once. Hazards will kill the player and teleporters teleport the player back and forth from each teleporter. Switches can activate/deactivate items in levels."
const second_text = "There are checkpoints which are exclamation marks. They are universal and don't need a color to touch. Checkpoints revert the scene to when you first touched it. Press R to restart. Restarting manually with a checkpoint resets you to the beginning.\nThere is also speedrun mode for competitive people. Respawning from checkpoints, however, sets the time back to when you first got that checkpoint and doesn't necessarily reset or keep going.\nThe level editor is very basic for now, but you can create levels and play them. Use 'shift' to make smaller increments. You can also move things around by holding them."
const third_text = "Hold the item and press 'backspace' or 'delete' to delete something. You can't delete the player, though, of course. Press 'left' and 'right' to move the area around and 'Camera' to toggle the camera on and off. You can choose a color for an item you can create by clicking on the color buttons. You can't change the color of something that is already created. Clicking on 'Player' will change the color of the player. Of course, the 'Orb', 'Hazard', and 'Player' will be disabled when you choose 'white'. You can only have one exit. You can also save the levels and load them back by entering the level name (which can be set by the 'Rename' Button)."
const fourth_text = "Note that while saving a level, if it has the same name as an already saved level, it will override it. To use the teleporter, just add it and press space while hovering over it. Then it will show you "
const instruction_text = ["Instructions", first_text, second_text, third_text, fourth_text]
onready var Panel = $Panel
onready var Panel2 = $Panel2
onready var Panel3 = $Panel3
onready var Panel4 = $Panel4
onready var Container = Panel2.get_node("VSplitContainer")
onready var Instructions = Panel.get_node("Body")
onready var Previous = Panel.get_node("PreviousButton")
onready var Previous1 = Panel2.get_node("PreviousStats")
onready var Next2 = Panel4.get_node("Next")
onready var Previous2 = Panel4.get_node("Previous")
onready var Next1 = Panel2.get_node("NextStats")
onready var Next = Panel.get_node("NextButton")
onready var VSplit = Panel4.get_node("VSplitContainer")
onready var row = VSplit.get_node("LevelRow1")
onready var Settings = Panel3.get_node("VSplitContainer")
onready var RowContainer = Panel4.get_node("VSplitContainer")
onready var ConfirmPanel = Panel4.get_node("ConfirmPanel")
onready var CopyPanel = Panel4.get_node("CopyPanel")
onready var CopyText = CopyPanel.get_node("LineEdit")
onready var PastePanel = Panel4.get_node("PastePanel")
onready var PasteText = PastePanel.get_node("LineEdit")
onready var Yes = ConfirmPanel.get_node("Yes")
var speedrun_pages : int = 1
var instruction_pages : int = 1
var saved_level_pages : int = 1
var set_up_levels : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#LoadingScreen.hide()
	GlobalVariables.editor = false
	Panel.hide()
	Panel2.hide()
	Panel3.hide()
	Panel4.hide()
	Previous.hide()
	Previous1.hide()
	if not HH.get_sibling("BGTexture", self, false) == null:
		HH.get_sibling("BGTexture", self).get_node("BG").hide()
	GlobalVariables.loadGame()
	GlobalVariables.saveSettings()
	checkBox(GlobalVariables.BGcolors_off, "BGcolorsOff")
	checkBox(GlobalVariables.colorblind_mode, "ColorblindMode")
	checkBox(GlobalVariables.ButtonColors_off, "ButtonColorsOff")
	checkBox(BGmusic.stream_paused, "MuteSound")
	checkBox(GlobalVariables.delayDeath_off, "DelayDeathOff")
	checkBox(GlobalVariables.coordinateLabel_off, "CoordinateLabelOff")
	if not GlobalVariables.max_LevelNum == null:
		GlobalVariables.max_LevelNum = GlobalVariables.userdata.levels_unlocked
	create_SpeedrunStats(1)

func checkBox(cond, checkBox):
	Settings.get_node("CheckButton" + checkBox).pressed = cond

func _on_StartGame_pressed():
	get_tree().change_scene_to(preload("res://Levels/Level screen.tscn"))
	GlobalVariables.speedrun = false


func _on_Instructions_pressed():
	Panel.show()
#	var file = File.new()
#	file.open("res://Art/UI/instructions.json", file.WRITE)
#	instruction_text = parse_json(file.get_as_text()).pages

func _on_CloseButton_pressed():
	Panel.hide()
	Panel2.hide()
	Panel3.hide()
	Panel4.hide()
	ConfirmPanel.hide()
	CopyPanel.hide()

func _on_SpeedrunMode_pressed():
	get_tree().change_scene_to(preload("res://Levels/Level screen.tscn"))
	GlobalVariables.speedrun = true

func page_checker(next : bool = true, max_pages : int = 4, type : String = "instructions"):
	if type == "instructions":
		if next:
			instruction_pages += 1
			if instruction_pages == max_pages:
				Next.hide()
			elif instruction_pages == 2:
				Previous.show()
		else:
			instruction_pages -= 1
			if instruction_pages == 1:
				Previous.hide()
			elif instruction_pages == max_pages - 1:
				Next.show()
		Instructions.text = instruction_text[instruction_pages]
	elif type == "speedrun":
		if next:
			speedrun_pages += 1
			if speedrun_pages == max_pages:
				Next1.hide()
			elif speedrun_pages == 2:
				Previous1.show()
		else:
			speedrun_pages -= 1
			if speedrun_pages == 1:
				Previous1.hide()
			elif speedrun_pages == max_pages - 1:
				Next1.show()
		create_SpeedrunStats(1+(7*(speedrun_pages-1)))
	elif type == "saved_levels":
		if next:
			saved_level_pages += 1
			if saved_level_pages == max_pages:
				Next2.hide()
			elif saved_level_pages == 2:
				Previous2.show()
		else:
			saved_level_pages -= 1
			if saved_level_pages == 1:
				Previous2.hide()
			elif saved_level_pages == max_pages - 1:
				Next2.show()
		for i in RowContainer.get_children():
			i.hide()
			print(saved_level_pages*6-5)
			print(i.get_index())
			print(saved_level_pages*6+1)
			if i.get_index() < saved_level_pages*6+1 and i.get_index() > saved_level_pages*6-5:
				i.show()

func _on_NextButton_pressed():
	page_checker()

func _on_PreviousButton_pressed():
	page_checker(false)

func _on_SpeedrunStats_pressed():
	Panel2.show()

func _on_PreviousStats_pressed():
	page_checker(false, 3, "speedrun")

func _on_NextStats_pressed():
	page_checker(true, 3, "speedrun")

func create_SpeedrunStats(levels):
	for counter in range(7):
		if GlobalVariables.userdata.speedrun_times.has("Level" + str(counter + levels)):
			Container.get_child(counter).text = "Level " + str(counter + levels) + ": " + str(GlobalVariables.userdata.speedrun_times["Level" + str(counter + levels)])
		else:
			Container.get_child(counter).text = "Level " + str(counter + levels) + ": N/A"


func _on_Settings_pressed():
	Panel3.show()


func _on_CheckButtonColorblindMode_toggled(button_pressed):
	GlobalVariables.colorblind_mode = button_pressed
	GlobalVariables.saveSettings()


func _on_CheckButtonBGcolorsOff_toggled(button_pressed):
	GlobalVariables.BGcolors_off = button_pressed
	GlobalVariables.saveSettings()


func _on_CheckButtonButtonColorsOff_toggled(button_pressed):
	GlobalVariables.ButtonColors_off = button_pressed
	GlobalVariables.saveSettings()


func _on_LevelEditor_pressed():
	get_tree().change_scene_to(preload("res://Levels/Level Player.tscn"))


func _on_CheckButtonMuteSound_toggled(button_pressed):
	BGmusic.stream_paused = button_pressed
	GlobalVariables.saveSettings()



func _on_SavedLevels_pressed():
	if not set_up_levels:
		row.get_node("Label").text = GlobalVariables.userdata.saved_levels[0].level_name
		row.get_node("DeleteButton").connect("pressed", self, "_on_DeleteButton_pressed", [1, row.get_node("Label").text])
		row.get_node("EditButton").connect("pressed", self, "_on_EditButton_pressed", [row.get_node("Label").text])
		row.get_node("CopyButton").connect("pressed", self, "_on_CopyButton_pressed", [1])
		for i in range(GlobalVariables.userdata.saved_levels.size()):
			if not i == 0:
				row = row.duplicate()
				row.name = "LevelRow"+str(i+1)
				VSplit.add_child(row)
				row.get_node("Label").text = GlobalVariables.userdata.saved_levels[i].level_name
				row.get_node("DeleteButton").connect("pressed", self, "_on_DeleteButton_pressed", [i, row.get_node("Label").text])
				row.get_node("EditButton").connect("pressed", self, "_on_EditButton_pressed", [row.get_node("Label").text])
				row.get_node("CopyButton").connect("pressed", self, "_on_CopyButton_pressed", [i])
				row.visible = i < 6
			else:
				continue
		set_up_levels = true
	Panel4.show()


func _on_CopyButton_pressed(i):
	CopyText.text = to_json(GlobalVariables.userdata.saved_levels[i])
	CopyPanel.show()
	
func _on_EditButton_pressed(level_name):
	GlobalVariables.level_name_edit = level_name
	GlobalVariables.editor_edit = true
	get_tree().change_scene("res://Levels/Level Player.tscn")
#	LvlEdtr.LoadButton.emit_signal("pressed")

func _on_DeleteButton_pressed(id,level_name):
	if ConfirmPanel.is_visible():
		VSplit.get_node("LevelRow"+str(id+1)).queue_free()
		ConfirmPanel.hide()
		GlobalVariables.userdata.saved_levels.remove(id)
		GlobalVariables.saveGame()
	else:
		ConfirmPanel.show()
		Yes.connect("pressed", self, "_on_DeleteButton_pressed", [id,level_name], CONNECT_ONESHOT)


func _on_CheckButtonDelayDeathOff_toggled(button_pressed):
	GlobalVariables.delayDeath_off = button_pressed
	GlobalVariables.saveSettings()

func _on_CheckButtonCoordinateLabelOff_toggled(button_pressed):
	GlobalVariables.coordinateLabel_off = button_pressed
	GlobalVariables.saveSettings()


func _on_ImportButton_pressed():
	PastePanel.show()
	PasteText.text = ""

func _on_EnterButton_pressed():
	PastePanel.hide()
	if not PasteText.text.empty():
		var x = JSON.parse(PasteText.text)
		if x.error == OK:
			GlobalVariables.userdata.saved_levels.append(x.result)
			GlobalVariables.saveGame()
		else:
			printerr("Invalid text.")


func _on_Next_pressed():
	page_checker(true,ceil(RowContainer.get_child_count()/6),"saved_levels")


func _on_Previous_pressed():
	page_checker(false,ceil(RowContainer.get_child_count()/6),"saved_levels")

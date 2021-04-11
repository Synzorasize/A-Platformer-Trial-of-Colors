extends Control

onready var Timer = $VBoxContainer/HBoxContainer/SpeedrunTimer
onready var SpeedrunLabel = $VBoxContainer/HBoxContainer/Timer
onready var Player = HH.get_parent_sibling("Player", self)
var nextScene : PackedScene
var speedrun_time = 0
var checkpoint_speedrun_time = 0

var currenthoverpressed
var currentnormal
var color
onready var BackButton = $VBoxContainer2/BackButton
onready var RestartButton = $VBoxContainer2/HBoxContainer/RestartButton
onready var PauseButton = $VBoxContainer2/HBoxContainer/PauseButton
onready var NextButton = $TextureRect/NextButton
onready var No = $RestartWarning/No
onready var Yes = $RestartWarning/Yes
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.hide()
	$RestartWarning.hide()
	$VBoxContainer/Checkpoint.hide()
	if GlobalVariables.speedrun == false:
		$VBoxContainer/HBoxContainer.hide()
	else:
		$VBoxContainer/HBoxContainer.show()
	$VBoxContainer/LevelNum.text = "Level " + str(GlobalVariables.LevelNum)
	if GlobalVariables.colorblind_mode:
		GlobalVariables.colorblind_mode_on(self)
#	buttoncolors("normal")
func _enter_tree():
#	print(get_tree().get_root().get_node_or_null("Level Player").name)
	if not get_tree().get_root().get_node_or_null("Level Player") == null:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Player.victory == false:
		buttoncolors("normal")
	if GlobalVariables.speedrun:
		speedrun_time = stepify((4096 + checkpoint_speedrun_time) - Timer.get_time_left(), 0.01)
		if Timer.get_wait_time():
			SpeedrunLabel.text = str(speedrun_time)
		else:
			SpeedrunLabel.text = "4096; Timed out"

func buttoncolors(mode):
	if GlobalVariables.ButtonColors_off == false:
		if Player.color == "red" and not color == "red":
			currentnormal = preload("res://Art/Buttons/RedButtonNormal.tres")
			currenthoverpressed = preload("res://Art/Buttons/RedButtonHover_Pressed.tres")
			color = Player.color
		elif Player.color == "blue" and not color == "blue":
			currentnormal = preload("res://Art/Buttons/BlueButtonNormal.tres")
			currenthoverpressed = preload("res://Art/Buttons/BlueButtonHover_Pressed.tres")
			color = Player.color
		elif Player.color == "green" and not color == "green":
			currentnormal = preload("res://Art/Buttons/GreenButtonNormal.tres")
			currenthoverpressed = preload("res://Art/Buttons/GreenButtonHover_Pressed.tres")
			color = Player.color
		if mode == "normal":
			BackButton.add_stylebox_override("normal", currentnormal)
			BackButton.add_stylebox_override("hover", currenthoverpressed)
			BackButton.add_stylebox_override("pressed", currenthoverpressed)
			RestartButton.add_stylebox_override("normal", currentnormal)
			RestartButton.add_stylebox_override("hover", currenthoverpressed)
			RestartButton.add_stylebox_override("pressed", currenthoverpressed)
			PauseButton.add_stylebox_override("normal", currentnormal)
			PauseButton.add_stylebox_override("hover", currenthoverpressed)
			PauseButton.add_stylebox_override("pressed", currenthoverpressed)
		elif mode == "victory":
			NextButton.add_stylebox_override("normal", currentnormal)
			NextButton.add_stylebox_override("hover", currenthoverpressed)
			NextButton.add_stylebox_override("pressed", currenthoverpressed)


func _on_ExitSprite_body_entered(body):
	if body.name == "Player" and GlobalVariables.editor == false:
		if GlobalVariables.LevelNum == 20:
			nextScene = load("res://Levels/Title screen.tscn")
			NextButton.text = "Title screen"
		elif GlobalVariables.LevelNum == 999:
			nextScene = load("res://Levels/Level Player.tscn")
			NextButton.text = "Level Editor"
		else:
			nextScene = load("res://Levels/Level"+str(GlobalVariables.LevelNum + 1)+".tscn")
			NextButton.text = "Next Level"
		buttoncolors("victory")
		$TextureRect.show()
		get_tree().paused = true
		if GlobalVariables.speedrun:
			SpeedrunLabel.text = str(speedrun_time)
			save_speedrun_time(GlobalVariables.LevelNum)
		if GlobalVariables.max_LevelNum == GlobalVariables.LevelNum:
			GlobalVariables.max_LevelNum = GlobalVariables.LevelNum + 1
			GlobalVariables.userdata.levels_unlocked = GlobalVariables.max_LevelNum
		GlobalVariables.saveGame()

func save_speedrun_time(LevelNum):
	if GlobalVariables.userdata.speedrun_times.has("Level" + str(LevelNum)):
		if speedrun_time < GlobalVariables.userdata.speedrun_times["Level" + str(LevelNum)]:
			GlobalVariables.userdata.speedrun_times["Level" + str(LevelNum)] = speedrun_time
	else:
		GlobalVariables.userdata.speedrun_times["Level" + str(LevelNum)] = speedrun_time

func _on_NextButton_pressed():
	get_tree().paused = false
	GlobalVariables.checkpoint = 0
	get_tree().change_scene_to(nextScene)
	GlobalVariables.colorblind_mode_off(self)


func _on_BackButton_pressed():
	get_tree().paused = false
	if not GlobalVariables.LevelNum == 999:
		get_tree().change_scene("res://Levels/Title screen.tscn")
	else:
		get_tree().change_scene("res://Levels/Level Player.tscn")
	GlobalVariables.checkpoint = 0
	GlobalVariables.colorblind_mode_off(self)

func _on_Checkpoint_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and GlobalVariables.editor == false:
		$VBoxContainer/Checkpoint.show()
		if GlobalVariables.speedrun and checkpoint_speedrun_time == 0:
			checkpoint_speedrun_time = 4096 - Timer.get_time_left()
			Timer.start()


func _on_No_pressed():
	$RestartWarning.hide()
	get_tree().paused = false


func _on_RestartButton_pressed():
	if $RestartWarning.is_visible() == false and Player.victory or $RestartWarning.is_visible() and not GlobalVariables.checkpoint == 0:
		$RestartWarning.show()
		get_tree().paused = true
		No.add_stylebox_override("normal", currentnormal)
		No.add_stylebox_override("hover", currenthoverpressed)
		No.add_stylebox_override("pressed", currenthoverpressed)
		Yes.add_stylebox_override("normal", currentnormal)
		Yes.add_stylebox_override("hover", currenthoverpressed)
		Yes.add_stylebox_override("pressed", currenthoverpressed)
	elif GlobalVariables.LevelNum == 999:
		HH.get_grandparent(self).restart()
		get_tree().paused = false
	else:
		get_tree().paused = false
		get_tree().reload_current_scene()
		GlobalVariables.checkpoint = 0


func _on_PauseButton_toggled(button_pressed):
	if button_pressed:
		get_tree().paused = true
	elif button_pressed == false:
		get_tree().paused = false

extends Node2D

export (Dictionary) var data = {
	"level_name": "CustomLevel",
	"speedrun_time": null,
	"player": {
		"color": "red",
		"position": Vector2(384,192),
		"camera": false,
	},
	"Tile": Vector2(384,224),
}
onready var Player = $Player
onready var Camera = $Player/Camera2D
onready var UI = $CanvasLayer/UI
var RenameLevelText
var descendants = []

func restart():
	get_tree().change_scene_to(GlobalVariables.level.duplicate())

func _enter_tree():
	GlobalVariables.LevelNum = 999
func _ready():
	Camera.current = false
	if GlobalVariables.editor_playing and not GlobalVariables.editor:
		Player.color = data.player.color
		if not get_node_or_null("ExitSprite") == null:
			get_node("ExitSprite").connect("body_entered", Player, "_on_ExitSprite_body_entered")
			get_node("ExitSprite").connect("body_entered", UI, "_on_ExitSprite_body_entered")
		if data.player.camera:
			Camera.current = true
	else:
		RenameLevelText = $"../Level Editor/Panel4/LineEdit2"

func saveLevel():
	position = Vector2(0,0)
	descendants.clear()
	descendants = get_children() + [UI]
	for i in descendants:
		i.owner = self
	GlobalVariables.level.pack(self)


func _on_SaveButton_pressed():
	for i in GlobalVariables.userdata.saved_levels:
		#print(data.level_name)
		if i.level_name == data.level_name:
			GlobalVariables.userdata.saved_levels.erase(i)
			break
	GlobalVariables.userdata.saved_levels.append(data)
	GlobalVariables.saveGame()

func _on_PlayButton_pressed():
	UI.show()
	saveLevel()
	get_tree().change_scene_to(GlobalVariables.level)
	GlobalVariables.editor = false
	GlobalVariables.editor_playing = true


func _on_ExportButton_pressed():
	saveLevel()

func _on_CameraButton_toggled(button_pressed):
	if button_pressed:
		data.player.camera = true
	else:
		data.player.camera = false


func _on_RenameButton2_pressed():
	data.level_name = RenameLevelText.text
	get_parent().RenamePanel.hide()

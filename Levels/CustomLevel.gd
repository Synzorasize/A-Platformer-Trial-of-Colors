extends Node2D

export (Dictionary) var data = {
	"name": "CustomLevel",
	"speedrun_time": null,
	"player": {
		"color": "red",
		"position": Vector2(384,192),
		"camera": false,
	},
	"tile": {
		"position": Vector2(384,224),
	},
}
#var level : PackedScene = PackedScene.new()
#var level_names = []
onready var Player = $Player
onready var Camera = $Player/Camera2D
onready var UI = $CanvasLayer/UI
var descendants = []
#var export : bool = false
#onready var FD = $"../FileDialog"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#func iterate_names():
#	level_names.clear()
#	if not GlobalVariables.userdata.saved_levels.empty():
#		for i in GlobalVariables.userdata.saved_levels:
#			level_names.append(GlobalVariables.userdata.saved_levels[i["name"]])

func restart():
	get_tree().change_scene_to(GlobalVariables.level.duplicate())

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GlobalVariables.LevelNum = 999
func _ready():
	if GlobalVariables.editor_playing == true:
		Player.color = data.player.color
		if not get_node_or_null("ExitSprite") == null:
			get_node("ExitSprite").connect("body_entered", Player, "_on_ExitSprite_body_entered")
			get_node("ExitSprite").connect("body_entered", UI, "_on_ExitSprite_body_entered")
		if data.player.camera == true:
			Camera.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func saveLevel():
	descendants.clear()
	descendants = get_children() + [UI]
	for i in descendants:
		i.owner = self
	GlobalVariables.level.pack(self)


func _on_SaveButton_pressed():
#	iterate_names()
#	for i in level_names:
#		var x = 0
#		if data["name"] == i:
#			data["name"] += str(x)
#			x += 1
	GlobalVariables.userdata.saved_levels.append(data)
	GlobalVariables.saveGame()

func _on_PlayButton_pressed():
	position = Vector2(0,0)
	UI.show()
	saveLevel()
#	ResourceSaver.save("res://current_scene.tscn", GlobalVariables.level)
#	print(Player.get_signal_connection_list("iamred"))
	get_tree().change_scene_to(GlobalVariables.level)
	GlobalVariables.editor = false
	GlobalVariables.editor_playing = true


func _on_ExportButton_pressed():
#	export = true
	saveLevel()
#	FD.popup()

#func _on_FileDialog_confirmed():
#	if export == true:
#		ResourceSaver.save(FD.get_current_path(), GlobalVariables.level)
#		export = false
	


func _on_CameraButton_toggled(button_pressed):
	if button_pressed == true:
		data.player.camera = true
	elif button_pressed == false:
		data.player.camera = false

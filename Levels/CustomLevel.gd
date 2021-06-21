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
#var level : PackedScene = PackedScene.new()
#var level_names = []
onready var Player = $Player
onready var Camera = Player.get_node("Camera2D")
onready var UI = $CanvasLayer/UI
var RenameLevelText : LineEdit
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
	JavaScript.eval("""function download(filename, text) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', filename);

  element.style.display = 'none';
  document.body.appendChild(element);

  element.click();

  document.body.removeChild(element);
}""")
func _ready():
	name = "Level999"
	Camera.current = false
	if GlobalVariables.editor_playing and not GlobalVariables.editor:
		Player.color = data.player.color
		if not get_node_or_null("ExitSprite") == null:
			get_node("ExitSprite").connect("body_entered", Player, "_on_ExitSprite_body_entered")
			get_node("ExitSprite").connect("body_entered", UI, "_on_ExitSprite_body_entered")
		if not get_node_or_null("Checkpoint") == null:
			get_node("Checkpoint").connect("body_shape_entered", UI, "_on_Checkpoint_body_shape_entered")
		if data.player.camera:
			Camera.current = true
		UI.get_node("VBoxContainer/LevelNum").text = data.level_name
	else:
		RenameLevelText = $"../Level Editor/Panel4/LineEdit2"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func saveLevel():
	position = Vector2(0,0)
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
#	ResourceSaver.save("res://Levels/Level21.tscn", GlobalVariables.level)
#	ResourceSaver.save("glitchedLevel.tscn", GlobalVariables.level)
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
	data.player.camera = button_pressed


func _on_RenameButton2_pressed():
	#print(GlobalVariables.userdata.saved_levels[0].level_name)
	data.level_name = RenameLevelText.text
	get_parent().RenamePanel.hide()

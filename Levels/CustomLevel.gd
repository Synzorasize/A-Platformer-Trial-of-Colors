extends Level

export (Dictionary) var data = {
	"level_name": "CustomLevel",
	"speedrun_time": null,
	"teleporter_connections": {},
	switch_init: [],
	"switch_order": [],
	"player": {
		"color": "red",
		"position": Vector2(384,192),
		"camera": false,
	},
	"Tile": Vector2(384,224),
}
#var level : PackedScene = PackedScene.new()
#var level_names = []
onready var UI = $CanvasLayer/UI
var level_player : Node
var RenameLevelText : LineEdit
var SetIDText : LineEdit
# Teleporter control
var currentTeleporterID : int
var currentTeleporterName : String

var descendants = []
#var export : bool = false

func restart():
	get_tree().change_scene_to(GlobalVariables.level.duplicate())

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	level_player = get_parent()
	#JavaScript.eval("""function download(filename, text) {
 # var element = document.createElement('a');
 # element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
#  element.setAttribute('download', filename);

#  element.style.display = 'none';
 # document.body.appendChild(element);

 # element.click();

 # document.body.removeChild(element);
#}""", true)
func _ready():
	name = "Level999"
	if GlobalVariables.editor_playing and not GlobalVariables.editor:
		if not get_node_or_null("ExitSprite") == null:
			get_node("ExitSprite").connect("body_entered", Player, "_on_ExitSprite_body_entered")
			get_node("ExitSprite").connect("body_entered", UI, "_on_ExitSprite_body_entered")
		UI.lvlNum.text = data.level_name
	else:
		RenameLevelText = $"../Level Editor/Panel4/LineEdit2"
		SetIDText = $"../Level Editor/Panel5/LineEdit3"
		Camera.current = false

func saveLevel():
	position = Vector2(0,0)
	descendants = get_children() + [UI]
	for i in descendants:
		i.owner = self
	GlobalVariables.level.pack(self)


func _on_SaveButton_pressed():
	for i in GlobalVariables.userdata.saved_levels:
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
	get_tree().change_scene_to(GlobalVariables.level)
	GlobalVariables.editor = false
	GlobalVariables.editor_playing = true


func _on_ExportButton_pressed():
#	export = true
	saveLevel()
	#JavaScript.eval("""download("APTC")""")
#	FD.popup()

#func _on_FileDialog_confirmed():
#	if export == true:
#		ResourceSaver.save(FD.get_current_path(), GlobalVariables.level)
#		export = false
	


func _on_CameraButton_toggled(button_pressed):
	data.player.camera = button_pressed
	Player.camera_on = button_pressed

func _on_RenameButton2_pressed():
	data.level_name = RenameLevelText.text
	level_player.RenamePanel.hide()


func _on_SetIDButton_pressed():
	var d = int(SetIDText.text)
	if level_player.teleporterIDs.has(d):
		for i in data:
			if "Teleporter" in i:
				if d == data[i].id:
					if not d == currentTeleporterID:
						data.teleporter_connections[currentTeleporterName] = i
						get_node(currentTeleporterName).connectedTeleporterName = i
						break
					else:
						printerr("Teleporters can't connect to themselves.")
	else:
		printerr("No teleporter exists with that id.")
	level_player.SetIDPanel.hide()
	for j in get_tree().get_nodes_in_group("idLabel"):
		j.hide()

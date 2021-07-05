extends Node

onready var level = $Level999
onready var Player = level.Player
onready var Camera = level.Camera
onready var editor = $"Level Editor"
onready var LeftPanel = editor.get_node("Panel")
onready var RightPanel = editor.get_node("Panel2")
onready var LoadPanel = editor.get_node("Panel3")
onready var RenamePanel = editor.get_node("Panel4")
onready var SetIDPanel = editor.get_node("Panel5")
onready var LoadLevelText = LoadPanel.get_node("LineEdit")
onready var LoadButton = LoadPanel.get_node("LoadButton2")
onready var RenameButton = RenamePanel.get_node("RenameButton2")
onready var PlayButton = RightPanel.get_node("PlayButton")
onready var CameraButton = RightPanel.get_node("CameraButton")
onready var PlayerColorButton = RightPanel.get_node("PlayerColorButton")
onready var SaveButton = RightPanel.get_node("SaveButton")
onready var colorButtons = get_tree().get_nodes_in_group("colorButton")
onready var OrbAdder = LeftPanel.get_node("OrbAdder")
onready var HazardAdder = LeftPanel.get_node("HazardAdder")
onready var ExitAdder = LeftPanel.get_node("ExitAdder")
onready var CheckpointAdder = LeftPanel.get_node("CheckpointAdder")
onready var TeleporterAdder = LeftPanel.get_node("TeleporterAdder")
onready var RedButton = colorButtons[1]
onready var BlueButton = colorButtons[0]
onready var GreenButton = colorButtons[2]
onready var WhiteButton = colorButtons[3]
onready var Label = SetIDPanel.get_node("Label")
onready var Label2 = SetIDPanel.get_node("Label2")
onready var SetIDButton = SetIDPanel.get_node("SetIDButton")
onready var CoordinatesLabel = editor.get_node("CoordinatesLabel")
var teleporterIDs:Array = []
var current_selected : CollisionObject2D
var color_pick : String
var m : Vector2
var ui : bool = false
var exists : bool = false

func object_counter(j:CollisionObject2D=current_selected):
	if level.get_node_or_null(j.name) == null:
		level.add_child(j)
	else:
		var i = 0
		while not j.is_inside_tree():
			if level.get_node_or_null(j.name + str(i)) == null:
				j.name += str(i)
				level.add_child(j)
			else:
				i += 1

func add_object(obj : String):
	if current_selected == null:
		current_selected = load("res://" + obj + ".tscn").instance()
		object_counter()
		if "Teleporter" in current_selected.name:
			if teleporterIDs.empty():
				teleporterIDs.append(0)
			else:
				teleporterIDs.append(teleporterIDs[-1]+1)
			level.data[current_selected.name] = {"id": teleporterIDs[-1]}
			addIdLabel(teleporterIDs)

func addIdLabel(type:Array,obj:CollisionObject2D=current_selected,num:int=-1):
	var lbl = preload("res://Art/Fonts/idLabel.tscn").instance()
	lbl.text = str(type[num])
	lbl.hide()
	obj.add_child(lbl)

func loadLevel():
	level.queue_free()
	level = GlobalVariables.level.instance()
	Player = level.get_node("Player")
	Player.color = level.data.player.color
	add_child(level,true)
	move_child(level, 0)
	PlayButton.connect("pressed", level, "_on_PlayButton_pressed")
	SaveButton.connect("pressed", level, "_on_SaveButton_pressed")
	CameraButton.connect("toggled", level, "_on_CameraButton_toggled")
	RenameButton.connect("pressed", level, "_on_RenameButton2_pressed")
	SetIDButton.connect("pressed", level, "_on_SetIDButton_pressed")
	CameraButton.pressed = level.data.player.camera
	for i in level.data:
		if "Teleporter" in i:
			teleporterIDs.append(level.data[i].id)
			addIdLabel(teleporterIDs, level.get_node(i))
	Camera.current = false

func _ready():
	GlobalVariables.editor = true
	GlobalVariables.speedrun = false
	if GlobalVariables.editor_playing:
		GlobalVariables.editor_playing = false
		loadLevel()
	if GlobalVariables.editor_edit:
		GlobalVariables.editor_edit = false
		LoadLevelText.text = GlobalVariables.level_name_edit
		LoadButton.emit_signal("pressed")
	ExitAdder.disabled = not level.get_node_or_null("ExitSprite") == null
	CheckpointAdder.disabled = not level.get_node_or_null("Checkpoint") == null
	BGTexture.get_node("BG").texture = Player.BGs.grey
	if not GlobalVariables.userdata.has("saved_levels"):
		GlobalVariables.userdata.saved_levels = []
	CoordinatesLabel.visible = not GlobalVariables.coordinateLabel_off
	displayButtons("white")
	Camera.current = false

func _process(_delta):
	m = level.get_local_mouse_position()
	if not GlobalVariables.coordinateLabel_off:
		CoordinatesLabel.rect_position = level.get_global_mouse_position() + Vector2(4,4)
		CoordinatesLabel.text = str(m)
	if not LoadPanel.is_visible() and not RenamePanel.is_visible() and not SetIDPanel.is_visible():
		if Input.is_action_pressed("ui_left") and level.position.x < 480:
			level.position.x += 8
		if Input.is_action_pressed("ui_right") and level.position.x > -480:
			level.position.x -= 8
		if not ui:
			if not current_selected == null:
				if Input.is_action_pressed("ui_cancel") and not current_selected == Player: #Deletion of objects
					if current_selected.name == "ExitSprite":
						ExitAdder.disabled = false
					if current_selected.name == "Checkpoint":
						CheckpointAdder.disabled = false
					if "Teleporter" in current_selected.name:
						teleporterIDs.erase(level.data[current_selected.name].id)
					current_selected.queue_free()
					level.data.erase(current_selected.name)
					current_selected = null
				if not current_selected == null:
					if Player == current_selected:
						level.data.player.position = Player.position
					elif "Teleporter" in current_selected.name:
						level.data[current_selected.name]["position"] = current_selected.position
					else:
						level.data[current_selected.name] = current_selected.position
					if Input.is_action_pressed("shift"):
						current_selected.position = Vector2(stepify(m.x, 1),stepify(m.y, 1))
					else:
						current_selected.position = Vector2(stepify(m.x, 8),stepify(m.y, 8))
			else:
				var x = level.get_children()
				x.erase(level.get_node("CanvasLayer"))
				for i in x:
					if Player == i or "Tile" in i.name or "tile" in i.name or "Hazard" in i.name:
						position_calc(16,16,i)
					elif "ExitSprite" == i.name:
						position_calc(16,32,i)
					elif "ColorOrb" in i.name or "Teleporter" in i.name:
						position_calc(24,36,i)
					elif "Checkpoint" in i.name:
						position_calc(5.5,22,i)

func position_calc(x:float,y:float,i:CollisionObject2D):
	if m.x > i.position.x - x and m.y < i.position.y + y and m.x < i.position.x + x and m.y > i.position.y - y:
		if Input.is_action_pressed("mousebutton"):
			current_selected = i
		if "Teleporter" in i.name and Input.is_action_pressed("ui_select"):
			SetIDPanel.show()
			level.currentTeleporterID = level.data[i.name].id
			level.currentTeleporterName = i.name
			Label.text = "The current ID of the currently selected teleporter is " + str(level.currentTeleporterID) + ". You can set the end teleporter to the ID of another teleporter."
			Label2.text = "The IDs of other teleporters are " + str(teleporterIDs) + "."
			for j in get_tree().get_nodes_in_group("idLabel"):
				j.show()

func _on_BackButton_pressed():
	get_tree().change_scene("res://Levels/Title screen.tscn")
	GlobalVariables.editor = false
	


func _on_TileAdder_pressed():
	if not color_pick == "white":
		var color = color_pick.capitalize()
		add_object("Tilecostumes/"+color+"tile")
	else:
		add_object("Tilecostumes/Tile")


func _on_Level_Editor_gui_input(event):
	if not current_selected == null:
		if event is InputEventMouseButton:
			current_selected = null
	

func displayButtons(color : String):
	#color = color.insert(0, color.left(0).capitalize())
	#for button in colorButtons:
		#if color in button.name:
		#	button.set("custom_styles/normal", load("res://Art/Buttons/"+color+"ColorPick.tres"))
		#else:
			#if button.name == "RedButton":
			#	button.set("custom_styles/normal", load("res://Art/Buttons/RedColorPicked.tres"))
			#if button.name == "BlueButton":
			#	button.set("custom_styles/normal", load("res://Art/Buttons/BlueColorPicked.tres"))
			#if button.name == "GreenButton":
			#	button.set("custom_styles/normal", load("res://Art/Buttons/GreenColorPicked.tres"))
			#if button.name == "WhiteButton":
			#	button.set("custom_styles/normal", load("res://Art/Buttons/WhiteColorPicked.tres"))
	match color_pick:
		"red":
			RedButton.set("custom_styles/normal", preload("res://Art/Buttons/RedButtonNormal.tres"))
		"blue":
			BlueButton.set("custom_styles/normal", preload("res://Art/Buttons/BlueButtonNormal.tres"))
		"green":
			GreenButton.set("custom_styles/normal", preload("res://Art/Buttons/GreenButtonNormal.tres"))
		"white":
			WhiteButton.set("custom_styles/normal", preload("res://Art/Buttons/WhiteButtonNormal.tres"))
	color_pick = color
	match color:
		"red":
			RedButton.set("custom_styles/normal", preload("res://Art/Buttons/RedButtonHover_Pressed.tres"))
		"blue":
			BlueButton.set("custom_styles/normal", preload("res://Art/Buttons/BlueButtonHover_Pressed.tres"))
		"green":
			GreenButton.set("custom_styles/normal", preload("res://Art/Buttons/GreenButtonHover_Pressed.tres"))
		"white":
			WhiteButton.set("custom_styles/normal", preload("res://Art/Buttons/WhiteButtonHover_Pressed.tres"))
	OrbAdder.disabled = color_pick == "white"
	TeleporterAdder.disabled = color_pick == "white"
	HazardAdder.disabled = color_pick == "white"
	PlayerColorButton.disabled = color_pick == "white"

func _on_RedButton_pressed():
	displayButtons("red")

func _on_BlueButton_pressed():
	displayButtons("blue")

func _on_GreenButton_pressed():
	displayButtons("green")

func _on_WhiteButton_pressed():
	displayButtons("white")

func _on_LoadButton2_pressed():
	#LoadingScreen.show()
	var n = LoadLevelText.text
	var x = []
	if not GlobalVariables.userdata.saved_levels.empty():
		for i in GlobalVariables.userdata.saved_levels:
			x.append(i.level_name)
		var r = x.find(n)
		if not r == -1:
			if GlobalVariables.userdata.saved_levels.has(GlobalVariables.userdata.saved_levels[r]):
				level.data = GlobalVariables.userdata.saved_levels[r]
				if not level.data.has("teleporter_connections"):
					level.data.teleporter_connections = {}
				level.position = Vector2(0,0)
				var y = level.get_children()
				y.erase(level.get_node("CanvasLayer"))
				y.erase(Player)
				for i in y:
					i.queue_free()
				level.data.player.position = str2var("Vector2" + str(level.data.player.position))
				Player.position = level.data.player.position
				Player.color = level.data.player.color
				CameraButton.pressed = level.data.player.camera
				for i in level.data:
					var j : CollisionObject2D
					if "Tile" in i:
						j = simpl("Tilecostumes/Tile")
					elif "Redtile" in i:
						j = simpl("Tilecostumes/Redtile")
					elif "Bluetile" in i:
						j = simpl("Tilecostumes/Bluetile")
					elif "Greentile" in i:
						j = simpl("Tilecostumes/Greentile")
					elif "RedHazard" in i:
						j = simpl("Hazards/RedHazard")
					elif "BlueHazard" in i:
						j = simpl("Hazards/BlueHazard")
					elif "GreenHazard" in i:
						j = simpl("Hazards/GreenHazard")
					elif "RedColorOrb" in i:
						j = simpl("ColorOrbs/RedColorOrb")
					elif "BlueColorOrb" in i:
						j = simpl("ColorOrbs/BlueColorOrb")
					elif "GreenColorOrb" in i:
						j = simpl("ColorOrbs/GreenColorOrb")
					elif "RedTeleporter" in i:
						j = simpl("Teleporters/RedTeleporter")
					elif "BlueTeleporter" in i:
						j = simpl("Teleporters/BlueTeleporter")
					elif "GreenTeleporter" in i:
						j = simpl("Teleporters/GreenTeleporter")
					elif "ExitSprite" == i:
						j = simpl(i)
					elif "Checkpoint" in i:
						j = simpl("Art/Checkpoint/Checkpoint")
					if exists:
						if "Teleporter" in i and level.get_node_or_null("TeleportTimer") == null:
							level.add_child(preload("res://Teleporters/TeleportTimer.tscn").instance())
						object_counter(j)
						if "Teleporter" in j.name:
							level.data[i]["position"] = str2var("Vector2" + str(level.data[i].get("position")))
							j.position = level.data[i]["position"]
							if level.data.teleporter_connections.has(i):
								j.connectedTeleporterName = level.data.teleporter_connections[i]
							teleporterIDs.append(level.data[i].id)
						else:
							level.data[i] = str2var("Vector2" + str(level.data.get(i)))
							j.position = level.data[i]
						j = null
						exists = false
					ExitAdder.disabled = not level.get_node_or_null("ExitSprite") == null
		else:
			printerr("Level not found!")
	else:
		printerr("No levels!")
	LoadPanel.hide()
	#LoadingScreen.hide()

func simpl(path:String):
	exists=true
	return load("res://"+path+".tscn").instance()

#func _on_ImportButton_pressed():
#	import = true
#	$FileDialog.popup()

#func _on_FileDialog_confirmed():
#	if import == true:
#		GlobalVariables.level = $FileDialog.get_current_file()
#		loadLevel()


func _on_ExitAdder_pressed():
	add_object("ExitSprite")
	ExitAdder.disabled = true


func _on_OrbAdder_pressed():
	var color = color_pick.capitalize()
	add_object("ColorOrbs/"+color+"ColorOrb")
	#match color_pick:
	#	"red":
	#		add_object("ColorOrbs/RedColorOrb")
	#	"blue":
	#		add_object("ColorOrbs/BlueColorOrb")
	#	"green":
	#		add_object("ColorOrbs/GreenColorOrb")


func _on_HazardAdder_pressed():
	var color = color_pick.capitalize()
	add_object("Hazards/"+color+"Hazard")
#	match color_pick:
#		"red":
#			add_object("Hazards/RedHazard")
#		"blue":
#			add_object("Hazards/BlueHazard")
#		"green":
#			add_object("Hazards/GreenHazard")


func _on_PlayerColorButton_pressed():
	Player.color = color_pick
	level.data.player.color = color_pick


func _on_LoadButton_pressed():
	LoadPanel.show()


func _on_CancelButton_pressed():
	LoadPanel.hide()
	RenamePanel.hide()
	SetIDPanel.hide()
	for j in get_tree().get_nodes_in_group("idLabel"):
		j.hide()

func _on_RenameButton_pressed():
	level.RenameLevelText.text = level.data.level_name
	RenamePanel.show()


func _on_Panel_mouse_entered():
	ui = true


func _on_Panel_mouse_exited():
	ui = false


func _on_CheckpointAdder_pressed():
	add_object("Art/Checkpoint/Checkpoint")
	CheckpointAdder.disabled = true


func _on_TeleporterAdder_pressed():
	if level.get_node_or_null("TeleportTimer") == null:
		level.add_child(preload("res://Teleporters/TeleportTimer.tscn").instance())
	var color = color_pick.capitalize()
	add_object("Teleporters/"+color+"Teleporter")
	#match color_pick:
	#	"red":
	#		add_object("Teleporters/RedTeleporter")
	#	"blue":
	#		add_object("Teleporters/BlueTeleporter")
	#	"green":
	#		add_object("Teleporters/GreenTeleporter")


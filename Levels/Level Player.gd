extends Node

onready var level = $Level999
onready var Player = level.Player
onready var Camera = level.Camera
onready var editor = $"Level Editor"
onready var LeftPanel = editor.get_node("Panel")
onready var RightPanel = editor.get_node("Panel2")
onready var LoadPanel = editor.get_node("Panel3")
onready var RenamePanel = editor.get_node("Panel4")
onready var LoadLevelText = LoadPanel.get_node("LineEdit")
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
onready var RedButton = colorButtons[1]
onready var BlueButton = colorButtons[0]
onready var GreenButton = colorButtons[2]
onready var WhiteButton = colorButtons[3]
var current_selected : CollisionObject2D
var color_pick : String
var m : Vector2
var ui : bool = false

func add_object(obj : String):
	current_selected = load("res://" + obj + ".tscn").instance()
	if level.get_node_or_null(current_selected.name) == null:
		level.add_child(current_selected)
	else:
		var i = 0
		while not current_selected.is_inside_tree():
			if level.get_node_or_null(current_selected.name + str(i)) == null:
				current_selected.name += str(i)
				level.add_child(current_selected)
			else:
				i += 1

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
	if level.data.player.camera:
		CameraButton.pressed = true
	Camera.current = false
#	ExportButton.connect("pressed", level, "_on_ExportButton_pressed")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.editor = true
	GlobalVariables.speedrun = false
	if GlobalVariables.editor_playing:
		loadLevel()
		GlobalVariables.editor_playing = false
	if not level.get_node_or_null("ExitSprite") == null:
		ExitAdder.disabled = true
	if not level.get_node_or_null("Checkpoint") == null:
		CheckpointAdder.disabled = true
	if not HH.get_sibling("ParallaxBackground", self) == null:
		HH.get_sibling("ParallaxBackground", self).get_node("BG").texture = Player.BGs.grey
	if not GlobalVariables.userdata.has("saved_levels"):
		GlobalVariables.userdata.saved_levels = []
	displayButtons("white")
	Camera.current = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if color_pick == "white":
		OrbAdder.disabled = true
		HazardAdder.disabled = true
		PlayerColorButton.disabled = true
	else:
		OrbAdder.disabled = false
		HazardAdder.disabled = false
		PlayerColorButton.disabled = false
	m = level.get_local_mouse_position()
	if not LoadPanel.is_visible() and not RenamePanel.is_visible():
		if Input.is_action_pressed("ui_left") and level.position.x < 480:
			level.position.x += 8
		if Input.is_action_pressed("ui_right") and level.position.x > -480:
			level.position.x -= 8
		if ui == false:
			if not current_selected == null:
				if Input.is_action_pressed("shift"):
					current_selected.position = Vector2(stepify(m.x, 1),stepify(m.y, 1))
				else:
					current_selected.position = Vector2(stepify(m.x, 8),stepify(m.y, 8))
				if Player == current_selected:
					level.data.player.position = Player.position
				else:
					level.data[current_selected.name] = current_selected.position
				if Input.is_action_pressed("ui_cancel") and not current_selected == Player:
					if current_selected.name == "ExitSprite":
						ExitAdder.disabled = false
					current_selected.queue_free()
					level.data.erase(current_selected.name)
			else:
				var x = level.get_children()
				x.erase(level.get_node("CanvasLayer"))
				#print(editor.get_global_mouse_position())
				#print(editor.get_global_mouse_position() > Vector2(0,0) == false and editor.get_global_mouse_position() < Vector2(160,450) == false)
				#if editor.get_global_mouse_position() > Vector2(608,0) == false and editor.get_global_mouse_position() < Vector2(768,450) == false:
				for i in x:
					if Player == i or "Tile" in i.name or "tile" in i.name or "Hazard" in i.name:
						if m.x > i.position.x - 16 and m.y < i.position.y + 16 and m.y > i.position.y - 16 and m.x < i.position.x + 16 and Input.is_action_pressed("mousebutton"):
							current_selected = i
					elif "ExitSprite" == i.name:
						if m.x > i.position.x - 16 and m.y < i.position.y + 32 and m.y > i.position.y - 32 and m.x < i.position.x + 16 and Input.is_action_pressed("mousebutton"):
							current_selected = i
					elif "ColorOrb" in i.name:
						if m.x > i.position.x - 24 and m.y < i.position.y + 36 and m.y > i.position.y - 36 and m.x < i.position.x + 24 and Input.is_action_pressed("mousebutton"):
							current_selected = i
					elif "Checkpoint" in i.name:
						if m.x > i.position.x - 5.5 and m.y < i.position.y + 22 and m.y > i.position.y - 22 and m.x < i.position.x + 5.5 and Input.is_action_pressed("mousebutton"):
							current_selected = i

func _on_BackButton_pressed():
	get_tree().change_scene("res://Levels/Title screen.tscn")
	GlobalVariables.editor = false
	


func _on_TileAdder_pressed():
	if color_pick == "white":
		add_object("Tilecostumes/Tile")
	elif color_pick == "red":
		add_object("Tilecostumes/Redtile")
	elif color_pick == "blue":
		add_object("Tilecostumes/Bluetile")
	elif color_pick == "green":
		add_object("Tilecostumes/Greentile")


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
	if color_pick == "red":
		RedButton.set("custom_styles/normal", preload("res://Art/Buttons/RedColorPick.tres"))
	elif color_pick == "blue":
		BlueButton.set("custom_styles/normal", preload("res://Art/Buttons/BlueColorPick.tres"))
	elif color_pick == "green":
		GreenButton.set("custom_styles/normal", preload("res://Art/Buttons/GreenColorPick.tres"))
	elif color_pick == "white":
		WhiteButton.set("custom_styles/normal", preload("res://Art/Buttons/WhiteColorPick.tres"))
	color_pick = color
	if color == "red":
		RedButton.set("custom_styles/normal", preload("res://Art/Buttons/RedColorPicked.tres"))
	elif color == "blue":
		BlueButton.set("custom_styles/normal", preload("res://Art/Buttons/BlueColorPicked.tres"))
	elif color == "green":
		GreenButton.set("custom_styles/normal", preload("res://Art/Buttons/GreenColorPicked.tres"))
	elif color == "white":
		WhiteButton.set("custom_styles/normal", preload("res://Art/Buttons/WhiteColorPicked.tres"))

func _on_RedButton_pressed():
	displayButtons("red")

func _on_BlueButton_pressed():
	displayButtons("blue")

func _on_GreenButton_pressed():
	displayButtons("green")

func _on_WhiteButton_pressed():
	displayButtons("white")

func _on_LoadButton2_pressed():
	var n = LoadLevelText.text
	var x = []
	if not GlobalVariables.userdata.saved_levels.empty():
		for i in GlobalVariables.userdata.saved_levels:
			x.append(i.level_name)
		var r = x.find(n)
		if not r == -1:
			if GlobalVariables.userdata.saved_levels.has(GlobalVariables.userdata.saved_levels[r]):
				level.data = GlobalVariables.userdata.saved_levels[r]
				level.position = Vector2(0,0)
				var y = level.get_children()
				y.erase(level.get_node("CanvasLayer"))
				y.erase(level.get_node("Player"))
				for i in y:
					i.queue_free()
				level.data.player.position = str2var("Vector2" + str(level.data.player.position))
				Player.position = level.data.player.position
				Player.color = level.data.player.color
				if level.data.player.camera:
					CameraButton.pressed = true
				for i in level.data:
					var j : CollisionObject2D
					var exists : bool = false
					if "Tile" in i:
						j = preload("res://Tilecostumes/Tile.tscn").instance()
						exists = true
					elif "Redtile" in i:
						j = preload("res://Tilecostumes/Redtile.tscn").instance()
						exists = true
					elif "Bluetile" in i:
						j = preload("res://Tilecostumes/Bluetile.tscn").instance()
						exists = true
					elif "Greentile" in i:
						j = preload("res://Tilecostumes/Greentile.tscn").instance()
						exists = true
					elif "RedHazard" in i:
						j = preload("res://Hazards/RedHazard.tscn").instance()
						exists = true
					elif "BlueHazard" in i:
						j = preload("res://Hazards/BlueHazard.tscn").instance()
						exists = true
					elif "GreenHazard" in i:
						j = preload("res://Hazards/GreenHazard.tscn").instance()
						exists = true
					elif "RedColorOrb" in i:
						j = preload("res://ColorOrbs/RedColorOrb.tscn").instance()
						exists = true
					elif "BlueColorOrb" in i:
						j = preload("res://ColorOrbs/BlueColorOrb.tscn").instance()
						exists = true
					elif "GreenColorOrb" in i:
						j = preload("res://ColorOrbs/GreenColorOrb.tscn").instance()
						exists = true
					elif "ExitSprite" in i:
						j = preload("res://ExitSprite.tscn").instance()
						exists = true
					elif "Checkpoint" in i:
						j = preload("res://Art/Checkpoint/Checkpoint.tscn").instance()
						exists = true
					if exists:
						if level.get_node_or_null(j.name) == null:
							level.add_child(j)
						else:
							var k = 0
							while not j.is_inside_tree():
								if level.get_node_or_null(j.name + str(k)) == null:
									j.name += str(k)
									level.add_child(j)
								else:
									k += 1
						level.add_child(j)
						level.data[i] = str2var("Vector2" + str(level.data.get(i)))
						j.position = level.data[i]
						j = null
						exists = false
				if not level.get_node_or_null("ExitSprite") == null:
					ExitAdder.disabled = true
		else:
			printerr("Level not found!")
	else:
		printerr("No levels!")
	LoadPanel.hide()


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
	if color_pick == "red":
		add_object("ColorOrbs/RedColorOrb")
	elif color_pick == "blue":
		add_object("ColorOrbs/BlueColorOrb")
	elif color_pick == "green":
		add_object("ColorOrbs/GreenColorOrb")


func _on_HazardAdder_pressed():
	if color_pick == "red":
		add_object("Hazards/RedHazard")
	elif color_pick == "blue":
		add_object("Hazards/BlueHazard")
	elif color_pick == "green":
		add_object("Hazards/GreenHazard")


func _on_PlayerColorButton_pressed():
	Player.color = color_pick
	level.data.player.color = color_pick


func _on_LoadButton_pressed():
	LoadPanel.show()


func _on_CancelButton_pressed():
	LoadPanel.hide()
	RenamePanel.hide()


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

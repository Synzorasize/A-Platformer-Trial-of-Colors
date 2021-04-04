extends Node

onready var level = $Level999
onready var Player = $Level999/Player
onready var Camera = Player.get_node("Camera2D")
onready var editor = $"Level Editor"
onready var LoadPanel = $"Level Editor/Panel3"
onready var LoadLevelText = $"Level Editor/Panel3/LineEdit"
onready var RenamePanel = $"Level Editor/Panel4"
onready var RenameButton = $"Level Editor/Panel4/RenameButton2"
onready var PlayButton = $"Level Editor/Panel2/PlayButton"
onready var CameraButton = $"Level Editor/Panel2/CameraButton"
onready var PlayerColorButton = $"Level Editor/Panel2/PlayerColorButton"
onready var SaveButton = $"Level Editor/Panel2/SaveButton"
onready var colorButtons = get_tree().get_nodes_in_group("colorButton")
onready var OrbAdder = $"Level Editor/Panel/OrbAdder"
onready var HazardAdder = $"Level Editor/Panel/HazardAdder"
onready var ExitAdder = $"Level Editor/Panel/ExitAdder"
onready var RedButton = $"Level Editor/Panel/RedButton"
onready var BlueButton = $"Level Editor/Panel/BlueButton"
onready var GreenButton = $"Level Editor/Panel/GreenButton"
onready var WhiteButton = $"Level Editor/Panel/WhiteButton"
var current_selected : Object
var click : bool
var object : Object
var color_pick : String

func add_object(obj : String):
	current_selected = load("res://" + obj + ".tscn").instance()
	level.add_child(current_selected)

func loadLevel():
	level.queue_free()
	level = GlobalVariables.level.instance()
	Player = level.get_node("Player")
	Player.color = level.data.player.color
	add_child(level)
	move_child(level, 0)
	PlayButton.connect("pressed", level, "_on_PlayButton_pressed")
	SaveButton.connect("pressed", level, "_on_SaveButton_pressed")
	CameraButton.connect("toggled", level, "_on_CameraButton_toggled")
	RenameButton.connect("pressed", level, "_on_RenameButton2_pressed")
	if level.data.player.camera:
		CameraButton.pressed = true
	Camera.current = false
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.editor = true
	GlobalVariables.speedrun = false
	if GlobalVariables.editor_playing:
		loadLevel()
		GlobalVariables.editor_playing = false
	if not level.get_node_or_null("ExitSprite") == null:
		ExitAdder.disabled = true
	if not GlobalVariables.userdata.has("saved_levels"):
		GlobalVariables.userdata.saved_levels = []
	VisualServer.set_default_clear_color(Color(0.682,0.682,0.682,1.0))
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
	var m = level.get_local_mouse_position()
	if not LoadPanel.is_visible() and not RenamePanel.is_visible():
		if Input.is_action_pressed("ui_left") and level.position.x > -480:
			level.position.x += 8
		if Input.is_action_pressed("ui_right") and level.position.x < 1248:
			level.position.x -= 8
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
					var j
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
					if exists:
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
	$"Level Editor/Panel3".hide()

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

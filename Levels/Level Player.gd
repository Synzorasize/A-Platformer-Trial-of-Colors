extends Node

onready var level = $Level999
onready var Player = $Level999/Player
onready var editor = $"Level Editor"
onready var PlayButton = $"Level Editor/Panel2/PlayButton"
onready var CameraButton = $"Level Editor/Panel2/CameraButton"
onready var PlayerColorButton = $"Level Editor/Panel2/PlayerColorButton"
#onready var ExportButton = $"Level Editor/Panel2/ExportButton"
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
#var h
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var color_pick : String
#var import : bool = false

func add_object(obj : String):
	current_selected = load("res://" + obj + ".tscn").instance()
	level.add_child(current_selected)
	#current_selected.input_pickable = true
	#current_selected.connect("input_event", self, "_Object_input_event", [current_selected])
	#print(current_selected.get_signal_connection_list("input_event"))

func loadLevel():
	level.queue_free()
	level = GlobalVariables.level.instance()
	Player = level.get_node("Player")
	add_child(level)
	move_child(level, 0)
	PlayButton.connect("pressed", level, "_on_PlayButton_pressed")
	CameraButton.connect("toggled", level, "_on_CameraButton_toggled")
	Player.get_node("Camera2D").current = false	
#	ExportButton.connect("pressed", level, "_on_ExportButton_pressed")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.editor = true
	#Player.connect("input_event", self, "_Object_input_event", [Player])
	#$Level999/Tile.connect("input_event", self, "_Object_input_event", [$Level999/Tile])
	if level.data.player.camera == true:
		CameraButton.pressed = true
	GlobalVariables.speedrun = false
	if GlobalVariables.editor_playing == true:
		loadLevel()
		GlobalVariables.editor_playing = false
	if not level.get_node_or_null("ExitSprite") == null:
		ExitAdder.disabled = true
	if not GlobalVariables.userdata.has("saved_levels"):
		GlobalVariables.userdata.saved_levels = []
#	$"Level Editor/Panel3".raise()
	VisualServer.set_default_clear_color(Color(0.682,0.682,0.682,1.0))
	displayButtons("white")
	Player.get_node("Camera2D").current = false
	#level.get_node("Player").connect("mouse_entered", self, "_on_Object_mouse_entered", [level.get_node("Player")])
	#level.get_node("Player").connect("mouse_exited", self, "_on_Object_mouse_exited", [level.get_node("Player")])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	if click == true:
	#	if Input.is_action_pressed("mousebutton"):
	#		current_selected = obj
	if color_pick == "white":
		OrbAdder.disabled = true
		HazardAdder.disabled = true
		PlayerColorButton.disabled = true
	else:
		OrbAdder.disabled = false
		HazardAdder.disabled = false
		PlayerColorButton.disabled = false
	if Input.is_action_pressed("ui_left") and level.position.x > -640:
		level.position.x += 8
	if Input.is_action_pressed("ui_right") and level.position.x < 1408:
		level.position.x -= 8
	if not current_selected == null:
		var m = level.get_local_mouse_position()
		if not Input.is_action_pressed("shift"):
			current_selected.position = Vector2(stepify(m.x, 8),stepify(m.y, 8))
		else:
			current_selected.position = Vector2(stepify(m.x, 1),stepify(m.y, 1))
#			level.data[h] = {"position": current_selected.position}
	else:
		var m = level.get_local_mouse_position()
		var x = level.get_children()
		x.erase(level.get_node("CanvasLayer"))
		for i in x:
			if "Player" == i.name or "Tile" in i.name or "tile" in i.name or "Hazard" in i.name:
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
	#	var x = 1
		add_object("Tilecostumes/Tile")
	#	while level.data.has(h):
	#		if level.data.has(h):
	#			h[-1] = str(x)
	#			x += 1
	#		else:
	#			level.data[h] = {}
	elif color_pick == "red":
		add_object("Tilecostumes/Redtile")
	elif color_pick == "blue":
		add_object("Tilecostumes/Bluetile")
	elif color_pick == "green":
		add_object("Tilecostumes/Greentile")
#	$"Level Editor"/Panel/PlayerAdder.disabled = true


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


#func _on_LoadButton_pressed():
#	$"Level Editor/Panel3".show()


func _on_LoadButton2_pressed():
	var n = $"Level Editor/Panel3/LineEdit".text
	var x = []
	if not GlobalVariables.userdata.saved_levels.empty():
		if GlobalVariables.userdata.saved_levels[0] is String:
			print(true)
		for i in GlobalVariables.userdata.saved_levels:
			x.append(i.data["name"])
		var r = x.find(n)
		if not r == -1:
			if GlobalVariables.userdata.saved_levels.has(GlobalVariables.userdata.saved_levels[r]):
				print(GlobalVariables.userdata.saved_levels[r])
				GlobalVariables.level = GlobalVariables.userdata.saved_levels[r]
				print(GlobalVariables.level)
				loadLevel()
		else:
			printerr("Level not found!")
	else:
		printerr("No levels!")


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

extends Node

const APTC_saveGame = "user://APTC_savegame.json"
const APTC_config = "user://APTC_config.json"

var editor : bool = false
var level : PackedScene = PackedScene.new()
var editor_playing : bool = false

var LevelNum : int = 1
var max_LevelNum : int = 1
var checkpoint : int = 0
var speedrun : bool = false
#var restart : bool = false
var speedrun_times
var userdata = {
	"levels_unlocked": max_LevelNum,
	speedrun_times = {},
	"saved_levels": []
}

var colorblind_mode = false
var BGcolors_off = false
var ButtonColors_off = false

const screensize : Vector2 = Vector2(768, 450)

var a
var b

func saveGame():
	var file = File.new()
	#file.open(APTC_saveGame, File.WRITE)
	file.open_encrypted_with_pass(APTC_saveGame, File.WRITE, "Synzoraflowersize98765132716")
	file.store_string(to_json(userdata))
	file.close()

func loadGame():
	var file = File.new()
	var config_file = ConfigFile.new()
	if file.file_exists(APTC_saveGame):
		#file.open(APTC_saveGame, File.READ)
		file.open_encrypted_with_pass(APTC_saveGame, File.READ, "Synzoraflowersize98765132716")
		userdata = parse_json(file.get_as_text())
		file.close()
	else:
		print("No saved data, making new game")
	if file.file_exists(APTC_config):
		config_file.load(APTC_config)
		colorblind_mode = config_file.get_value("UserConfig","colorblind_mode")
		BGcolors_off = config_file.get_value("UserConfig","BGcolors_off")
		ButtonColors_off = config_file.get_value("UserConfig","ButtonColors_off")
		BGmusic.stream_paused = config_file.get_value("UserConfig","muteSound")
	else:
		print("No config file")

func saveSettings():
	var file = ConfigFile.new()
	file.set_value("UserConfig","colorblind_mode", colorblind_mode)
	file.set_value("UserConfig","BGcolors_off", BGcolors_off)
	file.set_value("UserConfig","ButtonColors_off", ButtonColors_off)
	file.set_value("UserConfig","muteSound", BGmusic.stream_paused)
	file.save(APTC_config)

func disable(group, focus):
	var items = focus.get_tree().get_nodes_in_group(group)
	var itemsChecker = 0
	while itemsChecker < items.size():
		items[itemsChecker].hide()
		items[itemsChecker].get_node("CollisionShape2D").set_deferred("disabled", true)
		itemsChecker += 1

func enable(group, focus):
	var items = focus.get_tree().get_nodes_in_group(group)
	var itemsChecker = 0
	while itemsChecker < items.size():
		items[itemsChecker].show()
		items[itemsChecker].get_node("CollisionShape2D").set_deferred("disabled", false)
		itemsChecker += 1

func replace(group, new_item_path, focus, is_coloredItem : bool):
	var Player = focus.get_node("Player")
	var items = focus.get_tree().get_nodes_in_group(group)
	var items_index = []
	for itemsChecker in items:
		items_index.append(itemsChecker.get_index())
		focus.remove_child(itemsChecker)
		itemsChecker.queue_free()
	if not load("res://" + new_item_path + ".tscn") == null:
		for itemsChecker in range(items.size()):
			var replacee = load("res://" + new_item_path + ".tscn").instance()
			focus.call_deferred("add_child", replacee)
			if is_coloredItem:
				Player.connect("iamred", replacee, "_on_Player_iamred")
				Player.connect("iamblue", replacee, "_on_Player_iamblue")
				Player.connect("iamgreen", replacee, "_on_Player_iamgreen")
			if colorblind_mode:
				if items[itemsChecker].is_in_group("Orbs") or is_coloredItem:
					var label = preload("res://Art/Fonts/Colorblind_Label.tscn").instance()
					replacee.add_child(label)
					label.rect_position = Vector2(-16,0)
					if "Red" in replacee.name:
						label.text = "RED"
					elif "Blue" in replacee.name:
						label.text = "BLUE"
					elif "Green" in replacee.name:
						label.text = "GREEN"
			replacee.add_to_group(group)
			focus.call_deferred("move_child", replacee, items_index[itemsChecker])
			replacee.position = items[itemsChecker].position
	else:
		printerr("File not found")

func colorblind_mode_on(focus):
	var coloredItems = focus.get_tree().get_nodes_in_group("coloredItems") + focus.get_tree().get_nodes_in_group("Orbs")
	var Colorblind_Label = preload("res://Art/Fonts/Colorblind_Label.tscn")
	for check_coloredItems in coloredItems:
		var label = Colorblind_Label.instance()
		check_coloredItems.add_child(label)
		label.rect_position = Vector2(-16,0)
	#	focus.call_deferred("move_child", label, focus.get_children().size())
		if "Red" in check_coloredItems.name:
			label.text = "RED"
		elif "Blue" in check_coloredItems.name:
			label.text = "BLUE"
		elif "Green" in check_coloredItems.name:
			label.text = "GREEN"

func colorblind_mode_off(focus):
	var labels = focus.get_tree().get_nodes_in_group("colorblind")
	for check_labels in labels:
		check_labels.free()

func replace_switch(item, switch_color, focus, signal_id):
	var Player = focus.get_node("Player")
	var mainItem = focus.get_tree().get_nodes_in_group(item)[0]
	var time = mainItem.get_node("Timer").get_time_left()
	var item_index = mainItem.get_index()
	var replacee = load("res://Switches/" + switch_color + "Switch.tscn").instance()
	focus.call_deferred("add_child", replacee)
	var timer = replacee.get_node("Timer")
	if not time == 0:
		timer.set_autostart(true)
		timer.set_wait_time(time)
	if not mainItem.get_node("Sprite").flip_h:
		replacee.state = true
		replacee.get_node("Sprite").flip_h = true
	else:
		replacee.state = false
		replacee.get_node("Sprite").flip_h = false
	mainItem.queue_free()
	Player.connect("iamred", replacee, "_on_Player_iamred")
	Player.connect("iamblue", replacee, "_on_Player_iamblue")
	Player.connect("iamgreen", replacee, "_on_Player_iamgreen")
	replacee.add_to_group(item)
	focus.call_deferred("move_child", replacee, item_index)
	replacee.position = mainItem.position
	replacee.connect("switchon", focus, "_on_Switch" + signal_id + "_switchon")
	replacee.connect("switchoff", focus, "_on_Switch" + signal_id + "_switchoff")
	if colorblind_mode:
		var label = preload("res://Art/Fonts/Colorblind_Label.tscn").instance()
		replacee.add_child(label)
		label.rect_position = Vector2(-16,0)
		if "Red" in replacee.name:
			label.text = "RED"
		elif "Blue" in replacee.name:
			label.text = "BLUE"
		elif "Green" in replacee.name:
			label.text = "GREEN"
	#print(mainItem.state)
	#print(replacee.state)
	#print(replacee.get_node("Sprite").flip_h)

func replace_teleporter(group, teleporter_color, focus, nonGroup):
	var items = focus.get_tree().get_nodes_in_group(group)
	var nonGroupItems = focus.get_tree().get_nodes_in_group(nonGroup)
	var new_items = []
	var player = focus.get_node("Player")

	for item in items:
		# Simplified first loop
		var index = item.get_index()
		focus.remove_child(item)
		# Second loop created the replacement teleporter
		var replacee = load("res://Teleporters/" + teleporter_color + "Teleporter.tscn").instance()
		replacee.add_to_group(group)
		replacee.position = item.position
		replacee.connectedTeleporter = item.connectedTeleporter
		focus.call_deferred("add_child", replacee)
		focus.call_deferred("move_child", replacee, index)
		new_items.append(replacee)
		
		# Copy signals from old item to the replacee
		# Take a look at something like "for s in item.get_signal_list" if you've got lots of signal bindings
			
		# Not sure what these ones are doing
		# If all teleporter nodes have iamX signals and the player has to listen
		# to all of them I'd create a player group and have the teleporters call_group instead
		player.connect("iamred", replacee, "_on_Player_iamred")
		player.connect("iamblue", replacee, "_on_Player_iamblue")
		player.connect("iamgreen", replacee, "_on_Player_iamgreen")
		
		if colorblind_mode:
			var label = preload("res://Art/Fonts/Colorblind_Label.tscn").instance()
			replacee.add_child(label)
			label.rect_position = Vector2(-16,0)
			if "Red" in replacee.name:
				label.text = "RED"
			elif "Blue" in replacee.name:
				label.text = "BLUE"
			elif "Green" in replacee.name:
				label.text = "GREEN"
		
		for nonGroupNode in nonGroupItems:
			if replacee.position == nonGroupNode.connectedTeleporter.position:# and nonGroupNode.get_signal_connection_list("teleportPlayer").empty():
				nonGroupNode.connect("teleportPlayer", replacee, "_on_Teleporter_teleportPlayer")
				nonGroupNode.connectedTeleporter = replacee
			if nonGroupNode.position == replacee.connectedTeleporter.position:# and replacee.get_signal_connection_list("teleportPlayer").empty():
				replacee.connect("teleportPlayer", nonGroupNode, "_on_Teleporter_teleportPlayer")
				replacee.connectedTeleporter = nonGroupNode
		# Moved this down. Since it's just queueing a free it won't matter.
		# I just feel bad referencing something I've called queue_free on
		item.queue_free()
	for newNode in new_items:
		var teleporter_connection = newNode.connectedTeleporter

		for secondNode in new_items:
			if secondNode.position == teleporter_connection.position and newNode.get_signal_connection_list("teleportPlayer").empty():
				newNode.connect("teleportPlayer", secondNode, "_on_Teleporter_teleportPlayer")
				newNode.connectedTeleporter = secondNode
				break

extends Node2D
class_name Level

onready var Player = $Player
onready var Camera = Player.c
export (int) var level_num = 1

enum SC { #Switch Control
	DISABLE, #0 - Disables objects in specific group. Second argument is group code. - Format: "String", Switchoff: ENABLE (1)
	ENABLE, #1 - Enables objects in specific group. Second argument is group code. - Format: "String", Switchoff: DISABLE (0)
	TELEPORT, #2 - Teleports player to specific location. Second argument is position. - Format: Vector2()
	REPLACE, #3 - Replaces objects in specific group. Second argument is group code. Third argument is new type of objects. Fourth argument is old type of objects. - 2nd Format: "String", 3rd Format: "String", 4th Format/Switchoff: "String"
	REPLACE_S, #4 - Replaces one switch color. Second argument is switch name. Third argument is new color. Fourth argument is old color. Fifth Argument is new switch function. - 2nd Format: "String", 3rd Format: "String", 4th Format/Switchoff: "String", 5th Format: [Array]
	REPLACE_T, #5 - Replaces teleporter colors in specific group. Second argument is teleport group. Third argument is new color. Fourth argument is old color. - 2nd Format: "String", 3rd Format: "String", 4th Format/Switchoff: "String"
}

# Arrays of Switches. Switch Init is the beginning configuration.
export (Array) var switch_init = []

func _enter_tree():
	GlobalVariables.LevelNum = level_num
func _ready():
	if not switch_init.empty():
		for i in switch_init:
			match i[0]:
				SC.DISABLE:
					disable("switch"+i[1])
				SC.ENABLE:
					enable("switch"+i[1])

func _on_switchon(switch_function:Array):
	for i in switch_function:
		match i[0]:
			SC.DISABLE:
				disable("switch"+i[1])
			SC.ENABLE:
				enable("switch"+i[1])
			SC.TELEPORT:
				Player.position = i[1]
			SC.REPLACE:
				if i[2] == "Tilecostumes/Tile":
					replace("switch"+i[1], "Tilecostumes/Tile", false)
				else:
					replace("switch"+i[1], i[2])

func _on_switchoff(switch_function:Array):
	for i in switch_function:
		match i[0]:
			SC.DISABLE:
				enable("switch"+i[1])
			SC.ENABLE:
				disable("switch"+i[1])
			SC.TELEPORT:
				Player.position = i[1]
			SC.REPLACE:
				if i[3] == "Tilecostumes/Tile":
					replace("switch"+i[1], "Tilecostumes/Tile", false)
				else:
					replace("switch"+i[1], i[3])
			SC.REPLACE_S:
				if i[3] == "Tilecostumes/Tile":
					replace("switch"+i[1], "Tilecostumes/Tile", false)
				else:
					replace("switch"+i[1], i[3])

func disable(group:String):
	var items = get_tree().get_nodes_in_group(group)
	for itemsChecker in items:
		itemsChecker.hide()
		itemsChecker.get_node("CollisionShape2D").set_deferred("disabled", true)

func enable(group:String):
	var items = get_tree().get_nodes_in_group(group)
	for itemsChecker in items:
		itemsChecker.show()
		itemsChecker.get_node("CollisionShape2D").set_deferred("disabled", false)

func replace(group:String, new_item_path : String, is_coloredItem : bool = true):
	var items = get_tree().get_nodes_in_group(group)
	var items_index = []
	for itemsChecker in items:
		items_index.append(itemsChecker.get_index())
		remove_child(itemsChecker)
		itemsChecker.queue_free()
	if not load("res://" + new_item_path + ".tscn") == null:
		for itemsChecker in range(items.size()):
			var replacee = load("res://" + new_item_path + ".tscn").instance()
			call_deferred("add_child", replacee)
			if is_coloredItem:
				Player.connect("iamred", replacee, "_on_Player_iamred")
				Player.connect("iamblue", replacee, "_on_Player_iamblue")
				Player.connect("iamgreen", replacee, "_on_Player_iamgreen")
			if GlobalVariables.colorblind_mode:
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
			call_deferred("move_child", replacee, items_index[itemsChecker])
			replacee.position = items[itemsChecker].position
	else:
		printerr("File not found")

func colorblind_mode_on():
	var coloredItems = get_tree().get_nodes_in_group("coloredItems") + get_tree().get_nodes_in_group("Orbs")
	var Colorblind_Label = preload("res://Art/Fonts/Colorblind_Label.tscn")
	for check_coloredItems in coloredItems:
		var label = Colorblind_Label.instance()
		check_coloredItems.add_child(label)
		if "Red" in check_coloredItems.name:
			label.text = "RED"
		elif "Blue" in check_coloredItems.name:
			label.text = "BLUE"
		elif "Green" in check_coloredItems.name:
			label.text = "GREEN"

func colorblind_mode_off():
	var labels = get_tree().get_nodes_in_group("colorblind")
	for check_labels in labels:
		check_labels.free()

func replace_switch(item, switch_color, switch_function:Array=[]):
	var mainItem = get_node(item)
	var time = mainItem.t.get_time_left()
	var item_index = mainItem.get_index()
	var replacee = load("res://Switches/" + switch_color + "Switch.tscn").instance()
	call_deferred("add_child", replacee)
	var timer = replacee.t
	if not time == 0:
		timer.set_autostart(true)
		timer.set_wait_time(time)
	replacee.state = !mainItem.s.flip_h
	replacee.s.flip_h = replacee.state
	Player.connect("iamred", replacee, "_on_Player_iamred")
	Player.connect("iamblue", replacee, "_on_Player_iamblue")
	Player.connect("iamgreen", replacee, "_on_Player_iamgreen")
	call_deferred("move_child", replacee, item_index)
	replacee.position = mainItem.position
	if not switch_function.empty():
		replacee.switch_function = switch_function
	mainItem.queue_free()
	if GlobalVariables.colorblind_mode:
		var label = preload("res://Art/Fonts/Colorblind_Label.tscn").instance()
		replacee.add_child(label)
		label.rect_position = Vector2(-16,0)
		if "Red" in replacee.name:
			label.text = "RED"
		elif "Blue" in replacee.name:
			label.text = "BLUE"
		elif "Green" in replacee.name:
			label.text = "GREEN"

func replace_teleporter(group, teleporter_color, non_group):
	var items = get_tree().get_nodes_in_group(group)
	var non_groupitems = get_tree().get_nodes_in_group(non_group)
	var new_items = []
	for item in items:
		var index = item.get_index()
		remove_child(item)
		var replacee = load("res://Teleporters/" + teleporter_color + "Teleporter.tscn").instance()
		replacee.add_to_group(group)
		replacee.position = item.position
		replacee.connectedTeleporter = item.connectedTeleporter
		call_deferred("add_child", replacee)
		call_deferred("move_child", replacee, index)
		new_items.append(replacee)
		Player.connect("iamred", replacee, "_on_Player_iamred")
		Player.connect("iamblue", replacee, "_on_Player_iamblue")
		Player.connect("iamgreen", replacee, "_on_Player_iamgreen")
		if GlobalVariables.colorblind_mode:
			var label = preload("res://Art/Fonts/Colorblind_Label.tscn").instance()
			replacee.add_child(label)
			label.rect_position = Vector2(-16,0)
			if "Red" in replacee.name:
				label.text = "RED"
			elif "Blue" in replacee.name:
				label.text = "BLUE"
			elif "Green" in replacee.name:
				label.text = "GREEN"
		for non_groupnode in non_groupitems:
			if replacee.position == non_groupnode.connectedTeleporter.position:
				non_groupnode.connect("teleportPlayer", replacee, "_on_Teleporter_teleportPlayer")
				non_groupnode.connectedTeleporter = replacee
			if non_groupnode.position == replacee.connectedTeleporter.position:
				replacee.connect("teleportPlayer", non_groupnode, "_on_Teleporter_teleportPlayer")
				replacee.connectedTeleporter = non_groupnode
		item.queue_free()
	for new_node in new_items:
		var teleporter_connection = new_node.connectedTeleporter
		for second_node in new_items:
			if second_node.position == teleporter_connection.position and new_node.get_signal_connection_list("teleportPlayer").empty():
				new_node.connect("teleportPlayer", second_node, "_on_Teleporter_teleportPlayer")
				new_node.connectedTeleporter = second_node
				break

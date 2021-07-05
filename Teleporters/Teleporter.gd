extends Area2D
class_name Teleporter

signal teleportPlayer
onready var Player = $"../Player"
onready var Timer = $"../TeleportTimer"
onready var c = $CollisionShape2D
export (String) var connectedTeleporterName : String
var connectedTeleporter : Teleporter
export (String) var color : String = "white"

func _ready():
	if not connectedTeleporterName.empty():
		connect("teleportPlayer", get_node("../"+connectedTeleporterName),"_on_Teleporter_teleportPlayer")
	if not get_signal_connection_list("teleportPlayer").empty():
		connectedTeleporter = get_signal_connection_list("teleportPlayer")[0]["target"]
	

func _on_Teleporter_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body == Player and Timer.get_time_left() == 0:
		emit_signal("teleportPlayer")
		Timer.start()

func _on_Teleporter_teleportPlayer():
	if is_visible():
		Player.position = position

func _on_Player_iamblue():
	c = $CollisionShape2D
	if not c.disabled and not color == "blue":
		c.disabled = true
	elif c.disabled and is_visible() and color == "blue":
		c.disabled = false

func _on_Player_iamred():
	c = $CollisionShape2D
	if not c.disabled and not color == "red":
		c.disabled = true
	elif c.disabled and is_visible() and color == "red":
		c.disabled = false


func _on_Player_iamgreen():
	c = $CollisionShape2D
	if not c.disabled and not color == "green":
		c.disabled = true
	elif c.disabled and is_visible() and color == "green":
		c.disabled = false

extends Area2D

signal teleportPlayer
onready var Player = $"../Player"
onready var Timer = $"../TeleportTimer"
onready var c = $CollisionShape2D
var connectedTeleporter

# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_signal_connection_list("teleportPlayer").empty():
		connectedTeleporter = get_signal_connection_list("teleportPlayer")[0]["target"]
	if position.x == 0 and position.y == 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Teleporter_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and Timer.get_time_left() == 0:
		emit_signal("teleportPlayer")
		Timer.start()

func _on_Teleporter_teleportPlayer():
	if is_visible() == true:
		Player.position = position

func _on_Player_iamblue():
	c = $CollisionShape2D
	if c.disabled == true and is_visible() == true:
		c.disabled = false


func _on_Player_iamred():
	c = $CollisionShape2D
	if c.disabled == false:
		c.disabled = true

func _on_Player_iamgreen():
	c = $CollisionShape2D
	if c.disabled == false:
		c.disabled = true

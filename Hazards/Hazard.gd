extends Area2D
class_name Hazard

signal restartcheckpoint
onready var c = $CollisionShape2D
onready var s = $Sprite
export (String) var color : String = "white"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pause_mode(Node.PAUSE_MODE_PROCESS)
	#if GlobalVariables.LevelNum == 10:
	#	connect("restartcheckpoint", $"../Checkpoint_Level10", "_on_Player_restartcheckpoint")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	s.rotation_degrees += 90 * delta



func _on_Player_iamblue():
	c = $CollisionShape2D
	if not c.disabled and color == "blue":
		c.disabled = true
	elif c.disabled and is_visible() and not color == "blue":
		c.disabled = false

func _on_Player_iamred():
	c = $CollisionShape2D
	if not c.disabled and color == "red":
		c.disabled = true
	elif c.disabled and is_visible() and not color == "red":
		c.disabled = false


func _on_Player_iamgreen():
	c = $CollisionShape2D
	if not c.disabled and color == "green":
		c.disabled = true
	elif c.disabled and is_visible() and not color == "green":
		c.disabled = false


func _on_Hazard_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and not GlobalVariables.editor:
		if GlobalVariables.delayDeath_off:
			body.d.emit_signal("timeout")
		else:
			body.d.start()
			get_tree().paused = true

extends Area2D

signal switchon
signal switchoff
var state : bool
onready var c = $CollisionShape2D
onready var s = $Sprite
onready var t = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.checkpoint == 0:
		state = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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



func _on_Switch_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and t.get_time_left() == 0:
		t.start()
		if state == false:
			emit_signal("switchon")
			s.flip_h = true
			state = true
		elif state == true:
			emit_signal("switchoff")
			s.flip_h = false
			state = false

extends Area2D

signal restartcheckpoint
onready var c = $CollisionShape2D
onready var s = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.LevelNum == 10:
		connect("restartcheckpoint", $"../Checkpoint_Level10", "_on_Player_restartcheckpoint")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	s.rotation_degrees += 90 * delta


func _on_Player_iamblue():
	c = $CollisionShape2D
	if c.disabled == false:
		c.disabled = true


func _on_Player_iamred():
	c = $CollisionShape2D
	if c.disabled == true and is_visible() == true:
		c.disabled = false


func _on_Player_iamgreen():
	c = $CollisionShape2D
	if c.disabled == true and is_visible() == true:
		c.disabled = false

func _on_Hazard_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and GlobalVariables.editor == false: 
		if GlobalVariables.checkpoint == 0:
			if GlobalVariables.LevelNum == 999:
				get_parent().restart()
			else:
				get_tree().reload_current_scene()
		else:
			emit_signal("restartcheckpoint")

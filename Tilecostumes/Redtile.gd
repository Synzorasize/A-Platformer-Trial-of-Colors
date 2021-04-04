extends StaticBody2D


onready var c = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Player_iamred():
	c = $CollisionShape2D
	if not c.disabled:
		c.disabled = true


func _on_Player_iamblue():
	c = $CollisionShape2D
	if c.disabled and is_visible():
		c.disabled = false


func _on_Player_iamgreen():
	c = $CollisionShape2D
	if c.disabled and is_visible():
		c.disabled = false

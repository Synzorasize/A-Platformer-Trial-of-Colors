extends StaticBody2D


onready var c = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Player_iamred():
	c = $CollisionShape2D
	if c.disabled == false:
		c.disabled = true


func _on_Player_iamblue():
	c = $CollisionShape2D
	if c.disabled == true and is_visible() == true:
		c.disabled = false


func _on_Player_iamgreen():
	c = $CollisionShape2D
	if c.disabled == true and is_visible() == true:
		c.disabled = false
